//
//  EmailViewController.m
//  PocketDoctor
//
//  Created by vishnu on 09/12/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import "EmailViewController.h"
#import "UIColor+UIColorCategory.h"
#import "JSON.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "Constants.h"
#import "SendEmail.h"
#import "EmailConversation.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@interface EmailViewController ()

@end
@implementation EmailViewController

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - View Life Cycle
/////////////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate=(LoginAppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
    
    
    backBtn=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"l-arrow-ico.png"]];
    [backBtn setFrame:CGRectMake(9, 9, 20, 20)];
    [self.view addSubview:backBtn];
    
    backBtnTitle=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtnTitle setFrame:CGRectMake(5, 8, 90, 25)];
    [backBtnTitle setTitle:@"Back" forState:UIControlStateNormal];
    backBtnTitle.titleLabel.font=[UIFont fontWithName:@"Arial" size:18.0];
    [backBtnTitle setTitleColor:[UIColor colorWithHexString:@"#316CBA"] forState:UIControlStateNormal];
    [backBtnTitle addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtnTitle];
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(85, 155, 150, 150)];
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    loadingView.clipsToBounds = YES;
    loadingView.layer.cornerRadius = 10.0;
//    NSURL *url = [NSURL URLWithString:@"facetime://+9725361159"];
//    [[UIApplication sharedApplication] openURL:url];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(55, 40, activityView.bounds.size.width, activityView.bounds.size.height);
    [loadingView addSubview:activityView];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 105, 130, 22)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"Loading...";
    [loadingView addSubview:loadingLabel];
    
    [self.view addSubview:loadingView];
    
    appointmentsTableView=[[UITableView alloc]initWithFrame:CGRectMake(20, 40, 290, 350) style:UITableViewStylePlain];
    appointmentsTableView.delegate=self;
    appointmentsTableView.dataSource=self;
    appointmentsTableView.backgroundView=nil;
    [self.view addSubview:appointmentsTableView];
    appointmentsTableView.hidden=YES;
   UIButton *newEmailAppointment=[UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPHONE_5)
    {
        newEmailAppointment.frame=CGRectMake(33, 515, 255, 40);
    }
    else
    {
        newEmailAppointment.frame=CGRectMake(33, 420, 255, 40);
    }
    
    [newEmailAppointment setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
    newEmailAppointment.layer.cornerRadius=7;
    [newEmailAppointment setTitle:@"Request New Appointment" forState:UIControlStateNormal];
    newEmailAppointment.titleLabel.font=[UIFont fontWithName:@"Arial" size:20.0];
    [newEmailAppointment addTarget:self action:@selector(RequestNewAppointment:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newEmailAppointment];
    
    // Do any additional setup after loading the view from its nib.
}


//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Checking Internet
/////////////////////////////////////////////////////////////////////////////////

-(void)internetCheck
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" message:@"NO Internet Connection" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        alert.tag=1111;
        [alert show];
        
    }
    else if(remoteHostStatus == ReachableViaWiFi)
    {
        [activityView startAnimating];
        if(isGet==YES)
        {
            [self getConversation];
        }
        else
        {
            [self getCustomerAppointment];
        }
        
        
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        [activityView startAnimating];
        if(isGet==YES)
        {
            [self getConversation];
        }
        else
        {
            [self getCustomerAppointment];
        }
        
    }
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Alert View Delegate Method
/////////////////////////////////////////////////////////////////////////////////

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1111)
    {
        if(buttonIndex==0)
        {
            [self internetCheck];
        }
    }
}


//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Get Booked Appointment Details
/////////////////////////////////////////////////////////////////////////////////

-(void)getCustomerAppointment
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/getCustAppointmentListing", [appDelegate domainURl]]];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    NSString *dataString = [NSString stringWithFormat:@"app=%@&id=%@&cust_id=%@&app_id=%@",kappname ,[appDelegate domainId],[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"cust_id"],@"3"];
    
    NSMutableData *requestBody = [[NSMutableData alloc] initWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    [request setPostBody:requestBody];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    [request setDelegate:self];
    [request startSynchronous];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Get Booked Appointment Details
/////////////////////////////////////////////////////////////////////////////////

-(void)getConversation
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/GetEmailConversation", [appDelegate domainURl]]];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    NSString *dataString = [NSString stringWithFormat:@"app=%@&id=%@&cust_id=%@&appointment_id=%@",kappname ,[appDelegate domainId],[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"cust_id"],strAppId];
    
    NSMutableData *requestBody = [[NSMutableData alloc] initWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    [request setPostBody:requestBody];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    [request setDelegate:self];
    [request startSynchronous];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - ASIFormData Request Started
/////////////////////////////////////////////////////////////////////////////////

- (void)requestStarted:(ASIHTTPRequest *)request
{
    //start activity indicator on download start
    
}


//////////////////////////////////////////////////////////////////////////////////
#pragma mark - ASIHttpData Request Finished
/////////////////////////////////////////////////////////////////////////////////

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSString *str=[request responseString];
    //NSLog(@"XML response is %@",str);
    [activityView stopAnimating];
    [loadingView removeFromSuperview];
    NSDictionary *responseDictionary = [[request responseString] JSONValue];
    NSLog(@"dict is %@",responseDictionary);
    if(isGet==YES)
    {
        isGet=NO;
        [activityView stopAnimating];
        [loadingView removeFromSuperview];
         [[LoginAppDelegate getEmailConversation]setObject:[responseDictionary objectForKey:@"posts"] forKey:@"Conversation"];
        EmailConversation *emailConver=[[EmailConversation alloc]initWithNibName:strAppId];
        [self.navigationController pushViewController:emailConver animated:YES];
    }
    else
    {
        if([[[responseDictionary valueForKey:  @"posts"]valueForKey:@"result"]count]==0)
        {
//            [activityView stopAnimating];
//            [loadingView removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please book an appointment with our doctor by clicking Request New Appointment." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [activityView startAnimating];
            [self.view addSubview:loadingView];
            appointmentsTableView.hidden=NO;
            [[LoginAppDelegate getBookedAppointments]setObject:[responseDictionary objectForKey:@"posts"] forKey:@"BookedAppointments"];
            [appointmentsTableView reloadData];
        }
    }
    
}

////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view datasource
////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [[[[LoginAppDelegate getBookedAppointments]objectForKey:@"BookedAppointments"] valueForKey:@"result"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UIImageView *balloonView;
//    UILabel *label;
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//        balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        balloonView.tag = 1;
//        
//        label = [[UILabel alloc] initWithFrame:CGRectZero];
//        label.backgroundColor = [UIColor clearColor];
//        label.tag = 2;
//        label.numberOfLines = 0;
//        label.lineBreakMode = NSLineBreakByWordWrapping;
//        label.font = [UIFont systemFontOfSize:14.0];
//        
//        UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
//        message.tag = 0;
//        [message addSubview:balloonView];
//        [message addSubview:label];
//        [cell.contentView addSubview:message];
//        
////        [balloonView release];
////        [label release];
////        [message release];
//    }
//    else
//    {
//        balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
//        label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
//    }
//    
//    NSString *text = @"Dear Andrew , Our suggestion for this condition is AMOXICILLIN 500mg 3 times for 7 days and OTOSPORIN ear drops ( 3 drops should be instilled into the affected ear three or four times daily ). A paper script will be posted to your address . Please let us know if you are happy for us to proceed. Regards Dr S. Poupalos";
//    
//   CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:NSLineBreakByWordWrapping];
//    
//    UIImage *balloon;
//    
//    
//    balloonView.frame = CGRectMake(20.0, 2.0, size.width + 28, size.height + 15);
//    balloon = [[UIImage imageNamed:@"bubbleFlatIn.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
//    label.frame = CGRectMake(36, 8, size.width + 5, size.height);
//    
//    
//    balloonView.image = balloon;
//    label.text = text;
//    
//    return cell;
    UILabel *appId;
    UILabel *appSubject;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        appId=[[UILabel alloc]initWithFrame:CGRectMake(10, 8, 140, 20)];
        appId.backgroundColor=[UIColor clearColor];
        appId.textColor=[UIColor grayColor];
        [appId setTag:1000];
        [cell.contentView addSubview:appId];
        
        appSubject = [[UILabel alloc] initWithFrame:CGRectMake(75, 8, 140, 20 )];
        [appSubject setLineBreakMode:NSLineBreakByWordWrapping];
        [appSubject setMinimumScaleFactor:14.0];
        [appSubject setNumberOfLines:0];
        appSubject.textColor=[UIColor grayColor];
        appSubject.backgroundColor=[UIColor clearColor];
        [appSubject setFont:[UIFont systemFontOfSize:14.0]];
        [appSubject setTag:1001];
        [[cell contentView] addSubview:appSubject];
        
    }
    
    [activityView stopAnimating];
    [loadingView removeFromSuperview];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    appId.text= [[[[[LoginAppDelegate getBookedAppointments]objectForKey:@"BookedAppointments"] valueForKey:@"result"]objectAtIndex:indexPath.row]valueForKey:@"appointment_id"];
    
    appSubject.text= [[[[[LoginAppDelegate getBookedAppointments]objectForKey:@"BookedAppointments"] valueForKey:@"result"]objectAtIndex:indexPath.row]valueForKey:@"appointment_subject"];
    return cell;
    
}

////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view delegate
////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isGet=YES;
    [activityView startAnimating];
    [self.view addSubview:loadingView];

    strAppId=[[[[[LoginAppDelegate getBookedAppointments]objectForKey:@"BookedAppointments"] valueForKey:@"result"]objectAtIndex:indexPath.row]valueForKey:@"appointment_id"];
    
    [self internetCheck];
    
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - viewWillAppear
/////////////////////////////////////////////////////////////////////////////////

-(void)viewWillAppear:(BOOL)animated
{
    [self internetCheck];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Back Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Request New Appointment Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)RequestNewAppointment:(UIButton*)sender
{
    SendEmail *emailBooking=[[SendEmail alloc]initWithNibName:@"SendEmail" bundle:nil];
    [self.navigationController pushViewController:emailBooking animated:YES];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Memory Management
/////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

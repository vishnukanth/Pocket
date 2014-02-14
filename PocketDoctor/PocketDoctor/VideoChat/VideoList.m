//
//  VideoList.m
//  PocketDoctor
//
//  Created by vishnu on 11/12/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import "VideoList.h"
#import "UIColor+UIColorCategory.h"
#import "JSON.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "Constants.h"
#import "SendVideoAppointment.h"
@interface VideoList ()

@end

@implementation VideoList
@synthesize isTelephone,isVideo;
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
    if(isVideo==YES)
    {
        UIImage *videoImage=[UIImage imageNamed:@"video-chat-blue-icon.png"];
        UIImageView *videoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 46, videoImage.size.width, videoImage.size.height)];
        videoImgView.image=videoImage;
        [self.view addSubview:videoImgView];
        
        UILabel *nextApptLbl=[[UILabel alloc]initWithFrame:CGRectMake(65, 46, 190, 30)];
        nextApptLbl.backgroundColor=[UIColor clearColor];
        nextApptLbl.text=@"Next Appointment";
        nextApptLbl.textColor=[UIColor colorWithHexString:@"#473590"];
        nextApptLbl.font=[UIFont fontWithName:@"Helvetica" size:22.0];
        [self.view addSubview:nextApptLbl];
    }
    else if (isTelephone==YES)
    {
    UIImage *videoImage=[UIImage imageNamed:@"telephone-blue-icon.png"];
    UIImageView *videoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 46, videoImage.size.width, videoImage.size.height)];
    videoImgView.image=videoImage;
    [self.view addSubview:videoImgView];
    
    UILabel *nextApptLbl=[[UILabel alloc]initWithFrame:CGRectMake(65, 46, 190, 30)];
    nextApptLbl.backgroundColor=[UIColor clearColor];
    nextApptLbl.text=@"Next Appointment";
    nextApptLbl.textColor=[UIColor colorWithHexString:@"#473590"];
    nextApptLbl.font=[UIFont fontWithName:@"Helvetica" size:22.0];
    [self.view addSubview:nextApptLbl];
    }
    
    
    
   
    // Do any additional setup after loading the view from its nib.
}



//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Back Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Memory Management
/////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - RequestNewAppointment Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)RequestVideoAppointment:(UIButton*)sender
{
    SendVideoAppointment *newAppointView=[[SendVideoAppointment alloc]initWithNibName:@"SendVideoAppointment" bundle:nil];
    if(isVideo==YES)
    {
        newAppointView.isVideos=YES;
        newAppointView.isTelephone=NO;
    }
    else if (isTelephone==YES)
    {
        newAppointView.isTelephone=YES;
        newAppointView.isVideos=NO;
    }
    [self.navigationController pushViewController:newAppointView animated:YES];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - viewwillAppear
/////////////////////////////////////////////////////////////////////////////////

-(void)viewWillAppear:(BOOL)animated
{
    [self internetCheck];
    
   
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
        
        
        [self getAppointments];
        
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        
        [self getAppointments];
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
#pragma mark - Get Appointments From Server
/////////////////////////////////////////////////////////////////////////////////

-(void)getAppointments
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/getCustAllAppointment", [appDelegate domainURl]]];
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
   
    NSDictionary *responseDictionary = [[request responseString] JSONValue];
    NSLog(@"dict is %@",responseDictionary);
    if([[responseDictionary valueForKey:  @"posts"]valueForKey:@"result"]==[NSNull null])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please book an appointment with our doctor by clicking Request New Appointment." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        UIButton *newVideoAppointment=[UIButton buttonWithType:UIButtonTypeCustom];
        newVideoAppointment.frame=CGRectMake(33, 80, 255, 40);
        [newVideoAppointment setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
        newVideoAppointment.layer.cornerRadius=7;
        [newVideoAppointment setTitle:@"Request New Appointment" forState:UIControlStateNormal];
        newVideoAppointment.titleLabel.font=[UIFont fontWithName:@"Arial" size:20.0];
        [newVideoAppointment addTarget:self action:@selector(RequestVideoAppointment:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:newVideoAppointment];
        
    }
    else if([[[responseDictionary valueForKey:  @"posts"]valueForKey:@"result"]count]==0)
    {
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please book an appointment with our doctor by clicking Request New Appointment." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        UIButton *newVideoAppointment=[UIButton buttonWithType:UIButtonTypeCustom];
        newVideoAppointment.frame=CGRectMake(33, 80, 255, 40);
        [newVideoAppointment setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
        newVideoAppointment.layer.cornerRadius=7;
        [newVideoAppointment setTitle:@"Request New Appointment" forState:UIControlStateNormal];
        newVideoAppointment.titleLabel.font=[UIFont fontWithName:@"Arial" size:20.0];
        [newVideoAppointment addTarget:self action:@selector(RequestVideoAppointment:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:newVideoAppointment];
    }
    else
    {
        [[LoginAppDelegate getAVAppointments]setObject:[responseDictionary objectForKey:@"posts"] forKey:@"AllAppointments"];
        DateArray=[[NSMutableArray alloc]init];
        TimeArray=[[NSMutableArray alloc]init];
        NextDateArray=[[NSMutableArray alloc]init];
        NextTimeArray=[[NSMutableArray alloc]init];
        [self getSkype];
        if([NextTimeArray count]==0)
        {
            UIButton *newVideoAppointment=[UIButton buttonWithType:UIButtonTypeCustom];
            newVideoAppointment.frame=CGRectMake(33, 80, 255, 40);
            [newVideoAppointment setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
            newVideoAppointment.layer.cornerRadius=7;
            [newVideoAppointment setTitle:@"Request New Appointment" forState:UIControlStateNormal];
            newVideoAppointment.titleLabel.font=[UIFont fontWithName:@"Arial" size:20.0];
            [newVideoAppointment addTarget:self action:@selector(RequestVideoAppointment:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:newVideoAppointment];
            
            if(isVideo==YES)
            {
                UIImage *videoImageHistory=[UIImage imageNamed:@"video-chat-gray-icon.png"];
                UIImageView *videoHistoryImgView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 145, videoImageHistory.size.width, videoImageHistory.size.height)];
                videoHistoryImgView.image=videoImageHistory;
                [self.view addSubview:videoHistoryImgView];
                
                UILabel *apptHistory=[[UILabel alloc]initWithFrame:CGRectMake(65, 145, 210, 30)];
                apptHistory.backgroundColor=[UIColor clearColor];
                apptHistory.text=@"Appointment History";
                apptHistory.textColor=[UIColor colorWithHexString:@"#646b6c"];
                apptHistory.font=[UIFont fontWithName:@"Helvetica" size:22.0];
                [self.view addSubview:apptHistory];
                if([DateArray count]!=0)
                {
                    videoApptTableView=[[UITableView alloc]initWithFrame:CGRectMake(33, 180, 255, 290) style:UITableViewStylePlain];
                    videoApptTableView.delegate=self;
                    videoApptTableView.dataSource=self;
                    videoApptTableView.backgroundView=nil;
                    [self.view addSubview:videoApptTableView];
                }
                

            }
            else if (isTelephone==YES)
            {
                UIImage *videoImageHistory=[UIImage imageNamed:@"telephone-gray-icon.png"];
                UIImageView *videoHistoryImgView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 145, videoImageHistory.size.width, videoImageHistory.size.height)];
                videoHistoryImgView.image=videoImageHistory;
                [self.view addSubview:videoHistoryImgView];
                
                UILabel *apptHistory=[[UILabel alloc]initWithFrame:CGRectMake(65, 145, 210, 30)];
                apptHistory.backgroundColor=[UIColor clearColor];
                apptHistory.text=@"Appointment History";
                apptHistory.textColor=[UIColor colorWithHexString:@"#646b6c"];
                apptHistory.font=[UIFont fontWithName:@"Helvetica" size:22.0];
                [self.view addSubview:apptHistory];
                if([DateArray count]!=0)
                {
                    videoApptTableView=[[UITableView alloc]initWithFrame:CGRectMake(33, 180, 255, 290) style:UITableViewStylePlain];
                    videoApptTableView.delegate=self;
                    videoApptTableView.dataSource=self;
                    videoApptTableView.backgroundView=nil;
                    [self.view addSubview:videoApptTableView];
                }

            }
        }
        else
        {
            nextAppointmentTableView=[[UITableView alloc]initWithFrame:CGRectMake(33, 80, 255, 100) style:UITableViewStylePlain];
            nextAppointmentTableView.delegate=self;
            nextAppointmentTableView.tag=555;
            nextAppointmentTableView.dataSource=self;
            nextAppointmentTableView.backgroundView=nil;
            [self.view addSubview:nextAppointmentTableView];
            
            
            UIButton *newVideoAppointment=[UIButton buttonWithType:UIButtonTypeCustom];
            newVideoAppointment.frame=CGRectMake(33, 200, 255, 40);
            [newVideoAppointment setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
            newVideoAppointment.layer.cornerRadius=7;
            [newVideoAppointment setTitle:@"Request New Appointment" forState:UIControlStateNormal];
            newVideoAppointment.titleLabel.font=[UIFont fontWithName:@"Arial" size:20.0];
            [newVideoAppointment addTarget:self action:@selector(RequestVideoAppointment:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:newVideoAppointment];
            
            if(isVideo==YES)
            {
                UIImage *videoImageHistory=[UIImage imageNamed:@"video-chat-gray-icon.png"];
                UIImageView *videoHistoryImgView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 250, videoImageHistory.size.width, videoImageHistory.size.height)];
                videoHistoryImgView.image=videoImageHistory;
                [self.view addSubview:videoHistoryImgView];
                
                UILabel *apptHistory=[[UILabel alloc]initWithFrame:CGRectMake(65, 250, 210, 30)];
                apptHistory.backgroundColor=[UIColor clearColor];
                apptHistory.text=@"Appointment History";
                apptHistory.textColor=[UIColor colorWithHexString:@"#646b6c"];
                apptHistory.font=[UIFont fontWithName:@"Helvetica" size:22.0];
                [self.view addSubview:apptHistory];
            }
            else if (isTelephone==YES)
            {
                UIImage *videoImageHistory=[UIImage imageNamed:@"telephone-gray-icon.png"];
                UIImageView *videoHistoryImgView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 250, videoImageHistory.size.width, videoImageHistory.size.height)];
                videoHistoryImgView.image=videoImageHistory;
                [self.view addSubview:videoHistoryImgView];
                
                UILabel *apptHistory=[[UILabel alloc]initWithFrame:CGRectMake(65, 250, 210, 30)];
                apptHistory.backgroundColor=[UIColor clearColor];
                apptHistory.text=@"Appointment History";
                apptHistory.textColor=[UIColor colorWithHexString:@"#646b6c"];
                apptHistory.font=[UIFont fontWithName:@"Helvetica" size:22.0];
                [self.view addSubview:apptHistory];
            }
           
            
            if([DateArray count]!=0)
            {
                videoApptTableView=[[UITableView alloc]initWithFrame:CGRectMake(33, 295, 255, 180) style:UITableViewStylePlain];
                videoApptTableView.delegate=self;
                videoApptTableView.dataSource=self;
                videoApptTableView.backgroundView=nil;
                [self.view addSubview:videoApptTableView];
            }
            
            
        }

        
    }
}

////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view datasource
////////////////////////////////////////////////////////////////////////////

-(void)getSkype
{
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSDate *todayDate=[NSDate date];
    NSString *todayDateTime=[df1 stringFromDate:todayDate];
    NSDate *todayD=[df1 dateFromString:todayDateTime];
    NSString *TDstr=[df1 stringFromDate:todayD];
    for(int i=0; i<[[[[LoginAppDelegate getAVAppointments]objectForKey:@"AllAppointments"] valueForKey:@"result"]count];i++)
    {
        if(isVideo==YES)
        {
           if([[[[[[LoginAppDelegate getAVAppointments]objectForKey:@"AllAppointments"] valueForKey:@"result"]objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"Skype"])
          {
           
            NSString *dateStr=[[[[[LoginAppDelegate getAVAppointments]objectForKey:@"AllAppointments"] valueForKey:@"result"]objectAtIndex:i]valueForKey:@"timeslot_date"];
            NSString *timeStr=[[[[[LoginAppDelegate getAVAppointments]objectForKey:@"AllAppointments"] valueForKey:@"result"]objectAtIndex:i]valueForKey:@"timeslot_start"];
            NSString *dateTime=[NSString stringWithFormat:@"%@ %@",dateStr,timeStr];
            NSDate *serverDT=[df2 dateFromString:dateTime];
             NSString *serverDTstr=[df1 stringFromDate:serverDT];
            if ([serverDTstr compare:TDstr]==NSOrderedSame)
            {
                [NextDateArray addObject:dateStr];
                [NextTimeArray addObject:timeStr];
                NSLog(@"Dates are equal");
            }
            if ( [serverDTstr compare:TDstr] ==NSOrderedAscending)
            {
                [DateArray addObject:dateStr];
                [TimeArray addObject:timeStr];
                NSLog(@"earlier");
            }
            if ( [serverDTstr compare:TDstr] ==NSOrderedDescending)
            {
                [NextDateArray addObject:dateStr];
                [NextTimeArray addObject:timeStr];
                NSLog(@"later");
            }
          }
        }
        else if (isTelephone==YES)
            {
                if([[[[[[LoginAppDelegate getAVAppointments]objectForKey:@"AllAppointments"] valueForKey:@"result"]objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"Telephone"])
                {
                    
                    NSString *dateStr=[[[[[LoginAppDelegate getAVAppointments]objectForKey:@"AllAppointments"] valueForKey:@"result"]objectAtIndex:i]valueForKey:@"timeslot_date"];
                    NSString *timeStr=[[[[[LoginAppDelegate getAVAppointments]objectForKey:@"AllAppointments"] valueForKey:@"result"]objectAtIndex:i]valueForKey:@"timeslot_start"];
                    NSString *dateTime=[NSString stringWithFormat:@"%@ %@",dateStr,timeStr];
                    NSDate *serverDT=[df2 dateFromString:dateTime];
                    NSString *serverDTstr=[df1 stringFromDate:serverDT];
                    if ([serverDTstr compare:TDstr]==NSOrderedSame)
                    {
                        [NextDateArray addObject:dateStr];
                        [NextTimeArray addObject:timeStr];
                        NSLog(@"Dates are equal");
                    }
                    if ( [serverDTstr compare:TDstr] ==NSOrderedAscending)
                    {
                        [DateArray addObject:dateStr];
                        [TimeArray addObject:timeStr];
                        NSLog(@"earlier");
                    }
                    if ( [serverDTstr compare:TDstr] ==NSOrderedDescending)
                    {
                        [NextDateArray addObject:dateStr];
                        [NextTimeArray addObject:timeStr];
                        NSLog(@"later");
                    }

            }
            
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
   // [self getSkype];
    int g=0;
    if(tableView.tag==555)
    {
        g=[NextDateArray count];
    }
    else
    {
        g=[DateArray count];
    }
    return g;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *calendarView;
    UILabel *dateLabel;
    UILabel *timeLabel;
    UIImageView *timeView;
    UILabel *doctorMsg;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        
        calendarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        calendarView.tag = 1;
        
        timeView = [[UIImageView alloc] initWithFrame:CGRectZero];
        timeView.tag = 2;
        
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.tag = 3;
        dateLabel.numberOfLines = 0;
        dateLabel.textColor=[UIColor blackColor];
        dateLabel.font = [UIFont boldSystemFontOfSize:16.0];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.tag = 4;
        timeLabel.numberOfLines = 0;
        timeLabel.textColor=[UIColor blackColor];
        timeLabel.font = [UIFont boldSystemFontOfSize:16.0];
        
        doctorMsg = [[UILabel alloc] initWithFrame:CGRectZero];
        doctorMsg.backgroundColor = [UIColor clearColor];
        doctorMsg.tag = 5;
        doctorMsg.numberOfLines = 0;
        doctorMsg.textColor=[UIColor colorWithHexString:@"#646b6c"];
        doctorMsg.font = [UIFont systemFontOfSize:14.0];
        
        [cell.contentView addSubview:calendarView];
        [cell.contentView addSubview:timeView];
        [cell.contentView addSubview:dateLabel];
        [cell.contentView addSubview:timeLabel];
        [cell.contentView addSubview:doctorMsg];
        
    }
   
        else
        {
            calendarView = (UIImageView *)[cell.contentView  viewWithTag:1];
            timeView=(UIImageView*)[cell.contentView viewWithTag:2];
            dateLabel = (UILabel *)[cell.contentView  viewWithTag:3];
             timeLabel = (UILabel *)[cell.contentView  viewWithTag:4];
            doctorMsg = (UILabel *)[cell.contentView  viewWithTag:5];
        }
    
    UIImage *calendar;
    UIImage *time;
    calendar = [UIImage imageNamed:@"calendar-gray-icon.png"] ;
    time=[UIImage imageNamed:@"clock-gray-icon.png"];
    calendarView.frame=CGRectMake(10, 4, calendar.size.width, calendar.size.height);
    timeView.frame=CGRectMake(145, 4, time.size.width, time.size.height);
    calendarView.image=calendar;
    timeView.image=time;
    doctorMsg.frame=CGRectMake(40, 23, 190, 30);
    dateLabel.frame=CGRectMake(40, 3, 90, 20);
    timeLabel.frame=CGRectMake(176, 3, 80, 20);
    
    if(tableView.tag==555)
    {
        dateLabel.text=[NextDateArray objectAtIndex:indexPath.row];
        timeLabel.text=[NextTimeArray objectAtIndex:indexPath.row];
        
    }
    else
    {
        dateLabel.text=[DateArray objectAtIndex:indexPath.row];
        timeLabel.text=[TimeArray objectAtIndex:indexPath.row];
    }
    
    doctorMsg.text=@"Consulted with Dr Bram Brons";
    
    return cell;
    
}


@end

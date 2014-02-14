//
//  SendVideoAppointment.m
//  PocketDoctor
//
//  Created by vishnu on 11/12/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import "SendVideoAppointment.h"
#import "UIColor+UIColorCategory.h"
#import "JSON.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"
@interface SendVideoAppointment ()

@end

@implementation SendVideoAppointment
@synthesize isTelephone,isVideos;

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
    if(isVideos==YES)
    {
        UIImage *videoImage=[UIImage imageNamed:@"video-chat-blue-icon.png"];
        UIImageView *videoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 46, videoImage.size.width, videoImage.size.height)];
        videoImgView.image=videoImage;
        [self.view addSubview:videoImgView];
    }
    else if (isTelephone==YES)
    {
        UIImage *videoImage=[UIImage imageNamed:@"telephone-blue-icon.png"];
        UIImageView *videoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 46, videoImage.size.width, videoImage.size.height)];
        videoImgView.image=videoImage;
        [self.view addSubview:videoImgView];
    }
    
    
    UILabel *nextApptLbl=[[UILabel alloc]initWithFrame:CGRectMake(65, 46, 220, 30)];
    nextApptLbl.backgroundColor=[UIColor clearColor];
    nextApptLbl.text=@"Request Appointment";
    nextApptLbl.textColor=[UIColor colorWithHexString:@"#473590"];
    nextApptLbl.font=[UIFont fontWithName:@"Helvetica" size:22.0];
    [self.view addSubview:nextApptLbl];
    // Do any additional setup after loading the view from its nib.
    isCalendar=YES;
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(85, 155, 150, 150)];
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    loadingView.clipsToBounds = YES;
    loadingView.layer.cornerRadius = 10.0;
    
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

    
    [self internetCheck];
    UIView *reqApptView=[[UIView alloc]initWithFrame:CGRectMake(15, 90, 290, 230)];
    reqApptView.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF"];
    reqApptView.layer.cornerRadius=6;
    [self.view addSubview:reqApptView];
    
    UILabel *selectDLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    selectDLbl.backgroundColor=[UIColor clearColor];
    selectDLbl.text=@"Select Date:";
    selectDLbl.font=[UIFont fontWithName:@"Helvetica" size:17.0];
    selectDLbl.textColor=[UIColor blackColor];
    [reqApptView addSubview:selectDLbl];
    
    UIButton *dateButton=[UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame=CGRectMake(10, 40, 270, 35);
    dateButton.backgroundColor=[UIColor colorWithHexString:@"#f1f1f1"];
    [dateButton addTarget:self action:@selector(dateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [reqApptView addSubview:dateButton];
    
    UIImage *calendarImage=[UIImage imageNamed:@"calendar-blue-icon.png"];
    UIImageView *calendarImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6, 6, calendarImage.size.width, calendarImage.size.height)];
    calendarImgView.image=calendarImage;
    [dateButton addSubview:calendarImgView];
    
    UIImage *downArrow=[UIImage imageNamed:@"down-arrow-gray.png"];
    UIImageView *downImgView=[[UIImageView alloc]initWithFrame:CGRectMake(245, 12, downArrow.size.width, downArrow.size.height)];
    downImgView.image=downArrow;
    [dateButton addSubview:downImgView];
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    
    UILabel *dateLblText=[[UILabel alloc]initWithFrame:CGRectMake(100, 6, 90, 25)];
    dateLblText.backgroundColor=[UIColor clearColor];
    NSString *dateStr=[[[[[[[LoginAppDelegate getCalendar]objectForKey:@"CalendarDetails"]valueForKey:@"result"] objectAtIndex:0] valueForKey:@"date_range"] objectAtIndex:0]valueForKey:@"date"];
    NSDate *strDate=[df1 dateFromString:dateStr];
    [df1 setDateFormat:@"dd-MM-yyyy"];
    NSString *stringDate=[df1 stringFromDate:strDate];
    dateLblText.text=stringDate;
    dateLblText.tag=1;
    dateLblText.textColor=[UIColor blackColor];
    dateLblText.font=[UIFont fontWithName:@"Helvetica" size:15.0];
    [dateButton addSubview:dateLblText];
    
    
    UILabel *selectTLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 90, 120, 30)];
    selectTLbl.backgroundColor=[UIColor clearColor];
    selectTLbl.text=@"Select Time:";
    selectTLbl.font=[UIFont fontWithName:@"Helvetica" size:17.0];
    selectTLbl.textColor=[UIColor blackColor];
    [reqApptView addSubview:selectTLbl];
    
    UIButton *timeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.frame=CGRectMake(10, 120, 270, 35);
    timeButton.backgroundColor=[UIColor colorWithHexString:@"#f1f1f1"];
    [timeButton addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [reqApptView addSubview:timeButton];
    
    UIImage *clockImage=[UIImage imageNamed:@"clock-blue-icon.png"];
    UIImageView *clockImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6, 7, clockImage.size.width, clockImage.size.height)];
    clockImgView.image=clockImage;
    [timeButton addSubview:clockImgView];
    
    UIImage *downArrow1=[UIImage imageNamed:@"down-arrow-gray.png"];
    UIImageView *downImgView1=[[UIImageView alloc]initWithFrame:CGRectMake(245, 12, downArrow.size.width, downArrow.size.height)];
    downImgView1.image=downArrow1;
    [timeButton addSubview:downImgView1];
    [self resetTime];
    UILabel *timeLblText=[[UILabel alloc]initWithFrame:CGRectMake(120, 6, 90, 25)];
    timeLblText.backgroundColor=[UIColor clearColor];
    if([[timeArray objectAtIndex:0]isEqualToString:@"0"])
    {
        timeLblText.frame=CGRectMake(110, 6, 90, 25);
        timeLblText.text=@"Not Avail";
    }
    else
    {
        timeLblText.frame=CGRectMake(120, 6, 90, 25);
        timeLblText.text=[timeArray objectAtIndex:0];
    }
    timeLblText.tag=2;
    timeLblText.textColor=[UIColor blackColor];
    timeLblText.font=[UIFont fontWithName:@"Helvetica" size:15.0];
    [timeButton addSubview:timeLblText];
    
    UIButton *newVideoAppointment=[UIButton buttonWithType:UIButtonTypeCustom];
    newVideoAppointment.frame=CGRectMake(10, 170, 270, 40);
    [newVideoAppointment setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
    newVideoAppointment.layer.cornerRadius=7;
    [newVideoAppointment setTitle:@"Set My Appointment" forState:UIControlStateNormal];
    newVideoAppointment.titleLabel.font=[UIFont fontWithName:@"Arial" size:20.0];
    [newVideoAppointment addTarget:self action:@selector(RequestNewVideoAppointment:) forControlEvents:UIControlEventTouchUpInside];
    [reqApptView addSubview:newVideoAppointment];
    
    
}



//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Back Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark -  Date Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)dateBtnClicked:(UIButton*)sender
{
    customPickerViewDate.center =CGPointMake(160,600);
    [pickerViewTime removeFromSuperview];
	if(pickerViewDate!=nil)
	{
        [customPickerViewDate removeFromSuperview];
		[pickerViewDate removeFromSuperview];
		
		pickerViewDate=nil;
	}
	
    customPickerViewDate = [[UIView alloc] initWithFrame:CGRectMake(0,650,320,300)];
	customPickerViewDate.tag = 600;
	[self.view addSubview:customPickerViewDate];
	
	//Adding toolbar
	UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideDate:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerViewDate addSubview:toolBar];
	
    
    //Adding picker view
   
	pickerViewDate=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    pickerViewDate.tag = 115;
    pickerViewDate.delegate=self;
	pickerViewDate.dataSource=self;
    pickerViewDate.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    pickerViewDate.showsSelectionIndicator = YES;
	pickerViewDate.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	[customPickerViewDate addSubview:pickerViewDate];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	customPickerViewDate.center =CGPointMake(160,420);
	[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerViewDate];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark -  Time Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)timeBtnClicked:(UIButton*)sender
{
    [customPickerViewDate removeFromSuperview];
    [pickerViewDate removeFromSuperview];
    customPickerViewTime.center =CGPointMake(160,600);
	if(pickerViewTime!=nil)
	{
        [customPickerViewTime removeFromSuperview];
		[pickerViewTime removeFromSuperview];
		
		pickerViewTime=nil;
	}
	
    customPickerViewTime = [[UIView alloc] initWithFrame:CGRectMake(0,650,320,300)];
	customPickerViewTime.tag = 601;
	[self.view addSubview:customPickerViewTime];
	
	//Adding toolbar
	UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideTime:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerViewTime addSubview:toolBar];
	
    
    //Adding picker view
    
	pickerViewTime=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    pickerViewTime.tag = 116;
    pickerViewTime.delegate=self;
	pickerViewTime.dataSource=self;
    pickerViewTime.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    pickerViewTime.showsSelectionIndicator = YES;
	pickerViewTime.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	[customPickerViewTime addSubview:pickerViewTime];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	customPickerViewTime.center =CGPointMake(160,420);
	[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerViewTime];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark -  PickerView DataSource
/////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger index=0;
    if(pickerView.tag==115)
    {
        index=[[[[[[[LoginAppDelegate getCalendar]objectForKey:@"CalendarDetails"]valueForKey:@"result"] objectAtIndex:0] valueForKey:@"date_range"]valueForKey:@"date"]count];
    }
    
    else
    {
        index=[timeArray count];
    }
    
    return index;
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark -  PickerView Delegate
/////////////////////////////////////////////////////////////////////////////////

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
     NSString *strResult;
    if(pickerView.tag==115)
    {
        NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
        [df1 setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr=[[[[[[[LoginAppDelegate getCalendar]objectForKey:@"CalendarDetails"]valueForKey:@"result"] objectAtIndex:0] valueForKey:@"date_range"] objectAtIndex:row]valueForKey:@"date"];
        NSDate *strDate=[df1 dateFromString:dateStr];
        [df1 setDateFormat:@"dd-MM-yyyy"];
        strResult=[df1 stringFromDate:strDate];
    }
    else
    {
        if([[timeArray objectAtIndex:row]isEqualToString:@"0"])
        {
            strResult=@"Not Avail";
        }
        else
        {
            strResult=[timeArray objectAtIndex:row];
        }
    }
    return strResult;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *dateText=(UILabel*)[self.view viewWithTag:1];
    UILabel *timeText=(UILabel*)[self.view viewWithTag:2];
     if (pickerView.tag==115)
    {
        NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
        [df1 setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr=[[[[[[[LoginAppDelegate getCalendar]objectForKey:@"CalendarDetails"]valueForKey:@"result"] objectAtIndex:0] valueForKey:@"date_range"] objectAtIndex:row]valueForKey:@"date"];
        NSDate *strDate=[df1 dateFromString:dateStr];
        [df1 setDateFormat:@"dd-MM-yyyy"];
        dateText.text=[df1 stringFromDate:strDate];
    }
    else
    {
        if([[timeArray objectAtIndex:row]isEqualToString:@"0"])
        {
            timeText.frame=CGRectMake(110, 6, 90, 25);
            timeText.text=@"Not Avail";
        }
        else
        {
            timeText.frame=CGRectMake(120, 6, 90, 25);
          timeText.text=[timeArray objectAtIndex:row];
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark -  Date Bar Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideDate:(UIButton *)sender
{
    UILabel *timelabel=(UILabel*)[self.view viewWithTag:2];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[customPickerViewDate removeFromSuperview];
	[UIView commitAnimations];
    [self resetTime];
    if([[timeArray objectAtIndex:0]isEqualToString:@"0"])
    {
        timelabel.frame=CGRectMake(110, 6, 90, 25);
        timelabel.text=@"Not Avail";
    }
    else
    {
        timelabel.frame=CGRectMake(120, 6, 90, 25);
        timelabel.text=[timeArray objectAtIndex:0];
    }
    
  
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark -  Time Bar Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideTime:(UIButton *)sender
{
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[customPickerViewTime removeFromSuperview];
	[UIView commitAnimations];
    
    
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark -  Time Reset
/////////////////////////////////////////////////////////////////////////////////

-(void)resetTime
{
    UILabel *datetext=(UILabel*)[self.view viewWithTag:1];
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"dd-MM-yyyy"];
    NSString *dateStr=datetext.text;
    NSDate *strDate=[df1 dateFromString:dateStr];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dstr=[df1 stringFromDate:strDate];
    timeArray=[[NSMutableArray alloc]init];
    for(int i=0; i<[[[[[[[LoginAppDelegate getCalendar]objectForKey:@"CalendarDetails"]valueForKey:@"result"] objectAtIndex:0] valueForKey:@"date_range"]valueForKey:@"date"]count];i++)
    {
        if([dstr isEqualToString:[[[[[[[LoginAppDelegate getCalendar]objectForKey:@"CalendarDetails"]valueForKey:@"result"] objectAtIndex:0] valueForKey:@"date_range"]objectAtIndex:i]valueForKey:@"date"]])
        {
            for(int j=0;j<[[[[[[[[LoginAppDelegate getCalendar]objectForKey:@"CalendarDetails"]valueForKey:@"result"] objectAtIndex:0] valueForKey:@"date_range"] objectAtIndex:i]valueForKey:@"Y"]count];j++)
            {
                NSString *timeStr=[[[[[[[[LoginAppDelegate getCalendar]objectForKey:@"CalendarDetails"]valueForKey:@"result"] objectAtIndex:0] valueForKey:@"date_range"] objectAtIndex:i]valueForKey:@"Y"]objectAtIndex:j];
                [timeArray addObject:timeStr];
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark -  set Appointment click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)RequestNewVideoAppointment:(UIButton*)sender
{
    UILabel *timeLabel=(UILabel*)[self.view viewWithTag:2];
    if([timeLabel.text isEqualToString:@"Not Avail"])
    {
        UIAlertView *appointmentAlert=[[UIAlertView alloc]initWithTitle:nil message:@"Appointment not available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [appointmentAlert show];
        return;
    }
    else
    {
        isVideo=YES;
        [self internetCheck];
    }
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
        
        if(isCalendar==YES)
        {
            [activityView startAnimating];
            [self getCalendar];
        }
        else
        {
            [activityView startAnimating];
            [self.view addSubview:loadingView];
            [self sendVideo];
        }
        
        
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        
        if(isCalendar==YES)
        {
            [activityView startAnimating];
            [self getCalendar];
        }
        else
        {
            [activityView startAnimating];
            [self.view addSubview:loadingView];
            [self sendVideo];
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
    
    else if (alertView.tag==2222)
    {
        if(buttonIndex==0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark -  Get Calendar Details Web Service
/////////////////////////////////////////////////////////////////////////////////

- (void)getCalendar
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/getCalendar", [appDelegate domainURl]]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    [request setDelegate:self];
    [request startSynchronous];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark -  Send Video Appointment to server
/////////////////////////////////////////////////////////////////////////////////

- (void)sendVideo
{
    UILabel *timetext=(UILabel*)[self.view viewWithTag:2];
    UILabel *datetext=(UILabel*)[self.view viewWithTag:1];
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"dd-MM-yyyy"];
    NSString *dateStr=datetext.text;
    NSDate *strDate=[df1 dateFromString:dateStr];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dstr=[df1 stringFromDate:strDate];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/SaveAppointment",[appDelegate domainURl]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[appDelegate domainId] forKey:kDomainId];
    [request setPostValue:[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"cust_id"] forKey:kcid];
    [request setPostValue:dstr forKey:ktimeslotdate];
    [request setPostValue:timetext.text forKey:ktimeslotstart];
    [request setPostValue:kappname forKey:kapp];
    [request setPostValue:@"3" forKey:kappid];
    if(isVideos==YES)
    {
        [request setPostValue:[[[[[LoginAppDelegate getLiveDoctor]objectForKey:@"LiveDetails"] valueForKey:@"result"] objectAtIndex:0] valueForKey:@"prod_master_id"] forKey:kgpid];
    }
    else if (isTelephone==YES)
    {
         [request setPostValue:[[[[[LoginAppDelegate getLiveDoctor]objectForKey:@"LiveDetails"] valueForKey:@"result"] objectAtIndex:2] valueForKey:@"prod_master_id"] forKey:kgpid];
    }
    
    [request setRequestMethod:@"POST"];
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
    NSDictionary *responseDictionary = [[request responseString] JSONValue];
    NSLog(@"dict is %@",responseDictionary);
   
     if(isCalendar==YES)
    {
        isCalendar=NO;
        [activityView stopAnimating];
        [loadingView removeFromSuperview];
        [[LoginAppDelegate getCalendar]setObject:[responseDictionary objectForKey:@"posts"] forKey:@"CalendarDetails"];
        NSLog(@"response1 is %@",[[LoginAppDelegate getCalendar]objectForKey:@"CalendarDetails"]);
        
    }
    
    else if(isVideo==YES)
    {
        isVideo=NO;
        [activityView stopAnimating];
        [loadingView removeFromSuperview];
        if ( [(NSString *)[[responseDictionary objectForKey:@"posts"]objectForKey:kResponseKey] intValue] == 0 )
        {
            UIAlertView *appointmentAlert=[[UIAlertView alloc]initWithTitle:nil message:@"You can book only one appointment per day." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            appointmentAlert.tag=2222;
            [appointmentAlert show];
        }
        else
        {
        UIAlertView *appointmentAlert=[[UIAlertView alloc]initWithTitle:nil message:@"Thank you for booking an appointment with PocketDoctor. Your timeslot has now been reserved and the doctor will confirm shortly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        appointmentAlert.tag=2222;
        [appointmentAlert show];
        }
        
    }
    
    
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

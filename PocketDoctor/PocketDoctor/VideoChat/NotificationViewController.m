//
//  NotificationViewController.m
//  PocketDoctor
//
//  Created by vishnu on 17/12/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import "NotificationViewController.h"
#import "UIColor+UIColorCategory.h"
@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize counterLabel,counterValue,timer;
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
    
//    backBtn=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"l-arrow-ico.png"]];
//    [backBtn setFrame:CGRectMake(9, 9, 20, 20)];
//    [self.view addSubview:backBtn];
//    
//    backBtnTitle=[UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtnTitle setFrame:CGRectMake(5, 8, 90, 25)];
//    [backBtnTitle setTitle:@"Back" forState:UIControlStateNormal];
//    backBtnTitle.titleLabel.font=[UIFont fontWithName:@"Arial" size:18.0];
//    [backBtnTitle setTitleColor:[UIColor colorWithHexString:@"#316CBA"] forState:UIControlStateNormal];
//    [backBtnTitle addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtnTitle];
    
    UIImage *doctorImage=[UIImage imageNamed:@"dr-photo.png"];
    UIImageView *doctImgView=[[UIImageView alloc]initWithFrame:CGRectMake(13, 50, doctorImage.size.width, doctorImage.size.height)];
    doctImgView.image=doctorImage;
    [self.view addSubview:doctImgView];
    
    UILabel *doctorNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(130, 50, 140, 30)];
    doctorNameLbl.backgroundColor=[UIColor clearColor];
    doctorNameLbl.text=@"Dr. Bram Brons";
    doctorNameLbl.textColor=[UIColor blackColor];
    doctorNameLbl.font=[UIFont fontWithName:@"Arial" size:19.0];
    [self.view addSubview:doctorNameLbl];
    
    UILabel *doctRegNo=[[UILabel alloc]initWithFrame:CGRectMake(130, 72, 200, 30)];
    doctRegNo.backgroundColor=[UIColor clearColor];
    doctRegNo.text=@"UK GMC Reg. No.: 7010626";
    doctRegNo.textColor=[UIColor blackColor];
    doctRegNo.font=[UIFont fontWithName:@"Arial" size:14.0];
    [self.view addSubview:doctRegNo];
    
    UILabel *doctPosition=[[UILabel alloc]initWithFrame:CGRectMake(130, 94, 170, 30)];
    doctPosition.backgroundColor=[UIColor clearColor];
    doctPosition.text=@"Position: GP";
    doctPosition.textColor=[UIColor blackColor];
    doctPosition.font=[UIFont fontWithName:@"Arial" size:14.0];
    [self.view addSubview:doctPosition];
    
    UILabel *hasAppointment=[[UILabel alloc]initWithFrame:CGRectMake(13, 160, 170, 30)];
    hasAppointment.backgroundColor=[UIColor clearColor];
    hasAppointment.text=@"Has an appointment";
    hasAppointment.textColor=[UIColor blackColor];
    hasAppointment.font=[UIFont fontWithName:@"Arial" size:14.0];
    [self.view addSubview:hasAppointment];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(13, 190, 295, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    UIImage *calImage=[UIImage imageNamed:@"calendar-big-blue-icon.png"];
    UIImageView *calImgView=[[UIImageView alloc]initWithFrame:CGRectMake(25, 210, doctorImage.size.width, doctorImage.size.height)];
    calImgView.image=calImage;
    [self.view addSubview:calImgView];
    
    UILabel *todayLbl=[[UILabel alloc]initWithFrame:CGRectMake(160, 210, 160, 30)];
    todayLbl.backgroundColor=[UIColor clearColor];
    todayLbl.text=@"TODAY";
    todayLbl.textColor=[UIColor colorWithHexString:@"#47388D"];
    todayLbl.font=[UIFont fontWithName:@"Helvetica" size:22.0];
    [self.view addSubview:todayLbl];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(13, 330, 295, 1)];
    lineView1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSString *str=[formatter stringFromDate:[NSDate date]];
    NSLog(@"%@", [formatter stringFromDate:[NSDate date]]); // 07:23:38
    
//    formatter.timeZone=[NSTi;meZone timeZoneWithName:@"HH:mm"];
  NSDate *date = [formatter dateFromString:str]; // 2000-01-01 15:00:00 +0000
    NSLog(@"%@", date);
    counterValue = 0;
    self.counterLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 400, 130, 50)];
    self.counterLabel.backgroundColor=[UIColor clearColor];
    self.counterLabel.textColor=[UIColor blackColor];
	self.counterLabel.text = [NSString stringWithFormat:@"%d", counterValue];
    [self.view addSubview:self.counterLabel];
    [self startTimer];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)updateLabel:(id)sender
{
	if(counterValue >= MAX_VALUE)
    {
		[self killTimer];
	}
	
	self.counterLabel.text = [NSString stringWithFormat:@"%d", counterValue];
	counterValue++;
}

- (void)startTimer{
	self.counterValue = 0;
	
	//[self killTimer];
	timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                             target:self
                                           selector:@selector(updateLabel:)
                                           userInfo:nil
                                            repeats:YES ];
	
	[self updateLabel:timer];
}

- (void)killTimer{
	if(timer){
		[timer invalidate];
		timer = nil;
	}
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


@end

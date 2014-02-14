//
//  RegistrationViewController.m
//  PocketDoctor
//
//  Created by vishnu on 18/11/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import "RegistrationViewController.h"
#import "UIColor+UIColorCategory.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "Constants.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"


#define SCROLLVIEW_HEIGHT 440
#define SCROLLVIEW_WIDTH  250

#define SCROLLVIEW_CONTENT_HEIGHT 680
#define SCROLLVIEW_CONTENT_WIDTH  320
@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize isGrid;

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

-(id)initWithNibName:(NSString*)email
{
    if(self)
    {
        username=email;
        
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
    
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SignupSuccessful"])
    {
        UIImage *newImg=[UIImage imageNamed:@"new-user-blue-icon.png"];
        UIImageView *newImgView=[[UIImageView alloc]initWithFrame:CGRectMake(37, 42, 24, 28)];
        newImgView.tag=100;
        newImgView.image=newImg;
        [self.view addSubview:newImgView];
        
        UILabel *newRegLbl=[[UILabel alloc]initWithFrame:CGRectMake(79, 42, 190, 30)];
        newRegLbl.backgroundColor=[UIColor clearColor];
        newRegLbl.text=@"New Registration";
        newRegLbl.tag=101;
        newRegLbl.textColor=[UIColor colorWithHexString:@"#47388D"];
        newRegLbl.font=[UIFont fontWithName:@"Arial" size:24.0];
        [self.view addSubview:newRegLbl];
        
        scrollview = [[UIScrollView alloc] init];
        scrollview.contentSize = CGSizeMake(0, SCROLLVIEW_CONTENT_HEIGHT);
        scrollview.frame = CGRectMake(35, 70, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        scrollview.scrollsToTop = NO;
        scrollview.tag=143;
        scrollview.delegate = self;
        [self.view addSubview:scrollview];
        scrollview.scrollEnabled=NO;
        
        UIImage *toparrow=[UIImage imageNamed:@"top-arrow.png"];
        UIImageView *logo2=[[UIImageView alloc]initWithFrame:CGRectMake(115, 2, 19, 9)];
        logo2.tag=99;
        logo2.image=toparrow;
        [scrollview addSubview:logo2];
    customView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 250, 320)]; //<- change to where you want it to show.
    customView.backgroundColor=[UIColor colorWithHexString:@"#47388D"];
    customView.alpha = 0.0;
    customView.layer.cornerRadius = 5;
    customView.layer.borderWidth = 1.5f;
    customView.contentMode=UIViewContentModeCenter;
    //customView.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), YourColorValues);
    //customView.layer.masksToBounds = YES;
    //customView.layer.mask=l;
    customView.clipsToBounds=YES;
    customView.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#47388D"]);
    [scrollview addSubview:customView];
        
        
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [customView setAlpha:1.0];
    [UIView commitAnimations];
    [UIView setAnimationDuration:0.0];
    
    CGRect FNTextFieldFrame = CGRectMake(10.0f, 10.0f, 230.0f, 31.0f);
    FNTextField = [[UITextField alloc] initWithFrame:FNTextFieldFrame];
    FNTextField.placeholder = @"First Name";
    FNTextField.textColor = [UIColor blackColor];
    FNTextField.font = [UIFont systemFontOfSize:14.0f];
    FNTextField.backgroundColor=[UIColor whiteColor];
    FNTextField.borderStyle = UITextBorderStyleRoundedRect;
    FNTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    FNTextField.textAlignment = NSTextAlignmentLeft;
    FNTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    FNTextField.tag = 1;
    FNTextField.delegate=self;
    FNTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [customView addSubview:FNTextField];
    
   
    CGRect LNTextFieldFrame = CGRectMake(10.0f, 70.0f, 230.0f, 31.0f);
    LNTextField = [[UITextField alloc] initWithFrame:LNTextFieldFrame];
    LNTextField.placeholder = @"Last Name";
    LNTextField.backgroundColor = [UIColor whiteColor];
    LNTextField.textColor = [UIColor blackColor];
    LNTextField.font = [UIFont systemFontOfSize:14.0f];
    LNTextField.borderStyle = UITextBorderStyleRoundedRect;
    LNTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    LNTextField.textAlignment = NSTextAlignmentLeft;
    LNTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    LNTextField.tag = 2;
    LNTextField.delegate=self;
    LNTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [customView addSubview:LNTextField];
    
    CGRect emailTextFieldFrame = CGRectMake(10.0f, 130.0f, 230.0f, 31.0f);
    emailTextField = [[UITextField alloc] initWithFrame:emailTextFieldFrame];
    emailTextField.placeholder = @"Email";
    emailTextField.textColor = [UIColor blackColor];
    emailTextField.font = [UIFont systemFontOfSize:14.0f];
    emailTextField.backgroundColor=[UIColor whiteColor];
    emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTextField.keyboardType=UIKeyboardTypeEmailAddress;
    emailTextField.textAlignment = NSTextAlignmentLeft;
    emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailTextField.tag = 3;
    emailTextField.delegate=self;
    emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [customView addSubview:emailTextField];
    
    CGRect passwordTextFieldFrame = CGRectMake(10.0f, 190.0f, 230.0f, 31.0f);
    passwordTextField = [[UITextField alloc] initWithFrame:passwordTextFieldFrame];
    passwordTextField.placeholder = @"Password";
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.secureTextEntry=YES;
    passwordTextField.textColor = [UIColor blackColor];
    passwordTextField.font = [UIFont systemFontOfSize:14.0f];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.textAlignment = NSTextAlignmentLeft;
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.tag = 4;
    passwordTextField.delegate=self;
    passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [customView addSubview:passwordTextField];
    
    
    CGRect conPasswordTextFieldFrame = CGRectMake(10.0f, 250.0f, 230.0f, 31.0f);
    conPasswordTextField = [[UITextField alloc] initWithFrame:conPasswordTextFieldFrame];
    conPasswordTextField.placeholder = @"Confirm Password";
    conPasswordTextField.backgroundColor = [UIColor whiteColor];
    conPasswordTextField.textColor = [UIColor blackColor];
    conPasswordTextField.font = [UIFont systemFontOfSize:14.0f];
    conPasswordTextField.secureTextEntry=YES;
    conPasswordTextField.delegate=self;
    conPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    conPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    conPasswordTextField.textAlignment = NSTextAlignmentLeft;
    conPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    conPasswordTextField.tag = 5;
    conPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [customView addSubview:conPasswordTextField];
    
    CGRect savebtn=CGRectMake(0.0f, 340.0f, 250.0f, 40.0f);
    submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame=savebtn;
    submitButton.layer.cornerRadius=8;
    [submitButton setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton setTag:6];
    [submitButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:submitButton];
    }
    else
    {
        UILabel *memberlabel=[[UILabel alloc]initWithFrame:CGRectMake(115, 30, 160, 25)];
        memberlabel.backgroundColor=[UIColor clearColor];
        memberlabel.tag=200;
        memberlabel.text=@"My Profile";
        memberlabel.textColor=[UIColor blackColor];
        memberlabel.font=[UIFont fontWithName:@"Helvetica" size:15.0];
        [self.view addSubview:memberlabel];

        scrollview = [[UIScrollView alloc] init];
        scrollview.contentSize = CGSizeMake(0, 1400);
        scrollview.frame = CGRectMake(0, 70, 320, SCROLLVIEW_HEIGHT);
        scrollview.scrollsToTop = NO;
        scrollview.tag=143;
        scrollview.delegate = self;
        [self.view addSubview:scrollview];
        scrollview.scrollEnabled=YES;
        [self Profile];
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
#pragma mark - Profile View
/////////////////////////////////////////////////////////////////////////////////

-(void)Profile
{
    if(isGrid==YES)
    {
        backBtnTitle.hidden=NO;
        backBtn.hidden=NO;
    }
    else
    {
        backBtnTitle.hidden=YES;
        backBtn.hidden=YES;
    }
    isProfile=YES;
    BPArray=[[NSMutableArray alloc]initWithObjects:@"Normal - Between 90/60 - 150/100",@"Low - Below 90/60",@"High - Above 150/100", nil];
    weightUnitArray=[[NSMutableArray alloc]initWithObjects:@"Select Unit>>",@"Stones",@"Kg",@"Pounds", nil];
    heightUnitArray=[[NSMutableArray alloc]initWithObjects:@"Select Unit>>",@"Feet & Inches",@"Centimetres",@"Inches",@"Metres", nil];
    genderArray=[[NSMutableArray alloc]initWithObjects:@"Male",@"Female", nil];
    CGRect genderLBLFrame = CGRectMake(30.0f, 10.0f, 170.0f, 31.0f);
    UILabel *GenderLBL=[[UILabel alloc]initWithFrame:genderLBLFrame];
    GenderLBL.textAlignment =NSTextAlignmentLeft;
    GenderLBL.text=@"Gender";
    GenderLBL.textColor =[UIColor blackColor];
    [GenderLBL setNumberOfLines:0];
    //[firstNameLBL sizeToFit];
    GenderLBL.tag=7;
    GenderLBL.font =[UIFont fontWithName:@"Arial" size:16.0];
    GenderLBL.backgroundColor = [UIColor clearColor];
    [scrollview addSubview:GenderLBL];

    
    UIButton *btnGender=[UIButton buttonWithType:UIButtonTypeCustom];
	btnGender.frame=CGRectMake(170, 10, 120, 30);
	btnGender.tag=8;
    btnGender.layer.cornerRadius=5;
    btnGender.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
	[btnGender setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
	[btnGender addTarget:self action:@selector(btnGenderClicked:) forControlEvents:UIControlEventTouchUpInside];
	[scrollview addSubview:btnGender];
    
    UIImage *downArrow=[UIImage imageNamed:@"down-arrow-black.png"];
    UIImageView *downImgView=[[UIImageView alloc]initWithFrame:CGRectMake(270, 20, 12, 9)];
    downImgView.image=downArrow;
    [scrollview addSubview:downImgView];
    
    UILabel *lblGender=[[UILabel alloc]initWithFrame:CGRectMake(181, 10, 130, 30)];
	lblGender.tag=9;
    if(isGrid==YES)
    {
        lblGender.text=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"gender"];
    }
    else
    {
        lblGender.text=[genderArray objectAtIndex:0];
    }
	lblGender.backgroundColor=[UIColor clearColor];
	lblGender.font=[UIFont fontWithName:@"Arial" size:15.0];
	[scrollview addSubview:lblGender];
    
    CGRect dateLBLFrame = CGRectMake(30.0f, 60, 190.0f, 31.0f);
    UILabel *DOBLBL=[[UILabel alloc]initWithFrame:dateLBLFrame];
    DOBLBL.textAlignment =NSTextAlignmentLeft;
    DOBLBL.text=@"Date of Birth";
    DOBLBL.textColor =[UIColor blackColor];
    [DOBLBL setNumberOfLines:0];
    //[firstNameLBL sizeToFit];
    DOBLBL.tag=10;
    DOBLBL.font =[UIFont fontWithName:@"Arial" size:16.0];
    DOBLBL.backgroundColor = [UIColor clearColor];
    [scrollview addSubview:DOBLBL];
    
    UIButton *btnTimeFrom=[UIButton buttonWithType:UIButtonTypeCustom];
	btnTimeFrom.frame=CGRectMake(170, 60, 120, 30);
	btnTimeFrom.tag=11;
    btnTimeFrom.layer.cornerRadius=5;
    btnTimeFrom.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
	[btnTimeFrom setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
	[btnTimeFrom addTarget:self action:@selector(btnDateFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[scrollview addSubview:btnTimeFrom];
    
    UIImage *downArrow1=[UIImage imageNamed:@"down-arrow-black.png"];
    UIImageView *downImgView1=[[UIImageView alloc]initWithFrame:CGRectMake(270, 70, 12, 9)];
    downImgView1.image=downArrow1;
    [scrollview addSubview:downImgView1];
    
    UILabel *lblDateFromDate=[[UILabel alloc]initWithFrame:CGRectMake(180, 60, 120, 30)];
    if(isGrid==YES)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [df setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *dateStr=[df dateFromString:[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"date_of_birth"]];
        
        NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
        //[df1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [df1 setDateFormat:@"dd-MM-yyyy"];
        NSString *s=[df1 stringFromDate:dateStr];
        //        NSDate *bDate=[df1 dateFromString:s];
        lblDateFromDate.text=s;
    }
	lblDateFromDate.tag=12;
	lblDateFromDate.backgroundColor=[UIColor clearColor];
	lblDateFromDate.font=[UIFont fontWithName:@"Arial" size:15.0];
	[scrollview addSubview:lblDateFromDate];
    
    CGRect phoneLBLFrame = CGRectMake(30.0f, 110.0f, 190.0f, 31.0f);
    UILabel *phoneLbl=[[UILabel alloc]initWithFrame:phoneLBLFrame];
    phoneLbl.textAlignment =NSTextAlignmentLeft;
    phoneLbl.text=@"Phone";
    phoneLbl.textColor =[UIColor blackColor];
    [phoneLbl setNumberOfLines:0];
    //[firstNameLBL sizeToFit];
    phoneLbl.tag=14;
    phoneLbl.font =[UIFont fontWithName:@"Arial" size:16.0];
    phoneLbl.backgroundColor = [UIColor clearColor];
    [scrollview addSubview:phoneLbl];
    
    UITextField *phoneTxtFld = [[UITextField alloc] initWithFrame:CGRectMake(170,110,120,30)];
    phoneTxtFld.delegate = self;
    phoneTxtFld.tag = 15;
    phoneTxtFld.font=[UIFont fontWithName:@"Arial" size:16.0];
    phoneTxtFld.textAlignment = NSTextAlignmentLeft;
    phoneTxtFld.keyboardType=UIKeyboardTypeNumberPad;
    if(isGrid==YES)
    {
        if([[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"phone_number"]isEqualToString:@""])
        {
           // isGrid=NO;
        }
        else
        {
        phoneTxtFld.text=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"phone_number"];
        }
    }
    phoneTxtFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [scrollview addSubview:phoneTxtFld];
    phoneTxtFld.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [[phoneTxtFld layer] setBorderColor:[[UIColor colorWithHexString:@"#FFFFFF"] CGColor]];
    [[phoneTxtFld layer] setBorderWidth:1.0];
    [[phoneTxtFld layer] setCornerRadius:5];
    
    CGRect heightLBLFrame = CGRectMake(30.0f, 160.0f, 190.0f, 31.0f);
    UILabel *heightLbl=[[UILabel alloc]initWithFrame:heightLBLFrame];
    heightLbl.textAlignment =NSTextAlignmentLeft;
    heightLbl.text=@"Height";
    heightLbl.textColor =[UIColor blackColor];
    [heightLbl setNumberOfLines:0];
    //[firstNameLBL sizeToFit];
    heightLbl.tag=16;
    heightLbl.font =[UIFont fontWithName:@"Arial" size:16.0];
    heightLbl.backgroundColor = [UIColor clearColor];
    [scrollview addSubview:heightLbl];
    
    UIButton *heightButton=[UIButton buttonWithType:UIButtonTypeCustom];
	heightButton.frame=CGRectMake(170, 160, 120, 30);
	heightButton.tag=17;
    heightButton.layer.cornerRadius=5;
    heightButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
	[heightButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
	[heightButton addTarget:self action:@selector(btnHeightFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[scrollview addSubview:heightButton];
    
    UIImage *downArrow2=[UIImage imageNamed:@"down-arrow-black.png"];
    UIImageView *downImgView2=[[UIImageView alloc]initWithFrame:CGRectMake(273, 171, 12, 9)];
    downImgView2.image=downArrow2;
    [scrollview addSubview:downImgView2];
    
    UILabel *heightTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 160, 120, 30)];
	heightTextLbl.tag=18;
    if(isGrid==YES)
    {
        if([[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height_unit"]isEqualToString:@""])
        {
            heightTextLbl.text=@"Select Unit>>";
        }
        else
        {
            heightTextLbl.text=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height_unit"];
        }
        
    }
    else
    {
        heightTextLbl.text=@"Select Unit>>";
    }
	heightTextLbl.backgroundColor=[UIColor clearColor];
	heightTextLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
	[scrollview addSubview:heightTextLbl];
    
    CGRect weightLBLFrame = CGRectMake(30.0f, 210.0f, 190.0f, 31.0f);
    UILabel *weightLbl=[[UILabel alloc]initWithFrame:weightLBLFrame];
    weightLbl.textAlignment =NSTextAlignmentLeft;
    weightLbl.text=@"Weight";
    weightLbl.textColor =[UIColor blackColor];
    [weightLbl setNumberOfLines:0];
    //[firstNameLBL sizeToFit];
    weightLbl.tag=19;
    weightLbl.font =[UIFont fontWithName:@"Arial" size:16.0];
    weightLbl.backgroundColor = [UIColor clearColor];
    [scrollview addSubview:weightLbl];
    
    UIButton *weightButton=[UIButton buttonWithType:UIButtonTypeCustom];
	weightButton.frame=CGRectMake(170, 210, 120, 30);
	weightButton.tag=20;
    weightButton.layer.cornerRadius=5;
    weightButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
	[weightButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
	[weightButton addTarget:self action:@selector(btnWeightFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[scrollview addSubview:weightButton];
    
    UIImage *downArrow3=[UIImage imageNamed:@"down-arrow-black.png"];
    UIImageView *downImgView3=[[UIImageView alloc]initWithFrame:CGRectMake(273, 221, 12, 9)];
    downImgView3.image=downArrow3;
    [scrollview addSubview:downImgView3];
    
    UILabel *weightTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 210, 120, 30)];
	weightTextLbl.tag=21;
    if(isGrid==YES)
    {
        if([[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight_unit"]isEqualToString:@""])
        {
            weightTextLbl.text=@"Select Unit>>";
        }
        else
        {
             weightTextLbl.text=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight_unit"];
        }
       
    }
    else
    {
        weightTextLbl.text=@"Select Unit>>";
    }
	weightTextLbl.backgroundColor=[UIColor clearColor];
	weightTextLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
	[scrollview addSubview:weightTextLbl];
    
    CGRect BPLBLFrame = CGRectMake(30.0f, 260.0f, 190.0f, 31.0f);
    UILabel *BPLbl=[[UILabel alloc]initWithFrame:BPLBLFrame];
    BPLbl.textAlignment =NSTextAlignmentLeft;
    BPLbl.text=@"Blood Pressure";
    BPLbl.textColor =[UIColor blackColor];
    [BPLbl setNumberOfLines:0];
    //[firstNameLBL sizeToFit];
    BPLbl.tag=22;
    BPLbl.font =[UIFont fontWithName:@"Arial" size:16.0];
    BPLbl.backgroundColor = [UIColor clearColor];
    [scrollview addSubview:BPLbl];
    
    UIButton *BPButton=[UIButton buttonWithType:UIButtonTypeCustom];
	BPButton.frame=CGRectMake(30, 300, 260, 30);
	BPButton.tag=23;
    BPButton.layer.cornerRadius=5;
    BPButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
	[BPButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
	[BPButton addTarget:self action:@selector(btnBPFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[scrollview addSubview:BPButton];
    
    UIImage *downArrow4=[UIImage imageNamed:@"down-arrow-black.png"];
    UIImageView *downImgView4=[[UIImageView alloc]initWithFrame:CGRectMake(273, 310, 12, 9)];
    downImgView4.image=downArrow4;
    [scrollview addSubview:downImgView4];
    
    UILabel *BPTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(35, 300, 260, 30)];
	BPTextLbl.tag=24;
    if(isGrid==YES)
    {
        if([[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"blood_pressure"]isEqualToString:@""])
        {
            BPTextLbl.text=[BPArray objectAtIndex:0];
        }
        else
        {
            BPTextLbl.text=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"blood_pressure"];
        }
        
    }
    else
    {
        BPTextLbl.text=[BPArray objectAtIndex:0];
    }
	BPTextLbl.backgroundColor=[UIColor clearColor];
	BPTextLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
	[scrollview addSubview:BPTextLbl];
    
    CGRect CurrentMCFrame = CGRectMake(30.0f, 340.0f, 190.0f, 61.0f);
    UILabel *CurrentMCLbl=[[UILabel alloc]initWithFrame:CurrentMCFrame];
    CurrentMCLbl.textAlignment =NSTextAlignmentLeft;
    CurrentMCLbl.text=@"Current Medical Conditions";
    CurrentMCLbl.textColor =[UIColor blackColor];
    [CurrentMCLbl setNumberOfLines:0];
    //[firstNameLBL sizeToFit];
    CurrentMCLbl.tag=25;
    CurrentMCLbl.font =[UIFont fontWithName:@"Arial" size:16.0];
    CurrentMCLbl.backgroundColor = [UIColor clearColor];
    [scrollview addSubview:CurrentMCLbl];
    
    UIButton *butCheck = [UIButton buttonWithType:UIButtonTypeCustom];
    [butCheck setFrame:CGRectMake(180, 360, 32, 29)];
    [butCheck setTag:26];
    
    [butCheck addTarget:self action:@selector(CheckClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:butCheck];
    UITextView *medTextView=[[UITextView alloc]initWithFrame:CGRectMake(30, 405, 260, 80)];
    medTextView.delegate=self;
    medTextView.layer.cornerRadius=7;
    medTextView.tag=27;
    medTextView.returnKeyType = UIReturnKeyDone;
    [scrollview addSubview:medTextView];
    if(isGrid==YES)
    {
        NSString *medCon=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"medical_condition"];
        if([medCon isEqualToString:@""])
        {
             [butCheck setBackgroundImage:[UIImage imageNamed:@"uncheck-box.png"] forState:UIControlStateNormal];
             medTextView.hidden=YES;
        }
        else
        {
             [butCheck setBackgroundImage:[UIImage imageNamed:@"check-box.png"] forState:UIControlStateNormal];
             medTextView.hidden=NO;
            medTextView.text=medCon;
            [self Check];
        }
    }
    else
    {
        [butCheck setBackgroundImage:[UIImage imageNamed:@"uncheck-box.png"] forState:UIControlStateNormal];
    medTextView.hidden=YES;
    }
    
    CGRect SubjectFrame = CGRectMake(30.0f, 400.0f, 190.0f, 31.0f);
    UILabel *SubjectLbl=[[UILabel alloc]initWithFrame:SubjectFrame];
    SubjectLbl.textAlignment =NSTextAlignmentLeft;
    SubjectLbl.text=@"Subject To Discuss";
    SubjectLbl.textColor =[UIColor blackColor];
    [SubjectLbl setNumberOfLines:0];
    //[firstNameLBL sizeToFit];
    SubjectLbl.tag=28;
    SubjectLbl.font =[UIFont fontWithName:@"Arial" size:16.0];
    SubjectLbl.backgroundColor = [UIColor clearColor];
    [scrollview addSubview:SubjectLbl];
    
    UITextView *SubTextView=[[UITextView alloc]initWithFrame:CGRectMake(30, 440, 260, 80)];
    SubTextView.delegate=self;
    SubTextView.layer.cornerRadius=7;
    SubTextView.tag=29;
    if(isGrid==YES)
    {
        SubTextView.text=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"subject_to_discuss"];
    }
    SubTextView.returnKeyType = UIReturnKeyDone;
    [scrollview addSubview:SubTextView];
    
     UIButton *SubmitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
	 SubmitBtn.frame=CGRectMake(30, 540, 260, 40);
	 SubmitBtn.tag=30;
     SubmitBtn.layer.cornerRadius=5;
     [SubmitBtn setTitle:@"Submit" forState:UIControlStateNormal];
     [SubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	 [SubmitBtn setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
     [SubmitBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
	 [scrollview addSubview:SubmitBtn];
    [self height];
    [self weight];
    
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - TextView Delegate Methods
/////////////////////////////////////////////////////////////////////////////////

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    /*--
     * This method is called just before the textView becomes active
     * Return YES to let the textView become the First Responder otherwise return NO
     * Use this method to give the textView a green colored background
     --*/
    
    //NSLog(@"textViewShouldBeginEditing:");
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    /*--
     * This method is called when the textView becomes active, or is the First Responder
     --*/
    UIScrollView *scrollView=  (UIScrollView*)[self.view viewWithTag:143];
    // Now add the view as an input accessory view to the selected textfield.
    if(textView.tag==29)
    {
        if(isMoved==YES)
        {
            [scrollView setContentOffset:CGPointMake(0, 500) animated:YES];
        }
        else
        {
            [scrollView setContentOffset:CGPointMake(0, 400) animated:YES];
        }
        
    }
    else
    {
    [scrollView setContentOffset:CGPointMake(0, 220) animated:YES];
    }
    
    //NSLog(@"textViewDidBeginEditing:");
    textView.backgroundColor = [UIColor whiteColor];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    /*--
     * This method is called just before the textView is no longer active
     * Return YES to let the textView resign first responder status, otherwise return NO
     * Use this method to turn the background color back to white
     --*/
    UIScrollView *scrollView=  (UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
   // NSLog(@"textViewShouldEndEditing:");
    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    /*--
     * This method is called when the textView is no longer active
     --*/
    //    UIScrollView *scrollView=  (UIScrollView*)[self.view viewWithTag:143];
    //    // Now add the view as an input accessory view to the selected textfield.
    //    //[textView setInputAccessoryView:inputAccView];
    //    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textView resignFirstResponder];
    //NSLog(@"textViewDidEndEditing:");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSLog(@"textView:shouldChangeTextInRange:replacementText:");
//    
//    NSLog(@"textView.text.length -- %i",textView.text.length);
//    NSLog(@"text.length         -- %i",text.length);
//    NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
//    if([[text componentsSeparatedByCharactersInSet:nonNumberSet]componentsJoinedByString:@""])
//    {
        if([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
        }
//
//        return ([text stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
//    }
//    else
//    {
//       if([text isEqualToString:@""])
//      {
//                return YES;
//      }
//     
//    }

    
    return YES;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange:");
    //This method is called when the user makes a change to the text in the textview
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSLog(@"textViewDidChangeSelection:------->>");
    //This method is called when a selection of text is made or changed
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Medical Conditions Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)Check
{
    
    UILabel *heighLbl=(UILabel*)[self.view viewWithTag:18];
    UILabel *weightLbl=(UILabel*)[self.view viewWithTag:21];
    if([heighLbl.text isEqualToString:@"Select Unit>>"]&& [weightLbl.text isEqualToString:@"Select Unit>>"])
    {
        
        UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
        medTextView.hidden=NO;
        UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
        subLbl.frame=CGRectMake(30, 528, 190, 31);
        UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
        SubTextView.frame=CGRectMake(30, 570, 260, 80);
        UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
        subBtn.frame=CGRectMake(30, 670, 260, 40);
        isMoved=YES;
    }
    
    
    else if(([heighLbl.text isEqualToString:@"Select Unit>>"]) && (![weightLbl.text isEqualToString:@"Select Unit>>"]))
    {
        
        UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
        medTextView.hidden=NO;
        medTextView.frame=CGRectMake(30, 485, 260, 80);
        UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
        subLbl.frame=CGRectMake(30, 578, 190, 31);
        UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
        SubTextView.frame=CGRectMake(30, 618, 260, 80);
        UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
        subBtn.frame=CGRectMake(30, 718, 260, 40);
        isMoved=YES;
    }
    
    else if((![heighLbl.text isEqualToString:@"Select Unit>>"]) && ([weightLbl.text isEqualToString:@"Select Unit>>"]))
    {
        UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
        medTextView.hidden=NO;
        medTextView.frame=CGRectMake(30, 485, 260, 80);
        UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
        subLbl.frame=CGRectMake(30, 578, 190, 31);
        UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
        SubTextView.frame=CGRectMake(30, 618, 260, 80);
        UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
        subBtn.frame=CGRectMake(30, 718, 260, 40);
        isMoved=YES;
    }
    else if((![heighLbl.text isEqualToString:@"Select Unit>>"]) && (![weightLbl.text isEqualToString:@"Select Unit>>"]))
    {
        UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
        medTextView.hidden=NO;
        medTextView.frame=CGRectMake(30, 535, 260, 80);
        UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
        subLbl.frame=CGRectMake(30, 628, 190, 31);
        UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
        SubTextView.frame=CGRectMake(30, 668, 260, 80);
        UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
        subBtn.frame=CGRectMake(30, 768, 260, 40);
        isMoved=YES;
    }
    
}

    
    
    
    



-(void)CheckClicked:(UIButton*)btn
{
    if(btn.currentBackgroundImage ==[UIImage imageNamed:@"uncheck-box.png"])
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"check-box.png"] forState:UIControlStateNormal];
        UILabel *heighLbl=(UILabel*)[self.view viewWithTag:18];
        UILabel *weightLbl=(UILabel*)[self.view viewWithTag:21];
        if([heighLbl.text isEqualToString:@"Select Unit>>"]&& [weightLbl.text isEqualToString:@"Select Unit>>"])
        {
            
            UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
            medTextView.hidden=NO;
            UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
            subLbl.frame=CGRectMake(30, 528, 190, 31);
            UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
            SubTextView.frame=CGRectMake(30, 570, 260, 80);
            UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
            subBtn.frame=CGRectMake(30, 670, 260, 40);
            isMoved=YES;
        }
        
    
        else if(([heighLbl.text isEqualToString:@"Select Unit>>"]) && (![weightLbl.text isEqualToString:@"Select Unit>>"]))
        {
          
            UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
            medTextView.hidden=NO;
            medTextView.frame=CGRectMake(30, 485, 260, 80);
            UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
            subLbl.frame=CGRectMake(30, 578, 190, 31);
            UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
            SubTextView.frame=CGRectMake(30, 618, 260, 80);
            UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
            subBtn.frame=CGRectMake(30, 718, 260, 40);
              isMoved=YES;
          }
        
        else if((![heighLbl.text isEqualToString:@"Select Unit>>"]) && ([weightLbl.text isEqualToString:@"Select Unit>>"]))
        {
            UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
            medTextView.hidden=NO;
            medTextView.frame=CGRectMake(30, 485, 260, 80);
            UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
            subLbl.frame=CGRectMake(30, 578, 190, 31);
            UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
            SubTextView.frame=CGRectMake(30, 618, 260, 80);
            UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
            subBtn.frame=CGRectMake(30, 718, 260, 40);
            isMoved=YES;
        }
             else if((![heighLbl.text isEqualToString:@"Select Unit>>"]) && (![weightLbl.text isEqualToString:@"Select Unit>>"]))
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.hidden=NO;
                medTextView.frame=CGRectMake(30, 535, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 628, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 668, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 768, 260, 40);
                isMoved=YES;
            }
        
    }
       else
      {
        [btn setBackgroundImage:[UIImage imageNamed:@"uncheck-box.png"] forState:UIControlStateNormal];
        //btn.selected = !btn.selected;
          UILabel *heighLbl=(UILabel*)[self.view viewWithTag:18];
          UILabel *weightLbl=(UILabel*)[self.view viewWithTag:21];
          if([heighLbl.text isEqualToString:@"Select Unit>>"] && [weightLbl.text isEqualToString:@"Select Unit>>"])
          {
              UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
              medTextView.hidden=YES;
              medTextView.frame=CGRectMake(30, 435, 260, 80);
              UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
              subLbl.frame=CGRectMake(30, 430, 190, 31);
              UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
              SubTextView.frame=CGRectMake(30, 470, 260, 80);
              UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
              subBtn.frame=CGRectMake(30, 570, 260, 40);
              isMoved=NO;
          }
          else if((![heighLbl.text isEqualToString:@"Select Unit>>"]) && ([weightLbl.text isEqualToString:@"Select Unit>>"]))
          {
              UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
              medTextView.hidden=YES;
              medTextView.frame=CGRectMake(30, 485, 260, 80);
              UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
              subLbl.frame=CGRectMake(30, 480, 190, 31);
              UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
              SubTextView.frame=CGRectMake(30, 520, 260, 80);
              UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
              subBtn.frame=CGRectMake(30, 620, 260, 40);
              isMoved=NO;
          }
          
          else if(([heighLbl.text isEqualToString:@"Select Unit>>"]) && (![weightLbl.text isEqualToString:@"Select Unit>>"]))
          {
              UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
              medTextView.hidden=YES;
              medTextView.frame=CGRectMake(30, 485, 260, 80);
              UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
              subLbl.frame=CGRectMake(30, 480, 190, 31);
              UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
              SubTextView.frame=CGRectMake(30, 520, 260, 80);
              UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
              subBtn.frame=CGRectMake(30, 620, 260, 40);
              isMoved=NO;
          }

          
           else if((![heighLbl.text isEqualToString:@"Select Unit>>"]) && (![weightLbl.text isEqualToString:@"Select Unit>>"]))
           {
               UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
               medTextView.hidden=YES;
               UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
               subLbl.frame=CGRectMake(30, 530, 190, 31);
               UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
               subTextView.frame=CGRectMake(30, 570, 260, 80);
               
               UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
               submitBtn.frame=CGRectMake(30, 670, 260, 40);
               isMoved=NO;
           }
          
         
          
          
        
    }
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Gender Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnGenderClicked:(UIButton*)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(genderpicker!=nil)
	{
        
		[genderpicker removeFromSuperview];
		genderpicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideGender:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	genderpicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    genderpicker.tag=8;
    genderpicker.delegate=self;
    genderpicker.dataSource=self;
    genderpicker.showsSelectionIndicator = YES;
    genderpicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	genderpicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:genderpicker];
	
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Click Event on Gender Picker
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideGender:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
	//[UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button DatePicker Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnDateFrom_TouchUpInside:(UIButton*)sender
{
   
    UILabel *lblDateFromData=(UILabel*)[self.view viewWithTag:12];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    NSDate *bDate=[df dateFromString:lblDateFromData.text];
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(DatepickerView!=nil)
	{
		[DatepickerView removeFromSuperview];
		DatepickerView=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideDate:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	DatepickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
	DatepickerView.datePickerMode = UIDatePickerModeDate;
    DatepickerView.hidden = NO;
    DatepickerView.tag=sender.tag;
    if(isGrid==YES)
    {
        DatepickerView.date=bDate;
    }
    else
    {
        DatepickerView.date = [NSDate date];
    }
    DatepickerView.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	DatepickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [DatepickerView addTarget:self
	               action:@selector(changeDateFromLabel:)
	     forControlEvents:UIControlEventValueChanged];
	[customPickerView addSubview:DatepickerView];
    
    
	
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Date Picker Select Method
/////////////////////////////////////////////////////////////////////////////////

- (void)changeDateFromLabel:(id)sender
{
    
	//Use NSDateFormatter to write out the date in a friendly format
    UILabel *lblDateFromData=(UILabel*)[self.view viewWithTag:12];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
	lblDateFromData.text = [NSString stringWithFormat:@"%@",
                            [df stringFromDate:DatepickerView.date]];
	
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Button Click Event on DatePicker
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideDate:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    UILabel *lblDateFromData=(UILabel*)[self.view viewWithTag:12];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    lblDateFromData.text = [NSString stringWithFormat:@"%@",
                            [df stringFromDate:DatepickerView.date]];
    
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
	//[UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Height Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnHeightFrom_TouchUpInside:(UIButton*)sender
{
    UILabel *heightUnit=(UILabel*)[self.view viewWithTag:18];
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(heightPicker!=nil)
	{
		[heightPicker removeFromSuperview];
		heightPicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideHeight:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	heightPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    heightPicker.tag=17;
    heightPicker.delegate=self;
    heightPicker.dataSource=self;
    heightPicker.showsSelectionIndicator = YES;
    heightPicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	heightPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:heightPicker];
    NSInteger row;
    if(isGrid==YES)
    {
        row=[heightUnitArray indexOfObject:heightUnit.text];
        [heightPicker selectRow:row inComponent:0 animated:YES];
    }
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Click Event on Height Picker
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideHeight:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
    [self height];
	//[UIView commitAnimations];
}

-(void) height
{
    UILabel *heighLbl=(UILabel*)[self.view viewWithTag:18];
    UILabel *weightLBL=(UILabel*)[self.view viewWithTag:21];
    if([heighLbl.text isEqualToString:@"Centimetres"])
    {
        if([weightLBL.text isEqualToString:@"Select Unit>>"])
        {
            
            UIButton *heightUnitFButton=(UIButton*)[self.view viewWithTag:35];
            [heightUnitFButton removeFromSuperview];
            UILabel *heightUnitFLbl=(UILabel*)[self.view viewWithTag:36];
            [heightUnitFLbl removeFromSuperview];
            UIButton *heightUnitIButton=(UIButton*)[self.view viewWithTag:37];
            [heightUnitIButton removeFromSuperview];
            UILabel *heightUnitILbl=(UILabel*)[self.view viewWithTag:38];
            [heightUnitILbl removeFromSuperview];
            UIButton *heightUnitOIButton=(UIButton*)[self.view viewWithTag:39];
            [heightUnitOIButton removeFromSuperview];
            UILabel *heightUnitOILbl=(UILabel*)[self.view viewWithTag:40];
            [heightUnitOILbl removeFromSuperview];
            UIButton *heightUnitMetresButton=(UIButton*)[self.view viewWithTag:41];
            [heightUnitMetresButton removeFromSuperview];
            UILabel *heightUnitMetresLbl=(UILabel*)[self.view viewWithTag:42];
            [heightUnitMetresLbl removeFromSuperview];
            UIButton *heightUnitCButton=[UIButton buttonWithType:UIButtonTypeCustom];
            heightUnitCButton.frame=CGRectMake(170, 210, 120, 30);
            heightUnitCButton.tag=31;
            heightUnitCButton.layer.cornerRadius=5;
            heightUnitCButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [heightUnitCButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [heightUnitCButton addTarget:self action:@selector(btnHeightUnitCFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:heightUnitCButton];
            
            UILabel *heightUnitCLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 210, 120, 30)];
            heightUnitCLbl.tag=32;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]isEqualToString:@""]  )
                {
                        heightUnitCLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"centimetres"]objectAtIndex:0] intValue]];
                }
                else
                {
                heightUnitCLbl.text=[NSString stringWithFormat:@"%d",[[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]intValue]];
                }
            }
            else
            {
                heightUnitCLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"centimetres"]objectAtIndex:0] intValue]];
            }
            heightUnitCLbl.backgroundColor=[UIColor clearColor];
            heightUnitCLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:heightUnitCLbl];
            
            UILabel *weight=(UILabel*)[self.view viewWithTag:19];
            weight.frame=CGRectMake(30, 260, 190, 31);
            UIButton *weightBtn=(UIButton*)[self.view viewWithTag:20];
            weightBtn.frame=CGRectMake(170, 260, 120, 30);
            UILabel *weighttextLbl=(UILabel*)[self.view viewWithTag:21];
            weighttextLbl.frame=CGRectMake(180, 260, 120, 30);
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 310, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 350, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 350, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 390, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 410, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 455, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 548, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 688, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 688, 260, 40);
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 450, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 490, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 590, 260, 40);
            }
            
        }
        else
        {
            
            UIButton *heightUnitFButton=(UIButton*)[self.view viewWithTag:35];
            [heightUnitFButton removeFromSuperview];
            UILabel *heightUnitFLbl=(UILabel*)[self.view viewWithTag:36];
            [heightUnitFLbl removeFromSuperview];
            UIButton *heightUnitIButton=(UIButton*)[self.view viewWithTag:37];
            [heightUnitIButton removeFromSuperview];
            UILabel *heightUnitILbl=(UILabel*)[self.view viewWithTag:38];
            [heightUnitILbl removeFromSuperview];
            UIButton *heightUnitOIButton=(UIButton*)[self.view viewWithTag:39];
            [heightUnitOIButton removeFromSuperview];
            UILabel *heightUnitOILbl=(UILabel*)[self.view viewWithTag:40];
            [heightUnitOILbl removeFromSuperview];
            UIButton *heightUnitMetresButton=(UIButton*)[self.view viewWithTag:41];
            [heightUnitMetresButton removeFromSuperview];
            UILabel *heightUnitMetresLbl=(UILabel*)[self.view viewWithTag:42];
            [heightUnitMetresLbl removeFromSuperview];
            UIButton *heightUnitCButton=[UIButton buttonWithType:UIButtonTypeCustom];
            heightUnitCButton.frame=CGRectMake(170, 210, 120, 30);
            heightUnitCButton.tag=31;
            heightUnitCButton.layer.cornerRadius=5;
            heightUnitCButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [heightUnitCButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [heightUnitCButton addTarget:self action:@selector(btnHeightUnitCFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:heightUnitCButton];
            
            UILabel *heightUnitCLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 210, 120, 30)];
            heightUnitCLbl.tag=32;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]isEqualToString:@""]  )
                {
                    heightUnitCLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"centimetres"]objectAtIndex:0] intValue]];
                }
                else
                {
                    heightUnitCLbl.text=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"];
                }
            }
            else
            {
                heightUnitCLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"centimetres"]objectAtIndex:0] intValue]];
            }
            heightUnitCLbl.backgroundColor=[UIColor clearColor];
            heightUnitCLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:heightUnitCLbl];
            
            UILabel *weight=(UILabel*)[self.view viewWithTag:19];
            weight.frame=CGRectMake(30, 260, 190, 31);
            UIButton *weightBtn=(UIButton*)[self.view viewWithTag:20];
            weightBtn.frame=CGRectMake(170, 260, 120, 30);
            UILabel *weighttextLbl=(UILabel*)[self.view viewWithTag:21];
            weighttextLbl.frame=CGRectMake(180, 260, 120, 30);
            
            UIButton *weightUnitBtn=(UIButton*)[self.view viewWithTag:33];
            weightUnitBtn.frame=CGRectMake(170, 310, 120, 30);
            UILabel *weightUnitLbl=(UILabel*)[self.view viewWithTag:34];
            weightUnitLbl.frame=CGRectMake(180, 310, 120, 30);
            
            
            UIButton *weightStoneBtn=(UIButton*)[self.view viewWithTag:43];
            weightStoneBtn.frame=CGRectMake(170, 310, 50, 30);
            UILabel *weightStoneLbl=(UILabel*)[self.view viewWithTag:44];
            weightStoneLbl.frame=CGRectMake(180, 310, 50, 30);
            UIButton *weightLbsBtn=(UIButton*)[self.view viewWithTag:45];
            weightLbsBtn.frame=CGRectMake(240, 310, 50, 30);
            UILabel *weightLbsLbl=(UILabel*)[self.view viewWithTag:46];
            weightLbsLbl.frame=CGRectMake(250, 310, 50, 30);
            UIButton *weightPoundsBtn=(UIButton*)[self.view viewWithTag:47];
            weightPoundsBtn.frame=CGRectMake(170, 310, 120, 30);
            UILabel *weightPoundsLbl=(UILabel*)[self.view viewWithTag:48];
            weightPoundsLbl.frame=CGRectMake(180, 310, 120, 30);
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 360, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 400, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 400, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 440, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 460, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 505, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 598, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 638, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 738, 260, 40);
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 500, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 540, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 640, 260, 40);
            }
            
        }
        
        
        
    }
    
    else if([heighLbl.text isEqualToString:@"Feet & Inches"])
    {
        if([weightLBL.text isEqualToString:@"Select Unit>>"])
        {
            UIButton *heightUnitButton=(UIButton*)[self.view viewWithTag:31];
            [heightUnitButton removeFromSuperview];
            UILabel *heightUnitLbl=(UILabel*)[self.view viewWithTag:32];
            [heightUnitLbl removeFromSuperview];
            UIButton *heightUnitOIButton=(UIButton*)[self.view viewWithTag:39];
            [heightUnitOIButton removeFromSuperview];
            UILabel *heightUnitOILbl=(UILabel*)[self.view viewWithTag:40];
            [heightUnitOILbl removeFromSuperview];
            UIButton *heightUnitMetresButton=(UIButton*)[self.view viewWithTag:41];
            [heightUnitMetresButton removeFromSuperview];
            UILabel *heightUnitMetresLbl=(UILabel*)[self.view viewWithTag:42];
            [heightUnitMetresLbl removeFromSuperview];
            UIButton *heightUnitFButton=[UIButton buttonWithType:UIButtonTypeCustom];
            heightUnitFButton.frame=CGRectMake(170, 210, 50, 30);
            heightUnitFButton.tag=35;
            heightUnitFButton.layer.cornerRadius=5;
            heightUnitFButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [heightUnitFButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [heightUnitFButton addTarget:self action:@selector(btnHeightUnitFFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:heightUnitFButton];
            
            UILabel *heightUnitFLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 210, 50, 30)];
            heightUnitFLbl.tag=36;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]isEqualToString:@""]  )
                {
                    heightUnitFLbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_feet"]objectAtIndex:0] ;
                }
                else
                {
                    NSString *feetinches=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"];
                    NSString *pattern = @","; // Match a comma not followed by white space.
                    NSString *tempSeparator = @"SomeTempSeparatorString"; // You can also just use "|", as long as you are sure it is not in your input.
                    
                    // Now replace the single commas but not the ones you want to keep
                    NSString *cleanedStr = [feetinches stringByReplacingOccurrencesOfString: pattern
                                                                                 withString: tempSeparator
                                                                                    options: NSRegularExpressionSearch
                                                                                      range: NSMakeRange(0, feetinches.length)];
                    
                    // Now all that is needed is to split the string
                    NSArray *result = [cleanedStr componentsSeparatedByString: tempSeparator];
                    heightUnitFLbl.text=[result objectAtIndex:0];
                }
                
            }
            else
            {
                heightUnitFLbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_feet"]objectAtIndex:0] ;
            }
            heightUnitFLbl.backgroundColor=[UIColor clearColor];
            heightUnitFLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:heightUnitFLbl];
            
            UIButton *heightUnitIButton=[UIButton buttonWithType:UIButtonTypeCustom];
            heightUnitIButton.frame=CGRectMake(240, 210, 50, 30);
            heightUnitIButton.tag=37;
            heightUnitIButton.layer.cornerRadius=5;
            heightUnitIButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [heightUnitIButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [heightUnitIButton addTarget:self action:@selector(btnHeightUnitIFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:heightUnitIButton];
            
            UILabel *heightUnitILbl=[[UILabel alloc]initWithFrame:CGRectMake(250, 210, 50, 30)];
            heightUnitILbl.tag=38;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]isEqualToString:@""]  )
                {
                    heightUnitILbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_inches"]objectAtIndex:0] ;
                }
                else
                {
                    NSString *feetinches=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"];
                    NSString *pattern = @","; // Match a comma not followed by white space.
                    NSString *tempSeparator = @"SomeTempSeparatorString"; // You can also just use "|", as long as you are sure it is not in your input.
                    
                    // Now replace the single commas but not the ones you want to keep
                    NSString *cleanedStr = [feetinches stringByReplacingOccurrencesOfString: pattern
                                                                                 withString: tempSeparator
                                                                                    options: NSRegularExpressionSearch
                                                                                      range: NSMakeRange(0, feetinches.length)];
                    
                    // Now all that is needed is to split the string
                    NSArray *result = [cleanedStr componentsSeparatedByString: tempSeparator];
                    heightUnitILbl.text=[result objectAtIndex:1];
                }
            }
            else
            {
                heightUnitILbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_inches"]objectAtIndex:0] ;
            }
            heightUnitILbl.backgroundColor=[UIColor clearColor];
            heightUnitILbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:heightUnitILbl];
            
            UILabel *weight=(UILabel*)[self.view viewWithTag:19];
            weight.frame=CGRectMake(30, 260, 190, 31);
            UIButton *weightBtn=(UIButton*)[self.view viewWithTag:20];
            weightBtn.frame=CGRectMake(170, 260, 120, 30);
            UILabel *weighttextLbl=(UILabel*)[self.view viewWithTag:21];
            weighttextLbl.frame=CGRectMake(180, 260, 120, 30);
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 310, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 350, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 350, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 390, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 410, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 455, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 548, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 588, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 688, 260, 40);
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 450, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 490, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 590, 260, 40);
            }
            
        }
        else
        {
            UIButton *heightUnitButton=(UIButton*)[self.view viewWithTag:31];
            [heightUnitButton removeFromSuperview];
            UILabel *heightUnitLbl=(UILabel*)[self.view viewWithTag:32];
            [heightUnitLbl removeFromSuperview];
            UIButton *heightUnitOIButton=(UIButton*)[self.view viewWithTag:39];
            [heightUnitOIButton removeFromSuperview];
            UILabel *heightUnitOILbl=(UILabel*)[self.view viewWithTag:40];
            [heightUnitOILbl removeFromSuperview];
            UIButton *heightUnitMetresButton=(UIButton*)[self.view viewWithTag:41];
            [heightUnitMetresButton removeFromSuperview];
            UILabel *heightUnitMetresLbl=(UILabel*)[self.view viewWithTag:42];
            [heightUnitMetresLbl removeFromSuperview];
            UIButton *heightUnitFButton=[UIButton buttonWithType:UIButtonTypeCustom];
            heightUnitFButton.frame=CGRectMake(170, 210, 50, 30);
            heightUnitFButton.tag=35;
            heightUnitFButton.layer.cornerRadius=5;
            heightUnitFButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [heightUnitFButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [heightUnitFButton addTarget:self action:@selector(btnHeightUnitFFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:heightUnitFButton];
            
            UILabel *heightUnitFLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 210, 50, 30)];
            heightUnitFLbl.tag=36;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]isEqualToString:@""]  )
                {
                    heightUnitFLbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_feet"]objectAtIndex:0] ;
                }
                else
                {
                    NSString *feetinches=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"];
                    NSString *pattern = @","; // Match a comma not followed by white space.
                    NSString *tempSeparator = @"SomeTempSeparatorString"; // You can also just use "|", as long as you are sure it is not in your input.
                    
                    // Now replace the single commas but not the ones you want to keep
                    NSString *cleanedStr = [feetinches stringByReplacingOccurrencesOfString: pattern
                                                                                 withString: tempSeparator
                                                                                    options: NSRegularExpressionSearch
                                                                                      range: NSMakeRange(0, feetinches.length)];
                    
                    // Now all that is needed is to split the string
                    NSArray *result = [cleanedStr componentsSeparatedByString: tempSeparator];
                    heightUnitFLbl.text=[result objectAtIndex:0];
                }

            }
            else
            {
                heightUnitFLbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_feet"]objectAtIndex:0] ;
            }
            heightUnitFLbl.backgroundColor=[UIColor clearColor];
            heightUnitFLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:heightUnitFLbl];
            
            UIButton *heightUnitIButton=[UIButton buttonWithType:UIButtonTypeCustom];
            heightUnitIButton.frame=CGRectMake(240, 210, 50, 30);
            heightUnitIButton.tag=37;
            heightUnitIButton.layer.cornerRadius=5;
            heightUnitIButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [heightUnitIButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [heightUnitIButton addTarget:self action:@selector(btnHeightUnitIFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:heightUnitIButton];
            
            UILabel *heightUnitILbl=[[UILabel alloc]initWithFrame:CGRectMake(250, 210, 50, 30)];
            heightUnitILbl.tag=38;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]isEqualToString:@""]  )
                {
                    heightUnitILbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_inches"]objectAtIndex:0] ;
                }
                else
                {
                    NSString *feetinches=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"];
                    NSString *pattern = @","; // Match a comma not followed by white space.
                    NSString *tempSeparator = @"SomeTempSeparatorString"; // You can also just use "|", as long as you are sure it is not in your input.
                    
                    // Now replace the single commas but not the ones you want to keep
                    NSString *cleanedStr = [feetinches stringByReplacingOccurrencesOfString: pattern
                                                                                 withString: tempSeparator
                                                                                    options: NSRegularExpressionSearch
                                                                                      range: NSMakeRange(0, feetinches.length)];
                    
                    // Now all that is needed is to split the string
                    NSArray *result = [cleanedStr componentsSeparatedByString: tempSeparator];
                    heightUnitILbl.text=[result objectAtIndex:1];
                }

            }
            else
            {
                heightUnitILbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_inches"]objectAtIndex:0] ;
            }
            heightUnitILbl.backgroundColor=[UIColor clearColor];
            heightUnitILbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:heightUnitILbl];
            
            UILabel *weight=(UILabel*)[self.view viewWithTag:19];
            weight.frame=CGRectMake(30, 260, 190, 31);
            UIButton *weightBtn=(UIButton*)[self.view viewWithTag:20];
            weightBtn.frame=CGRectMake(170, 260, 120, 30);
            UILabel *weighttextLbl=(UILabel*)[self.view viewWithTag:21];
            weighttextLbl.frame=CGRectMake(180, 260, 120, 30);
            
            UIButton *weightUnitBtn=(UIButton*)[self.view viewWithTag:33];
            weightUnitBtn.frame=CGRectMake(170, 310, 120, 30);
            UILabel *weightUnitLbl=(UILabel*)[self.view viewWithTag:34];
            weightUnitLbl.frame=CGRectMake(180, 310, 120, 30);
            
            UIButton *weightStoneBtn=(UIButton*)[self.view viewWithTag:43];
            weightStoneBtn.frame=CGRectMake(170, 310, 50, 30);
            UILabel *weightStoneLbl=(UILabel*)[self.view viewWithTag:44];
            weightStoneLbl.frame=CGRectMake(180, 310, 50, 30);
            UIButton *weightLbsBtn=(UIButton*)[self.view viewWithTag:45];
            weightLbsBtn.frame=CGRectMake(240, 310, 50, 30);
            UILabel *weightLbsLbl=(UILabel*)[self.view viewWithTag:46];
            weightLbsLbl.frame=CGRectMake(250, 310, 50, 30);
            UIButton *weightPoundsBtn=(UIButton*)[self.view viewWithTag:47];
            weightPoundsBtn.frame=CGRectMake(170, 310, 120, 30);
            UILabel *weightPoundsLbl=(UILabel*)[self.view viewWithTag:48];
            weightPoundsLbl.frame=CGRectMake(180, 310, 120, 30);
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 360, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 400, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 400, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 440, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 460, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 505, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 598, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 638, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 738, 260, 40);
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 500, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 540, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 640, 260, 40);
            }
            
        }
    }
    
    else if([heighLbl.text isEqualToString:@"Inches"])
    {
        if([weightLBL.text isEqualToString:@"Select Unit>>"])
        {
            UIButton *heightUnitButton=(UIButton*)[self.view viewWithTag:31];
            [heightUnitButton removeFromSuperview];
            UILabel *heightUnitLbl=(UILabel*)[self.view viewWithTag:32];
            [heightUnitLbl removeFromSuperview];
            UIButton *heightUnitFButton=(UIButton*)[self.view viewWithTag:35];
            [heightUnitFButton removeFromSuperview];
            UILabel *heightUnitFLbl=(UILabel*)[self.view viewWithTag:36];
            [heightUnitFLbl removeFromSuperview];
            UIButton *heightUnitIButton=(UIButton*)[self.view viewWithTag:37];
            [heightUnitIButton removeFromSuperview];
            UILabel *heightUnitILbl=(UILabel*)[self.view viewWithTag:38];
            [heightUnitILbl removeFromSuperview];
            UIButton *heightUnitMetresButton=(UIButton*)[self.view viewWithTag:41];
            [heightUnitMetresButton removeFromSuperview];
            UILabel *heightUnitMetresLbl=(UILabel*)[self.view viewWithTag:42];
            [heightUnitMetresLbl removeFromSuperview];
            UIButton *heightUnitOIButton=[UIButton buttonWithType:UIButtonTypeCustom];
            heightUnitOIButton.frame=CGRectMake(170, 210, 120, 30);
            heightUnitOIButton.tag=39;
            heightUnitOIButton.layer.cornerRadius=5;
            heightUnitOIButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [heightUnitOIButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [heightUnitOIButton addTarget:self action:@selector(btnHeightUnitOIFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:heightUnitOIButton];
            
            UILabel *heightUnitOILbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 210, 120, 30)];
            heightUnitOILbl.tag=40;
            if(isGrid==YES)
            {
                 if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]isEqualToString:@""]  )
                 {
                     heightUnitOILbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"inches"]objectAtIndex:0] intValue]];
                 }
                else
                {
                    heightUnitOILbl.text=[NSString stringWithFormat:@"%d",[[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]intValue]];
                }
                
            }
            else
            {
                heightUnitOILbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"inches"]objectAtIndex:0] intValue]];
            }
            heightUnitOILbl.backgroundColor=[UIColor clearColor];
            heightUnitOILbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:heightUnitOILbl];
            
            
            UILabel *weight=(UILabel*)[self.view viewWithTag:19];
            weight.frame=CGRectMake(30, 260, 190, 31);
            UIButton *weightBtn=(UIButton*)[self.view viewWithTag:20];
            weightBtn.frame=CGRectMake(170, 260, 120, 30);
            UILabel *weighttextLbl=(UILabel*)[self.view viewWithTag:21];
            weighttextLbl.frame=CGRectMake(180, 260, 120, 30);
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 310, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 350, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 350, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 390, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 410, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 455, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 548, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 588, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 688, 260, 40);
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 450, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 490, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 590, 260, 40);
            }
            
        }
        else
        {
            
            UIButton *heightUnitButton=(UIButton*)[self.view viewWithTag:31];
            [heightUnitButton removeFromSuperview];
            UILabel *heightUnitLbl=(UILabel*)[self.view viewWithTag:32];
            [heightUnitLbl removeFromSuperview];
            UIButton *heightUnitFButton=(UIButton*)[self.view viewWithTag:35];
            [heightUnitFButton removeFromSuperview];
            UILabel *heightUnitFLbl=(UILabel*)[self.view viewWithTag:36];
            [heightUnitFLbl removeFromSuperview];
            UIButton *heightUnitIButton=(UIButton*)[self.view viewWithTag:37];
            [heightUnitIButton removeFromSuperview];
            UILabel *heightUnitILbl=(UILabel*)[self.view viewWithTag:38];
            [heightUnitILbl removeFromSuperview];
            UIButton *heightUnitMetresButton=(UIButton*)[self.view viewWithTag:41];
            [heightUnitMetresButton removeFromSuperview];
            UILabel *heightUnitMetresLbl=(UILabel*)[self.view viewWithTag:42];
            [heightUnitMetresLbl removeFromSuperview];
            UIButton *heightUnitOIButton=[UIButton buttonWithType:UIButtonTypeCustom];
            heightUnitOIButton.frame=CGRectMake(170, 210, 120, 30);
            heightUnitOIButton.tag=39;
            heightUnitOIButton.layer.cornerRadius=5;
            heightUnitOIButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [heightUnitOIButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [heightUnitOIButton addTarget:self action:@selector(btnHeightUnitOIFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:heightUnitOIButton];
            
            UILabel *heightUnitOILbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 210, 120, 30)];
            heightUnitOILbl.tag=40;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]isEqualToString:@""]  )
                {
                    heightUnitOILbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"inches"]objectAtIndex:0] intValue]];
                }
                else
                {
                    heightUnitOILbl.text=[NSString stringWithFormat:@"%d",[[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]intValue]];
                }
                
            }
            else
            {
                heightUnitOILbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"inches"]objectAtIndex:0] intValue]];
            }
            heightUnitOILbl.backgroundColor=[UIColor clearColor];
            heightUnitOILbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:heightUnitOILbl];
            
            
            
            UILabel *weight=(UILabel*)[self.view viewWithTag:19];
            weight.frame=CGRectMake(30, 260, 190, 31);
            UIButton *weightBtn=(UIButton*)[self.view viewWithTag:20];
            weightBtn.frame=CGRectMake(170, 260, 120, 30);
            UILabel *weighttextLbl=(UILabel*)[self.view viewWithTag:21];
            weighttextLbl.frame=CGRectMake(180, 260, 120, 30);
            
            UIButton *weightUnitBtn=(UIButton*)[self.view viewWithTag:33];
            weightUnitBtn.frame=CGRectMake(170, 310, 120, 30);
            UILabel *weightUnitLbl=(UILabel*)[self.view viewWithTag:34];
            weightUnitLbl.frame=CGRectMake(180, 310, 120, 30);
            
            UIButton *weightStoneBtn=(UIButton*)[self.view viewWithTag:43];
            weightStoneBtn.frame=CGRectMake(170, 310, 50, 30);
            UILabel *weightStoneLbl=(UILabel*)[self.view viewWithTag:44];
            weightStoneLbl.frame=CGRectMake(180, 310, 50, 30);
            UIButton *weightLbsBtn=(UIButton*)[self.view viewWithTag:45];
            weightLbsBtn.frame=CGRectMake(240, 310, 50, 30);
            UILabel *weightLbsLbl=(UILabel*)[self.view viewWithTag:46];
            weightLbsLbl.frame=CGRectMake(250, 310, 50, 30);
            UIButton *weightPoundsBtn=(UIButton*)[self.view viewWithTag:47];
            weightPoundsBtn.frame=CGRectMake(170, 310, 120, 30);
            UILabel *weightPoundsLbl=(UILabel*)[self.view viewWithTag:48];
            weightPoundsLbl.frame=CGRectMake(180, 310, 120, 30);
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 360, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 400, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 400, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 440, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 460, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 505, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 598, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 638, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 738, 260, 40);
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 500, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 540, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 640, 260, 40);
            }
            
        }
    }
    
    else if([heighLbl.text isEqualToString:@"Metres"])
    {
        if([weightLBL.text isEqualToString:@"Select Unit>>"])
        {
            UIButton *heightUnitButton=(UIButton*)[self.view viewWithTag:31];
            [heightUnitButton removeFromSuperview];
            UILabel *heightUnitLbl=(UILabel*)[self.view viewWithTag:32];
            [heightUnitLbl removeFromSuperview];
            UIButton *heightUnitFButton=(UIButton*)[self.view viewWithTag:35];
            [heightUnitFButton removeFromSuperview];
            UILabel *heightUnitFLbl=(UILabel*)[self.view viewWithTag:36];
            [heightUnitFLbl removeFromSuperview];
            UIButton *heightUnitIButton=(UIButton*)[self.view viewWithTag:37];
            [heightUnitIButton removeFromSuperview];
            UILabel *heightUnitILbl=(UILabel*)[self.view viewWithTag:38];
            [heightUnitILbl removeFromSuperview];
            UIButton *heightUnitOIButton=(UIButton*)[self.view viewWithTag:39];
            [heightUnitOIButton removeFromSuperview];
            UILabel *heightUnitOILbl=(UILabel*)[self.view viewWithTag:40];
            [heightUnitOILbl removeFromSuperview];
            UIButton *heightUnitMetresButton=[UIButton buttonWithType:UIButtonTypeCustom];
            heightUnitMetresButton.frame=CGRectMake(170, 210, 120, 30);
            heightUnitMetresButton.tag=41;
            heightUnitMetresButton.layer.cornerRadius=5;
            heightUnitMetresButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [heightUnitMetresButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [heightUnitMetresButton addTarget:self action:@selector(btnHeightUnitMetresFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:heightUnitMetresButton];
            
            UILabel *heightUnitMetresLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 210, 120, 30)];
            heightUnitMetresLbl.tag=42;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]isEqualToString:@""]  )
                {
                    heightUnitMetresLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"metres"]objectAtIndex:0] intValue]];
                }
                else
                {
                    heightUnitMetresLbl.text=[NSString stringWithFormat:@"%d",[[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]intValue]];
                }
                
            }
            else
            {
                heightUnitMetresLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"metres"]objectAtIndex:0] intValue]];
            }
            heightUnitMetresLbl.backgroundColor=[UIColor clearColor];
            heightUnitMetresLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:heightUnitMetresLbl];
            
            
            UILabel *weight=(UILabel*)[self.view viewWithTag:19];
            weight.frame=CGRectMake(30, 260, 190, 31);
            UIButton *weightBtn=(UIButton*)[self.view viewWithTag:20];
            weightBtn.frame=CGRectMake(170, 260, 120, 30);
            UILabel *weighttextLbl=(UILabel*)[self.view viewWithTag:21];
            weighttextLbl.frame=CGRectMake(180, 260, 120, 30);
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 310, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 350, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 350, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 390, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 410, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 455, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 548, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 588, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 688, 260, 40);
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 450, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 490, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 590, 260, 40);
            }
            
        }
        else
        {
            
            UIButton *heightUnitButton=(UIButton*)[self.view viewWithTag:31];
            [heightUnitButton removeFromSuperview];
            UILabel *heightUnitLbl=(UILabel*)[self.view viewWithTag:32];
            [heightUnitLbl removeFromSuperview];
            UIButton *heightUnitFButton=(UIButton*)[self.view viewWithTag:35];
            [heightUnitFButton removeFromSuperview];
            UILabel *heightUnitFLbl=(UILabel*)[self.view viewWithTag:36];
            [heightUnitFLbl removeFromSuperview];
            UIButton *heightUnitIButton=(UIButton*)[self.view viewWithTag:37];
            [heightUnitIButton removeFromSuperview];
            UILabel *heightUnitILbl=(UILabel*)[self.view viewWithTag:38];
            [heightUnitILbl removeFromSuperview];
            UIButton *heightUnitOIButton=(UIButton*)[self.view viewWithTag:39];
            [heightUnitOIButton removeFromSuperview];
            UILabel *heightUnitOILbl=(UILabel*)[self.view viewWithTag:40];
            [heightUnitOILbl removeFromSuperview];
            UIButton *heightUnitMetresButton=[UIButton buttonWithType:UIButtonTypeCustom];
            heightUnitMetresButton.frame=CGRectMake(170, 210, 120, 30);
            heightUnitMetresButton.tag=41;
            heightUnitMetresButton.layer.cornerRadius=5;
            heightUnitMetresButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [heightUnitMetresButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [heightUnitMetresButton addTarget:self action:@selector(btnHeightUnitMetresFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:heightUnitMetresButton];
            
            UILabel *heightUnitMetresLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 210, 120, 30)];
            heightUnitMetresLbl.tag=42;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]isEqualToString:@""]  )
                {
                    heightUnitMetresLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"metres"]objectAtIndex:0] intValue]];
                }
                else
                {
                    heightUnitMetresLbl.text=[NSString stringWithFormat:@"%d",[[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"height"]intValue]];
                }
            }
            else
            {
                heightUnitMetresLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"metres"]objectAtIndex:0] intValue]];
            }
            heightUnitMetresLbl.backgroundColor=[UIColor clearColor];
            heightUnitMetresLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:heightUnitMetresLbl];
            
            
            
            UILabel *weight=(UILabel*)[self.view viewWithTag:19];
            weight.frame=CGRectMake(30, 260, 190, 31);
            UIButton *weightBtn=(UIButton*)[self.view viewWithTag:20];
            weightBtn.frame=CGRectMake(170, 260, 120, 30);
            UILabel *weighttextLbl=(UILabel*)[self.view viewWithTag:21];
            weighttextLbl.frame=CGRectMake(180, 260, 120, 30);
            
            UIButton *weightUnitBtn=(UIButton*)[self.view viewWithTag:33];
            weightUnitBtn.frame=CGRectMake(170, 310, 120, 30);
            UILabel *weightUnitLbl=(UILabel*)[self.view viewWithTag:34];
            weightUnitLbl.frame=CGRectMake(180, 310, 120, 30);
            
            UIButton *weightStoneBtn=(UIButton*)[self.view viewWithTag:43];
            weightStoneBtn.frame=CGRectMake(170, 310, 50, 30);
            UILabel *weightStoneLbl=(UILabel*)[self.view viewWithTag:44];
            weightStoneLbl.frame=CGRectMake(180, 310, 50, 30);
            UIButton *weightLbsBtn=(UIButton*)[self.view viewWithTag:45];
            weightLbsBtn.frame=CGRectMake(240, 310, 50, 30);
            UILabel *weightLbsLbl=(UILabel*)[self.view viewWithTag:46];
            weightLbsLbl.frame=CGRectMake(250, 310, 50, 30);
            UIButton *weightPoundsBtn=(UIButton*)[self.view viewWithTag:47];
            weightPoundsBtn.frame=CGRectMake(170, 310, 120, 30);
            UILabel *weightPoundsLbl=(UILabel*)[self.view viewWithTag:48];
            weightPoundsLbl.frame=CGRectMake(180, 310, 120, 30);
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 360, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 400, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 400, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 440, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 460, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 505, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 598, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 638, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 738, 260, 40);
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 500, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 540, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 640, 260, 40);
            }
            
        }
    }
    
    
    else if([heighLbl.text isEqualToString:@"Select Unit>>"])
    {
        if([weightLBL.text isEqualToString:@"Select Unit>>"])
        {
            UIButton *heightUnitButton=(UIButton*)[self.view viewWithTag:31];
            [heightUnitButton removeFromSuperview];
            UILabel *heightUnitLbl=(UILabel*)[self.view viewWithTag:32];
            [heightUnitLbl removeFromSuperview];
            UIButton *heightUnitFButton=(UIButton*)[self.view viewWithTag:35];
            [heightUnitFButton removeFromSuperview];
            UILabel *heightUnitFLbl=(UILabel*)[self.view viewWithTag:36];
            [heightUnitFLbl removeFromSuperview];
            UIButton *heightUnitIButton=(UIButton*)[self.view viewWithTag:37];
            [heightUnitIButton removeFromSuperview];
            UILabel *heightUnitILbl=(UILabel*)[self.view viewWithTag:38];
            [heightUnitILbl removeFromSuperview];
            UIButton *heightUnitOIButton=(UIButton*)[self.view viewWithTag:39];
            [heightUnitOIButton removeFromSuperview];
            UILabel *heightUnitOILbl=(UILabel*)[self.view viewWithTag:40];
            [heightUnitOILbl removeFromSuperview];
            UIButton *heightUnitMetresButton=(UIButton*)[self.view viewWithTag:41];
            [heightUnitMetresButton removeFromSuperview];
            UILabel *heightUnitMetresLbl=(UILabel*)[self.view viewWithTag:42];
            [heightUnitMetresLbl removeFromSuperview];
            UILabel *weight=(UILabel*)[self.view viewWithTag:19];
            weight.frame=CGRectMake(30, 210, 190, 31);
            UIButton *weightBtn=(UIButton*)[self.view viewWithTag:20];
            weightBtn.frame=CGRectMake(170, 210, 120, 30);
            UILabel *weighttextLbl=(UILabel*)[self.view viewWithTag:21];
            weighttextLbl.frame=CGRectMake(180, 210, 120, 30);
            
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 260, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 300, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 300, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 340, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 360, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 405, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 498, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 540, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 640, 260, 40);
                isMoved=YES;
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 400, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 440, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 540, 260, 40);
            }
            
        }
        else
        {
            UIButton *heightUnitButton=(UIButton*)[self.view viewWithTag:31];
            [heightUnitButton removeFromSuperview];
            UILabel *heightUnitLbl=(UILabel*)[self.view viewWithTag:32];
            [heightUnitLbl removeFromSuperview];
            UIButton *heightUnitFButton=(UIButton*)[self.view viewWithTag:35];
            [heightUnitFButton removeFromSuperview];
            UILabel *heightUnitFLbl=(UILabel*)[self.view viewWithTag:36];
            [heightUnitFLbl removeFromSuperview];
            UIButton *heightUnitIButton=(UIButton*)[self.view viewWithTag:37];
            [heightUnitIButton removeFromSuperview];
            UILabel *heightUnitILbl=(UILabel*)[self.view viewWithTag:38];
            [heightUnitILbl removeFromSuperview];
            UIButton *heightUnitOIButton=(UIButton*)[self.view viewWithTag:39];
            [heightUnitOIButton removeFromSuperview];
            UILabel *heightUnitOILbl=(UILabel*)[self.view viewWithTag:40];
            [heightUnitOILbl removeFromSuperview];
            UIButton *heightUnitMetresButton=(UIButton*)[self.view viewWithTag:41];
            [heightUnitMetresButton removeFromSuperview];
            UILabel *heightUnitMetresLbl=(UILabel*)[self.view viewWithTag:42];
            [heightUnitMetresLbl removeFromSuperview];
            UILabel *weight=(UILabel*)[self.view viewWithTag:19];
            weight.frame=CGRectMake(30, 210, 190, 31);
            UIButton *weightBtn=(UIButton*)[self.view viewWithTag:20];
            weightBtn.frame=CGRectMake(170, 210, 120, 30);
            UILabel *weighttextLbl=(UILabel*)[self.view viewWithTag:21];
            weighttextLbl.frame=CGRectMake(180, 210, 120, 30);
            
            UIButton *weightUnitBtn=(UIButton*)[self.view viewWithTag:33];
            weightUnitBtn.frame=CGRectMake(170, 260, 120, 30);
            UILabel *weightUnitLbl=(UILabel*)[self.view viewWithTag:34];
            weightUnitLbl.frame=CGRectMake(180, 260, 120, 30);
            
            UIButton *weightStoneBtn=(UIButton*)[self.view viewWithTag:43];
            weightStoneBtn.frame=CGRectMake(170, 260, 50, 30);
            UILabel *weightStoneLbl=(UILabel*)[self.view viewWithTag:44];
            weightStoneLbl.frame=CGRectMake(180, 260, 50, 30);
            UIButton *weightLbsBtn=(UIButton*)[self.view viewWithTag:45];
            weightLbsBtn.frame=CGRectMake(240, 260, 50, 30);
            UILabel *weightLbsLbl=(UILabel*)[self.view viewWithTag:46];
            weightLbsLbl.frame=CGRectMake(250, 260, 50, 30);
            UIButton *weightPoundsBtn=(UIButton*)[self.view viewWithTag:47];
            weightPoundsBtn.frame=CGRectMake(170, 260, 120, 30);
            UILabel *weightPoundsLbl=(UILabel*)[self.view viewWithTag:48];
            weightPoundsLbl.frame=CGRectMake(180, 260, 120, 30);
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 310, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 350, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 350, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 390, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 410, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 455, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 548, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 588, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 688, 260, 40);
                //isMoved=YES;
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 450, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 490, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 590, 260, 40);
            }
            
        }
        
    }

}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Height Centi Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnHeightUnitCFrom_TouchUpInside:(UIButton*)sender
{
    UILabel *heightCM=(UILabel*)[self.view viewWithTag:32];
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(heightCentiPicker!=nil)
	{
		[heightCentiPicker removeFromSuperview];
		heightCentiPicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideHeightCenti:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	heightCentiPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    heightCentiPicker.tag=24;
    heightCentiPicker.delegate=self;
    heightCentiPicker.dataSource=self;
    heightCentiPicker.showsSelectionIndicator = YES;
    heightCentiPicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	heightCentiPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:heightCentiPicker];
    NSInteger row;
    if(isGrid==YES)
    {
        
        row=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"centimetres"]indexOfObject:heightCM.text];
        [heightCentiPicker selectRow:row inComponent:0 animated:YES];
    }
	
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Button Click Event on HeightCenti
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideHeightCenti:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
	//[UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Height Feet Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnHeightUnitFFrom_TouchUpInside:(UIButton*)sender
{
    UILabel *heightF=(UILabel*)[self.view viewWithTag:36];
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(FeetPicker!=nil)
	{
		[FeetPicker removeFromSuperview];
		FeetPicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideHeightFeet:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	FeetPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    FeetPicker.tag=25;
    FeetPicker.delegate=self;
    FeetPicker.dataSource=self;
    FeetPicker.showsSelectionIndicator = YES;
    FeetPicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	FeetPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:FeetPicker];
	NSInteger row;
    if(isGrid==YES)
    {
        row=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_feet"] indexOfObject:heightF.text];
        [FeetPicker selectRow:row inComponent:0 animated:YES];
    }
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Button Click Event on Height Feet
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideHeightFeet:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
	//[UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Height Inches Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnHeightUnitIFrom_TouchUpInside:(UIButton*)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(InchPicker!=nil)
	{
		[InchPicker removeFromSuperview];
		InchPicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideHeightInch:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	InchPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    InchPicker.tag=26;
    InchPicker.delegate=self;
    InchPicker.dataSource=self;
    InchPicker.showsSelectionIndicator = YES;
    InchPicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	InchPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:InchPicker];
	UILabel *heightI=(UILabel*)[self.view viewWithTag:38];
    NSInteger row;
    if(isGrid==YES)
    {
        row=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_inches"]indexOfObject:heightI.text];
        [InchPicker selectRow:row inComponent:0 animated:YES];
    }
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Button Click Event on Height Inches
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideHeightInch:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
	//[UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Height Only Inches Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnHeightUnitOIFrom_TouchUpInside:(UIButton*)sender
{
    UILabel *heightOI=(UILabel*)[self.view viewWithTag:40];
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(OnlyInchPicker!=nil)
	{
		[OnlyInchPicker removeFromSuperview];
		OnlyInchPicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideHeightOnlyInch:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	OnlyInchPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    OnlyInchPicker.tag=27;
    OnlyInchPicker.delegate=self;
    OnlyInchPicker.dataSource=self;
    OnlyInchPicker.showsSelectionIndicator = YES;
    OnlyInchPicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	OnlyInchPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:OnlyInchPicker];
	NSInteger row;
    if(isGrid==YES)
    {
       
        row=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"inches"]indexOfObject:heightOI.text];
    }
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Button Click Event on Height Only Inches
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideHeightOnlyInch:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
	//[UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Height Metre Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnHeightUnitMetresFrom_TouchUpInside:(UIButton*)sender
{
    UILabel *heightM=(UILabel*)[self.view viewWithTag:42];
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(metrePicker!=nil)
	{
		[metrePicker removeFromSuperview];
		metrePicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideHeightMetre:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	metrePicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    metrePicker.tag=28;
    metrePicker.delegate=self;
    metrePicker.dataSource=self;
    metrePicker.showsSelectionIndicator = YES;
    metrePicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	metrePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:metrePicker];
    NSInteger row;
    if(isGrid==YES)
    {
        row=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"metres"]indexOfObject:heightM.text];
    }
	
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Button Click Event on Height Metre
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideHeightMetre:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
	//[UIView commitAnimations];
}



//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Weight Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnWeightFrom_TouchUpInside:(UIButton*)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 60) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(weightPicker!=nil)
	{
		[weightPicker removeFromSuperview];
		weightPicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideWeight:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	weightPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    weightPicker.tag=20;
    weightPicker.delegate=self;
    weightPicker.dataSource=self;
    weightPicker.showsSelectionIndicator = YES;
    weightPicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	weightPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:weightPicker];
	UILabel *weightUnit=(UILabel*)[self.view viewWithTag:21];
    NSInteger row;
    if(isGrid==YES)
    {
        row=[weightUnitArray indexOfObject:weightUnit.text];
        [weightPicker selectRow:row inComponent:0 animated:YES];
    }
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Click Event on Weight Picker
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideWeight:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
    [self weight];
    
	//[UIView commitAnimations];
}

-(void)weight
{
    UILabel *heighLbl=(UILabel*)[self.view viewWithTag:18];
    UILabel *weightLBL=(UILabel*)[self.view viewWithTag:21];
    if([weightLBL.text isEqualToString:@"Kg"])
    {
        if([heighLbl.text isEqualToString:@"Select Unit>>"])
        {
            
            UIButton *weightStoneBtn=(UIButton*)[self.view viewWithTag:43];
            [weightStoneBtn removeFromSuperview];
            UILabel *weightStoneLbl=(UILabel*)[self.view viewWithTag:44];
            [weightStoneLbl removeFromSuperview];
            UIButton *weightLbsBtn=(UIButton*)[self.view viewWithTag:45];
            [weightLbsBtn removeFromSuperview];
            UILabel *weightLbsLbl=(UILabel*)[self.view viewWithTag:46];
            [weightLbsLbl removeFromSuperview];
            UIButton *weightPoundsBtn=(UIButton*)[self.view viewWithTag:47];
            [weightPoundsBtn removeFromSuperview];
            UILabel *weightPoundsLbl=(UILabel*)[self.view viewWithTag:48];
            [weightPoundsLbl removeFromSuperview];
            UIButton *weightUnitButton=[UIButton buttonWithType:UIButtonTypeCustom];
            weightUnitButton.frame=CGRectMake(170, 260, 120, 30);
            weightUnitButton.tag=33;
            weightUnitButton.layer.cornerRadius=5;
            weightUnitButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [weightUnitButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [weightUnitButton addTarget:self action:@selector(btnWeightUnitKgFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:weightUnitButton];
            
            UILabel *weightUnitLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 260, 120, 30)];
            weightUnitLbl.tag=34;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"]isEqualToString:@""]  )
                {
                    weightUnitLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"kg"]objectAtIndex:0] intValue]];
                }
                else
                {
                    weightUnitLbl.text=[NSString stringWithFormat:@"%d",[[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"]intValue]];
                }
                
            }
            else
            {
                weightUnitLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"kg"]objectAtIndex:0] intValue]];
            }
            weightUnitLbl.backgroundColor=[UIColor clearColor];
            weightUnitLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:weightUnitLbl];
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 310, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 350, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 350, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 390, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 410, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 455, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 548, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 588, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 688, 260, 40);
                //isMoved=YES;
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 450, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 490, 260, 80);
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 590, 260, 40);
            }
            
            
        }
        
        else
        {
            UIButton *weightStoneBtn=(UIButton*)[self.view viewWithTag:43];
            [weightStoneBtn removeFromSuperview];
            UILabel *weightStoneLbl=(UILabel*)[self.view viewWithTag:44];
            [weightStoneLbl removeFromSuperview];
            UIButton *weightLbsBtn=(UIButton*)[self.view viewWithTag:45];
            [weightLbsBtn removeFromSuperview];
            UILabel *weightLbsLbl=(UILabel*)[self.view viewWithTag:46];
            [weightLbsLbl removeFromSuperview];
            UIButton *weightPoundsBtn=(UIButton*)[self.view viewWithTag:47];
            [weightPoundsBtn removeFromSuperview];
            UILabel *weightPoundsLbl=(UILabel*)[self.view viewWithTag:48];
            [weightPoundsLbl removeFromSuperview];
            UIButton *weightUnitButton=[UIButton buttonWithType:UIButtonTypeCustom];
            weightUnitButton.frame=CGRectMake(170, 310, 120, 30);
            weightUnitButton.tag=33;
            weightUnitButton.layer.cornerRadius=5;
            weightUnitButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [weightUnitButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [weightUnitButton addTarget:self action:@selector(btnWeightUnitKgFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:weightUnitButton];
            
            UILabel *weightUnitLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 310, 120, 30)];
            weightUnitLbl.tag=34;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"]isEqualToString:@""]  )
                {
                    weightUnitLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"kg"]objectAtIndex:0] intValue]];
                }
                else
                {
                    weightUnitLbl.text=[NSString stringWithFormat:@"%d",[[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"]intValue]];
                }
            }
            else
            {
                weightUnitLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"kg"]objectAtIndex:0] intValue]];
            }
            weightUnitLbl.backgroundColor=[UIColor clearColor];
            weightUnitLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:weightUnitLbl];
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 360, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 400, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 400, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 440, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 460, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 505, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 598, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 638, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 738, 260, 40);
                //isMoved=YES;
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 500, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 540, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 640, 260, 40);
            }
            
            
        }
    }
    
    else if([weightLBL.text isEqualToString:@"Stones"])
    {
        if([heighLbl.text isEqualToString:@"Select Unit>>"])
        {
            UIButton *weightKgBtn=(UIButton*)[self.view viewWithTag:33];
            [weightKgBtn removeFromSuperview];
            UILabel *weightKgLbl=(UILabel*)[self.view viewWithTag:34];
            [weightKgLbl removeFromSuperview];
            UIButton *weightPoundsBtn=(UIButton*)[self.view viewWithTag:47];
            [weightPoundsBtn removeFromSuperview];
            UILabel *weightPoundsLbl=(UILabel*)[self.view viewWithTag:48];
            [weightPoundsLbl removeFromSuperview];
            UIButton *weightUnitStonesButton=[UIButton buttonWithType:UIButtonTypeCustom];
            weightUnitStonesButton.frame=CGRectMake(170, 260, 50, 30);
            weightUnitStonesButton.tag=43;
            weightUnitStonesButton.layer.cornerRadius=5;
            weightUnitStonesButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [weightUnitStonesButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [weightUnitStonesButton addTarget:self action:@selector(btnWeightUnitStonesFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:weightUnitStonesButton];
            
            UILabel *weightUnitStonesLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 260, 50, 30)];
            weightUnitStonesLbl.tag=44;
            if(isGrid==YES)
            {
                 if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"]isEqualToString:@""]  )
                 {
                     weightUnitStonesLbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"stone"]objectAtIndex:0] ;
                 }
                else
                {
                    NSString *feetinches=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"];
                    NSString *pattern = @","; // Match a comma not followed by white space.
                    NSString *tempSeparator = @"SomeTempSeparatorString"; // You can also just use "|", as long as you are sure it is not in your input.
                    
                    // Now replace the single commas but not the ones you want to keep
                    NSString *cleanedStr = [feetinches stringByReplacingOccurrencesOfString: pattern
                                                                                 withString: tempSeparator
                                                                                    options: NSRegularExpressionSearch
                                                                                      range: NSMakeRange(0, feetinches.length)];
                    
                    // Now all that is needed is to split the string
                    NSArray *result = [cleanedStr componentsSeparatedByString: tempSeparator];
                    weightUnitStonesLbl.text=[result objectAtIndex:0];
                }
               
            }
            else
            {
                weightUnitStonesLbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"stone"]objectAtIndex:0] ;
            }
            weightUnitStonesLbl.backgroundColor=[UIColor clearColor];
            weightUnitStonesLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:weightUnitStonesLbl];
            
            UIButton *weightUnitLbsButton=[UIButton buttonWithType:UIButtonTypeCustom];
            weightUnitLbsButton.frame=CGRectMake(240, 260, 50, 30);
            weightUnitLbsButton.tag=45;
            weightUnitLbsButton.layer.cornerRadius=5;
            weightUnitLbsButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [weightUnitLbsButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [weightUnitLbsButton addTarget:self action:@selector(btnWeightUnitLbsFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:weightUnitLbsButton];
            
            UILabel *weightUnitLbsLbl=[[UILabel alloc]initWithFrame:CGRectMake(250, 260, 50, 30)];
            weightUnitLbsLbl.tag=46;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"]isEqualToString:@""]  )
                {
                    weightUnitLbsLbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbsstone"]objectAtIndex:0] ;
                }
                else
                {
                    NSString *feetinches=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"];
                    NSString *pattern = @","; // Match a comma not followed by white space.
                    NSString *tempSeparator = @"SomeTempSeparatorString"; // You can also just use "|", as long as you are sure it is not in your input.
                    
                    // Now replace the single commas but not the ones you want to keep
                    NSString *cleanedStr = [feetinches stringByReplacingOccurrencesOfString: pattern
                                                                                 withString: tempSeparator
                                                                                    options: NSRegularExpressionSearch
                                                                                      range: NSMakeRange(0, feetinches.length)];
                    
                    // Now all that is needed is to split the string
                    NSArray *result = [cleanedStr componentsSeparatedByString: tempSeparator];
                    weightUnitLbsLbl.text=[result objectAtIndex:1];

                }
            }
            else
            {
                weightUnitLbsLbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbsstone"]objectAtIndex:0] ;
            }
            weightUnitLbsLbl.backgroundColor=[UIColor clearColor];
            weightUnitLbsLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:weightUnitLbsLbl];
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 310, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 350, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 350, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 390, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 410, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 455, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 548, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 588, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 688, 260, 40);
                //isMoved=YES;
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 450, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 490, 260, 80);
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 590, 260, 40);
            }
            
            
        }
        
        else
        {
            UIButton *weightKgBtn=(UIButton*)[self.view viewWithTag:33];
            [weightKgBtn removeFromSuperview];
            UILabel *weightKgLbl=(UILabel*)[self.view viewWithTag:34];
            [weightKgLbl removeFromSuperview];
            UIButton *weightPoundsBtn=(UIButton*)[self.view viewWithTag:47];
            [weightPoundsBtn removeFromSuperview];
            UILabel *weightPoundsLbl=(UILabel*)[self.view viewWithTag:48];
            [weightPoundsLbl removeFromSuperview];
            UIButton *weightUnitStonesButton=[UIButton buttonWithType:UIButtonTypeCustom];
            weightUnitStonesButton.frame=CGRectMake(170, 310, 50, 30);
            weightUnitStonesButton.tag=43;
            weightUnitStonesButton.layer.cornerRadius=5;
            weightUnitStonesButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [weightUnitStonesButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [weightUnitStonesButton addTarget:self action:@selector(btnWeightUnitStonesFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:weightUnitStonesButton];
            
            UILabel *weightUnitStonesLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 310, 50, 30)];
            weightUnitStonesLbl.tag=44;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"]isEqualToString:@""]  )
                {
                    weightUnitStonesLbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"stone"]objectAtIndex:0] ;
                }
                else
                {
                    NSString *feetinches=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"];
                    NSString *pattern = @","; // Match a comma not followed by white space.
                    NSString *tempSeparator = @"SomeTempSeparatorString"; // You can also just use "|", as long as you are sure it is not in your input.
                    
                    // Now replace the single commas but not the ones you want to keep
                    NSString *cleanedStr = [feetinches stringByReplacingOccurrencesOfString: pattern
                                                                                 withString: tempSeparator
                                                                                    options: NSRegularExpressionSearch
                                                                                      range: NSMakeRange(0, feetinches.length)];
                    
                    // Now all that is needed is to split the string
                    NSArray *result = [cleanedStr componentsSeparatedByString: tempSeparator];
                    weightUnitStonesLbl.text=[result objectAtIndex:0];
                }
               
            }
            else
            {
                weightUnitStonesLbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"stone"]objectAtIndex:0] ;
            }
            weightUnitStonesLbl.backgroundColor=[UIColor clearColor];
            weightUnitStonesLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:weightUnitStonesLbl];
            
            UIButton *weightUnitLbsButton=[UIButton buttonWithType:UIButtonTypeCustom];
            weightUnitLbsButton.frame=CGRectMake(240, 310, 50, 30);
            weightUnitLbsButton.tag=45;
            weightUnitLbsButton.layer.cornerRadius=5;
            weightUnitLbsButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [weightUnitLbsButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [weightUnitLbsButton addTarget:self action:@selector(btnWeightUnitLbsFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:weightUnitLbsButton];
            
            UILabel *weightUnitLbsLbl=[[UILabel alloc]initWithFrame:CGRectMake(250, 310, 50, 30)];
            weightUnitLbsLbl.tag=46;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"]isEqualToString:@""]  )
                {
                    weightUnitLbsLbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbsstone"]objectAtIndex:0] ;
                }
                else
                {
                    NSString *feetinches=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"];
                    NSString *pattern = @","; // Match a comma not followed by white space.
                    NSString *tempSeparator = @"SomeTempSeparatorString"; // You can also just use "|", as long as you are sure it is not in your input.
                    
                    // Now replace the single commas but not the ones you want to keep
                    NSString *cleanedStr = [feetinches stringByReplacingOccurrencesOfString: pattern
                                                                                 withString: tempSeparator
                                                                                    options: NSRegularExpressionSearch
                                                                                      range: NSMakeRange(0, feetinches.length)];
                    
                    // Now all that is needed is to split the string
                    NSArray *result = [cleanedStr componentsSeparatedByString: tempSeparator];
                    weightUnitLbsLbl.text=[result objectAtIndex:1];
                }
                
            }
            else
            {
                weightUnitLbsLbl.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbsstone"]objectAtIndex:0] ;
            }
            weightUnitLbsLbl.backgroundColor=[UIColor clearColor];
            weightUnitLbsLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:weightUnitLbsLbl];
            
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 360, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 400, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 400, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 440, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 460, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 505, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 598, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 638, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 738, 260, 40);
                //isMoved=YES;
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 500, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 540, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 640, 260, 40);
            }
            
            
        }
    }
    
    if([weightLBL.text isEqualToString:@"Pounds"])
    {
        if([heighLbl.text isEqualToString:@"Select Unit>>"])
        {
            UIButton *weightStoneBtn=(UIButton*)[self.view viewWithTag:43];
            [weightStoneBtn removeFromSuperview];
            UILabel *weightStoneLbl=(UILabel*)[self.view viewWithTag:44];
            [weightStoneLbl removeFromSuperview];
            UIButton *weightLbsBtn=(UIButton*)[self.view viewWithTag:45];
            [weightLbsBtn removeFromSuperview];
            UILabel *weightLbsLbl=(UILabel*)[self.view viewWithTag:46];
            [weightLbsLbl removeFromSuperview];
            UIButton *weightKgBtn=(UIButton*)[self.view viewWithTag:33];
            [weightKgBtn removeFromSuperview];
            UILabel *weightKgLbl=(UILabel*)[self.view viewWithTag:34];
            [weightKgLbl removeFromSuperview];
            UIButton *weightUnitPoundsButton=[UIButton buttonWithType:UIButtonTypeCustom];
            weightUnitPoundsButton.frame=CGRectMake(170, 260, 120, 30);
            weightUnitPoundsButton.tag=47;
            weightUnitPoundsButton.layer.cornerRadius=5;
            weightUnitPoundsButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [weightUnitPoundsButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [weightUnitPoundsButton addTarget:self action:@selector(btnWeightUnitPoundFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:weightUnitPoundsButton];
            
            UILabel *weightUnitPoundsLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 260, 120, 30)];
            weightUnitPoundsLbl.tag=48;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"]isEqualToString:@""]  )
                {
                    weightUnitPoundsLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbs"]objectAtIndex:0] intValue]];
                }
                else
                {
                    weightUnitPoundsLbl.text=[NSString stringWithFormat:@"%d",[[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"]intValue]];
                }
                
            }
            else
            {
                weightUnitPoundsLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbs"]objectAtIndex:0] intValue]];
            }
            weightUnitPoundsLbl.backgroundColor=[UIColor clearColor];
            weightUnitPoundsLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:weightUnitPoundsLbl];
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 310, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 350, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 350, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 390, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 410, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 455, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 548, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 588, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 688, 260, 40);
                //isMoved=YES;
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 450, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 490, 260, 80);
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 590, 260, 40);
            }
            
            
        }
        
        else
        {
            UIButton *weightStoneBtn=(UIButton*)[self.view viewWithTag:43];
            [weightStoneBtn removeFromSuperview];
            UILabel *weightStoneLbl=(UILabel*)[self.view viewWithTag:44];
            [weightStoneLbl removeFromSuperview];
            UIButton *weightLbsBtn=(UIButton*)[self.view viewWithTag:45];
            [weightLbsBtn removeFromSuperview];
            UILabel *weightLbsLbl=(UILabel*)[self.view viewWithTag:46];
            [weightLbsLbl removeFromSuperview];
            UIButton *weightKgBtn=(UIButton*)[self.view viewWithTag:33];
            [weightKgBtn removeFromSuperview];
            UILabel *weightKgLbl=(UILabel*)[self.view viewWithTag:34];
            [weightKgLbl removeFromSuperview];
            UIButton *weightUnitPoundsButton=[UIButton buttonWithType:UIButtonTypeCustom];
            weightUnitPoundsButton.frame=CGRectMake(170, 310, 120, 30);
            weightUnitPoundsButton.tag=47;
            weightUnitPoundsButton.layer.cornerRadius=5;
            weightUnitPoundsButton.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
            [weightUnitPoundsButton setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [weightUnitPoundsButton addTarget:self action:@selector(btnWeightUnitPoundFrom_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:weightUnitPoundsButton];
            
            UILabel *weightUnitPoundsLbl=[[UILabel alloc]initWithFrame:CGRectMake(180, 310, 120, 30)];
            weightUnitPoundsLbl.tag=48;
            if(isGrid==YES)
            {
                if ( [[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"]isEqualToString:@""]  )
                {
                    weightUnitPoundsLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbs"]objectAtIndex:0] intValue]];
                }
                else
                {
                    weightUnitPoundsLbl.text=[NSString stringWithFormat:@"%d",[[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"weight"]intValue]];
                }
                
            }
            else
            {
                weightUnitPoundsLbl.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbs"]objectAtIndex:0] intValue]];
            }
            weightUnitPoundsLbl.backgroundColor=[UIColor clearColor];
            weightUnitPoundsLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
            [scrollview addSubview:weightUnitPoundsLbl];
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 350, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 390, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 390, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 440, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 460, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 505, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 598, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 638, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 738, 260, 40);
                //isMoved=YES;
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 500, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 540, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 640, 260, 40);
            }
            
            
        }
    }
    
    
    
    else if([weightLBL.text isEqualToString:@"Select Unit>>"])
    {
        if([heighLbl.text isEqualToString:@"Select Unit>>"])
        {
            UIButton *weightUnitButton=(UIButton*)[self.view viewWithTag:33];
            [weightUnitButton removeFromSuperview];
            UILabel *weightUnitLbl=(UILabel*)[self.view viewWithTag:34];
            [weightUnitLbl removeFromSuperview];
            UIButton *weightStoneBtn=(UIButton*)[self.view viewWithTag:43];
            [weightStoneBtn removeFromSuperview];
            UILabel *weightStoneLbl=(UILabel*)[self.view viewWithTag:44];
            [weightStoneLbl removeFromSuperview];
            UIButton *weightLbsBtn=(UIButton*)[self.view viewWithTag:45];
            [weightLbsBtn removeFromSuperview];
            UILabel *weightLbsLbl=(UILabel*)[self.view viewWithTag:46];
            [weightLbsLbl removeFromSuperview];
            UIButton *weightPoundsBtn=(UIButton*)[self.view viewWithTag:47];
            [weightPoundsBtn removeFromSuperview];
            UILabel *weightPoundsLbl=(UILabel*)[self.view viewWithTag:48];
            [weightPoundsLbl removeFromSuperview];
            
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 260, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 300, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 300, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 340, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 360, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 405, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 498, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 538, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 638, 260, 40);
                isMoved=YES;
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 400, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 440, 260, 80);
                
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 540, 260, 40);
            }
            
            
        }
        else
        {
            
            UIButton *weightUnitButton=(UIButton*)[self.view viewWithTag:33];
            [weightUnitButton removeFromSuperview];
            UILabel *weightUnitLbl=(UILabel*)[self.view viewWithTag:34];
            [weightUnitLbl removeFromSuperview];
            UIButton *weightStoneBtn=(UIButton*)[self.view viewWithTag:43];
            [weightStoneBtn removeFromSuperview];
            UILabel *weightStoneLbl=(UILabel*)[self.view viewWithTag:44];
            [weightStoneLbl removeFromSuperview];
            UIButton *weightLbsBtn=(UIButton*)[self.view viewWithTag:45];
            [weightLbsBtn removeFromSuperview];
            UILabel *weightLbsLbl=(UILabel*)[self.view viewWithTag:46];
            [weightLbsLbl removeFromSuperview];
            UIButton *weightPoundsBtn=(UIButton*)[self.view viewWithTag:47];
            [weightPoundsBtn removeFromSuperview];
            UILabel *weightPoundsLbl=(UILabel*)[self.view viewWithTag:48];
            [weightPoundsLbl removeFromSuperview];
            
            UILabel *BP=(UILabel*)[self.view viewWithTag:22];
            BP.frame=CGRectMake(30, 310, 190, 31);
            UIButton *BPBtn=(UIButton*)[self.view viewWithTag:23];
            BPBtn.frame=CGRectMake(30, 350, 260, 30);
            UILabel *BPtextLbl=(UILabel*)[self.view viewWithTag:24];
            BPtextLbl.frame=CGRectMake(35, 350, 260, 30);
            
            UILabel *currentMDLbl=(UILabel*)[self.view viewWithTag:25];
            currentMDLbl.frame=CGRectMake(30, 390, 190, 61);
            UIButton *butCheck=(UIButton*)[self.view viewWithTag:26];
            butCheck.frame=CGRectMake(180, 410, 32, 27);
            
            if(isMoved==YES)
            {
                UITextView *medTextView=(UITextView*)[self.view viewWithTag:27];
                medTextView.frame=CGRectMake(30, 455, 260, 80);
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 548, 190, 31);
                UITextView *SubTextView=(UITextView*)[self.view viewWithTag:29];
                SubTextView.frame=CGRectMake(30, 688, 260, 80);
                UIButton *subBtn=(UIButton*)[self.view viewWithTag:30];
                subBtn.frame=CGRectMake(30, 788, 260, 40);
                isMoved=YES;
            }
            else
            {
                UILabel *subLbl=(UILabel*)[self.view viewWithTag:28];
                subLbl.frame=CGRectMake(30, 450, 190, 31);
                UITextView *subTextView=(UITextView*)[self.view viewWithTag:29];
                subTextView.frame=CGRectMake(30, 490, 260, 80);
                UIButton *submitBtn=(UIButton*)[self.view viewWithTag:30];
                submitBtn.frame=CGRectMake(30, 590, 260, 40);
            }
            
            
        }
    }

}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Weight Kg Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnWeightUnitKgFrom_TouchUpInside:(UIButton*)sender
{
    UILabel *weightKg=(UILabel*)[self.view viewWithTag:34];
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 160) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(KGPicker!=nil)
	{
		[KGPicker removeFromSuperview];
		KGPicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideWeightKg:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	KGPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    KGPicker.tag=29;
    KGPicker.delegate=self;
    KGPicker.dataSource=self;
    KGPicker.showsSelectionIndicator = YES;
    KGPicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	KGPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:KGPicker];
	NSInteger row;
    if(isGrid==YES)
    {
        
        
        row= [[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"kg"] indexOfObject:weightKg.text];
        //[KGPicker selectRow:row inComponent:0 animated:YES];
    }
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Click Event on Weight Picker
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideWeightKg:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
	//[UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Weight Stone Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnWeightUnitStonesFrom_TouchUpInside:(UIButton*)sender
{
    UILabel *weightStone=(UILabel*)[self.view viewWithTag:44];
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 160) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(stonePicker!=nil)
	{
		[stonePicker removeFromSuperview];
		stonePicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideWeightStone:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	stonePicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    stonePicker.tag=30;
    stonePicker.delegate=self;
    stonePicker.dataSource=self;
    stonePicker.showsSelectionIndicator = YES;
    stonePicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	stonePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:stonePicker];
	NSInteger row;
    if(isGrid==YES)
    {
        row= [[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"stone"]indexOfObject:weightStone.text];
        [stonePicker selectRow:row inComponent:0 animated:YES];
    }
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Click Event on Weight Stone Picker
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideWeightStone:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
	//[UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Weight LBS Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnWeightUnitLbsFrom_TouchUpInside:(UIButton*)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 160) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(LbsPicker!=nil)
	{
		[LbsPicker removeFromSuperview];
		LbsPicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideWeightLbs:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	LbsPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    LbsPicker.tag=31;
    LbsPicker.delegate=self;
    LbsPicker.dataSource=self;
    LbsPicker.showsSelectionIndicator = YES;
    LbsPicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	LbsPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:LbsPicker];
	NSInteger row;
    if(isGrid==YES)
    {
        UILabel *weightlbs=(UILabel*)[self.view viewWithTag:46];
        row= [[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbsstone"]indexOfObject:weightlbs.text];
        [LbsPicker selectRow:row inComponent:0 animated:YES];
    }
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Click Event on Weight Stone Picker
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideWeightLbs:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
	//[UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Weight Pound Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnWeightUnitPoundFrom_TouchUpInside:(UIButton*)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 160) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(poundPicker!=nil)
	{
		[poundPicker removeFromSuperview];
		poundPicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideWeightPound:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	poundPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    poundPicker.tag=32;
    poundPicker.delegate=self;
    poundPicker.dataSource=self;
    poundPicker.showsSelectionIndicator = YES;
    poundPicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	poundPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:poundPicker];
	NSInteger row;
    if(isGrid==YES)
    {
        UILabel *weightPounds=(UILabel*)[self.view viewWithTag:48];
        row=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbs"]indexOfObject:weightPounds.text];
        [poundPicker selectRow:row inComponent:0 animated:YES];
    }
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Click Event on Weight Stone Picker
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideWeightPound:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
	//[UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - BP Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)btnBPFrom_TouchUpInside:(UIButton*)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 130) animated:YES];
    [customPickerView removeFromSuperview];
    customPickerView.center =CGPointMake(160,600);
	
	if(BPPicker!=nil)
	{
		[BPPicker removeFromSuperview];
		BPPicker=nil;
	}
	
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,300)];
	customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInsideBP:)] ;
	UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	toolBar.items = [[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] ;
	[customPickerView addSubview:toolBar];
	
    
    //Adding picker view
	BPPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
    BPPicker.tag=23;
    BPPicker.delegate=self;
    BPPicker.dataSource=self;
    BPPicker.showsSelectionIndicator = YES;
    BPPicker.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
	BPPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[customPickerView addSubview:BPPicker];
	
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,400);
	//[UIView commitAnimations];
	[self.view bringSubviewToFront:customPickerView];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Done Click Event on Weight Picker
/////////////////////////////////////////////////////////////////////////////////

-(void)barButtonDone_onTouchUpInsideBP:(UIButton *)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,750);
    [customPickerView removeFromSuperview];
	//[UIView commitAnimations];
}



//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Picker View Data Source
/////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    int s;
    if(thePickerView.tag==8)
    {
        s= [genderArray count];
    }
    if(thePickerView.tag==17)
    {
        s= [heightUnitArray count];
    }
    
    if(thePickerView.tag==20)
    {
        s=[weightUnitArray count];
    }
    
    if(thePickerView.tag==23)
    {
        s=[BPArray count];
    }
    
    if(thePickerView.tag==24)
    {
        
        s=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"centimetres"]count];
        //NSLog(@"count is %d",s);
    }
    
    if(thePickerView.tag==25)
    {
        
        s=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_feet"]count];
        //NSLog(@"count is %d",s);
    }
    
    if(thePickerView.tag==26)
    {
        
        s=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_inches"]count];
        //NSLog(@"count is %d",s);
    }
    
    if(thePickerView.tag==27)
    {
        
        s=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"inches"]count];
        //NSLog(@"count is %d",s);
    }
    
    if(thePickerView.tag==28)
    {
        
        s=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"metres"]count];
        //NSLog(@"count is %d",s);
    }
    
    if(thePickerView.tag==29)
    {
        
        s=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"kg"]count];
        //NSLog(@"count is %d",s);
    }
    
    if(thePickerView.tag==30)
    {
        
        s=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"stone"]count];
        //NSLog(@"count is %d",s);
    }
    
    if(thePickerView.tag==31)
    {
        
        s=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbsstone"]count];
        //NSLog(@"count is %d",s);
    }
    
    if(thePickerView.tag==32)
    {
        
        s=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbs"]count];
        //NSLog(@"count is %d",s);
    }
    
   
    
    return s;
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Picker View Delegate
/////////////////////////////////////////////////////////////////////////////////

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strResult;
    if(thePickerView.tag==8)
    {
    strResult = [genderArray objectAtIndex:row];
    }
    if(thePickerView.tag==17)
    {
        strResult=[heightUnitArray objectAtIndex:row];
    }
    if(thePickerView.tag==20)
    {
        strResult=[weightUnitArray objectAtIndex:row];
    }
    if(thePickerView.tag==23)
    {
        strResult=[BPArray objectAtIndex:row];
    }
    
    if(thePickerView.tag==24)
    {
        strResult=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"centimetres"]objectAtIndex:row] intValue]];
    }
    
    if(thePickerView.tag==25)
    {
        strResult=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_feet"]objectAtIndex:row];
    }
    
    if(thePickerView.tag==26)
    {
        strResult=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_inches"]objectAtIndex:row];
    }
    
    if(thePickerView.tag==27)
    {
        strResult=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"inches"]objectAtIndex:row] intValue]];
    }
    
    if(thePickerView.tag==28)
    {
        strResult=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"metres"]objectAtIndex:row] intValue]];
    }
    
    if(thePickerView.tag==29)
    {
        strResult=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"kg"]objectAtIndex:row] intValue]];
    }
    
    if(thePickerView.tag==30)
    {
        strResult=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"stone"]objectAtIndex:row] ;
    }
    
    if(thePickerView.tag==31)
    {
        strResult=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbsstone"]objectAtIndex:row] ;
    }
    
    if(thePickerView.tag==32)
    {
        strResult=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbs"]objectAtIndex:row] intValue]];
    }

   
    return strResult;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *lblGender=(UILabel*)[self.view viewWithTag:9];
    UILabel *height=(UILabel*)[self.view viewWithTag:18];
    UILabel *weight=(UILabel*)[self.view viewWithTag:21];
    UILabel *blood=(UILabel*)[self.view viewWithTag:24];
    UILabel *heightCM=(UILabel*)[self.view viewWithTag:32];
    UILabel *heightF=(UILabel*)[self.view viewWithTag:36];
    UILabel *heightI=(UILabel*)[self.view viewWithTag:38];
    UILabel *heightOI=(UILabel*)[self.view viewWithTag:40];
    UILabel *heightMetres=(UILabel*)[self.view viewWithTag:42];
    UILabel *weightkg=(UILabel*)[self.view viewWithTag:34];
    UILabel *weightStone=(UILabel*)[self.view viewWithTag:44];
    UILabel *weightLbs=(UILabel*)[self.view viewWithTag:46];
    UILabel *weightPound=(UILabel*)[self.view viewWithTag:48];
    NSString *resultString;
    if(thePickerView.tag==8)
    {
     resultString= [genderArray objectAtIndex:row];
    
      lblGender.text = resultString;
    }
    if(thePickerView.tag==17)
    {
        resultString= [heightUnitArray objectAtIndex:row];
        height.text=resultString;
    }
    
    if(thePickerView.tag==20)
    {
        resultString= [weightUnitArray objectAtIndex:row];
        weight.text=resultString;
    }
    if(thePickerView.tag==23)
    {
        resultString= [BPArray objectAtIndex:row];
        blood.text=resultString;
    }
    if(thePickerView.tag==24)
    {
        resultString= [NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"centimetres"]objectAtIndex:row] intValue]];
        heightCM.text=resultString;
    }
    
    if(thePickerView.tag==25)
    {
        resultString= [[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_feet"]objectAtIndex:row];
        heightF.text=resultString;
    }
    
    if(thePickerView.tag==26)
    {
        resultString= [[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_inches"]objectAtIndex:row];
        heightI.text=resultString;
    }
    
    if(thePickerView.tag==27)
    {
        resultString= [NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"inches"]objectAtIndex:row] intValue]];
        heightOI.text=resultString;
    }
    
    if(thePickerView.tag==28)
    {
        resultString= [NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"metres"]objectAtIndex:row] intValue]];
        heightMetres.text=resultString;
    }
    
    if(thePickerView.tag==29)
    {
        resultString= [NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"kg"]objectAtIndex:row] intValue]];
        weightkg.text=resultString;
    }
    
    if(thePickerView.tag==30)
    {
        resultString= [[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"stone"]objectAtIndex:row];
        weightStone.text=resultString;
    }
    
    if(thePickerView.tag==31)
    {
        resultString= [[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbsstone"]objectAtIndex:row];
        weightLbs.text=resultString;
    }
    
    if(thePickerView.tag==32)
    {
        resultString= [NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbs"]objectAtIndex:row] intValue]];
        weightPound.text=resultString;
    }
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if(pickerView.tag==23)
    {
    
        CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
        tView = [[UILabel alloc] initWithFrame:frame] ;
       // [tView setTextAlignment:NSTextAlignmentCenter];
        tView.text=[BPArray objectAtIndex:row];
        [tView setBackgroundColor:[UIColor clearColor]];
        [tView setFont:[UIFont boldSystemFontOfSize:16]];
    
    }
        if(pickerView.tag==8)
        {
            
                CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
                tView = [[UILabel alloc] initWithFrame:frame] ;
                //[tView setTextAlignment:NSTextAlignmentCenter];
                tView.text=[genderArray objectAtIndex:row];
                [tView setBackgroundColor:[UIColor clearColor]];
                [tView setFont:[UIFont boldSystemFontOfSize:16]];
            
        }
    
    if(pickerView.tag==17)
    {
        
            CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
            tView = [[UILabel alloc] initWithFrame:frame] ;
            //[tView setTextAlignment:NSTextAlignmentCenter];
            tView.text=[heightUnitArray objectAtIndex:row];
            [tView setBackgroundColor:[UIColor clearColor]];
            [tView setFont:[UIFont boldSystemFontOfSize:16]];
        
    }
    
    if(pickerView.tag==20)
    {
        
            CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
            tView = [[UILabel alloc] initWithFrame:frame] ;
            //[tView setTextAlignment:NSTextAlignmentCenter];
            tView.text=[weightUnitArray objectAtIndex:row];
            [tView setBackgroundColor:[UIColor clearColor]];
            [tView setFont:[UIFont boldSystemFontOfSize:16]];
        
    }
    
    if(pickerView.tag==24)
    {
        
            CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
            tView = [[UILabel alloc] initWithFrame:frame] ;
            //[tView setTextAlignment:NSTextAlignmentCenter];
        
            tView.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"centimetres"]objectAtIndex:row] intValue]];
            [tView setBackgroundColor:[UIColor clearColor]];
            [tView setFont:[UIFont boldSystemFontOfSize:16]];
        
        
        
    }
    
    if(pickerView.tag==25)
    {
        
        CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
        tView = [[UILabel alloc] initWithFrame:frame] ;
        //[tView setTextAlignment:NSTextAlignmentCenter];
        tView.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_feet"]objectAtIndex:row];
        [tView setBackgroundColor:[UIColor clearColor]];
        [tView setFont:[UIFont boldSystemFontOfSize:16]];
        
    }
    
    if(pickerView.tag==26)
    {
        
        CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
        tView = [[UILabel alloc] initWithFrame:frame] ;
        //[tView setTextAlignment:NSTextAlignmentCenter];
        tView.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"feet&inches_inches"]objectAtIndex:row];
        [tView setBackgroundColor:[UIColor clearColor]];
        [tView setFont:[UIFont boldSystemFontOfSize:16]];
        
    }
    
    if(pickerView.tag==27)
    {
        
        CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
        tView = [[UILabel alloc] initWithFrame:frame] ;
        //[tView setTextAlignment:NSTextAlignmentCenter];
        tView.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"inches"]objectAtIndex:row] intValue]];
        [tView setBackgroundColor:[UIColor clearColor]];
        [tView setFont:[UIFont boldSystemFontOfSize:16]];
        
    }
    
    if(pickerView.tag==28)
    {
        
        CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
        tView = [[UILabel alloc] initWithFrame:frame] ;
        //[tView setTextAlignment:NSTextAlignmentCenter];
        tView.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"height_details"]valueForKey:@"metres"]objectAtIndex:row] intValue]];
        [tView setBackgroundColor:[UIColor clearColor]];
        [tView setFont:[UIFont boldSystemFontOfSize:16]];
        
    }
    
    if(pickerView.tag==29)
    {
        CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
        tView = [[UILabel alloc] initWithFrame:frame] ;
        //[tView setTextAlignment:NSTextAlignmentCenter];
        tView.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"kg"]objectAtIndex:row] intValue]];
        [tView setBackgroundColor:[UIColor clearColor]];
        [tView setFont:[UIFont boldSystemFontOfSize:16]];
            }
    
    if(pickerView.tag==30)
    {
        CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
        tView = [[UILabel alloc] initWithFrame:frame] ;
        //[tView setTextAlignment:NSTextAlignmentCenter];
        tView.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"stone"]objectAtIndex:row] ;
        [tView setBackgroundColor:[UIColor clearColor]];
        [tView setFont:[UIFont boldSystemFontOfSize:16]];
        
        
    }
    
    if(pickerView.tag==31)
    {
        CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
        tView = [[UILabel alloc] initWithFrame:frame] ;
        //[tView setTextAlignment:NSTextAlignmentCenter];
        tView.text=[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbsstone"]objectAtIndex:row] ;
        [tView setBackgroundColor:[UIColor clearColor]];
        [tView setFont:[UIFont boldSystemFontOfSize:16]];

        
    }
    
    if(pickerView.tag==32)
    {
        
        CGRect frame = CGRectMake(10.0, 0.0, 290, 32);
        tView = [[UILabel alloc] initWithFrame:frame] ;
        //[tView setTextAlignment:NSTextAlignmentCenter];
        tView.text=[NSString stringWithFormat:@"%d",[[[[[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]valueForKey:@"weight_details"]valueForKey:@"lbs"]objectAtIndex:row] intValue]];
        [tView setBackgroundColor:[UIColor clearColor]];
        [tView setFont:[UIFont boldSystemFontOfSize:16]];
        
    }

    
    
    return tView;
}


////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Submit Button Click Event (For New Registration , Profile and Update Profile)
////////////////////////////////////////////////////////////////////////////////////////////////

-(void)save
{
    if(isProfile==YES)
    {
        UILabel *gen=(UILabel*)[self.view viewWithTag:9];
        gender=gen.text;
        UILabel *date=(UILabel*)[self.view viewWithTag:12];
        dob=date.text;
        UITextField *phoneTxtFld=(UITextField*)[self.view viewWithTag:15];
        phone=phoneTxtFld.text;
        UILabel *hu=(UILabel*)[self.view viewWithTag:18];
        heightunit=hu.text;
        UILabel *wu=(UILabel*)[self.view viewWithTag:21];
        weightunit=wu.text;
        UILabel *bp=(UILabel*)[self.view viewWithTag:24];
        BPvalue=bp.text;
        
        
        if(isMoved==YES)
        {
            UITextView *medTxtView=(UITextView*)[self.view viewWithTag:27];
            currentmedication=medTxtView.text;
        }
        UITextView *subtodis=(UITextView*)[self.view viewWithTag:29];
        subtodicuss=subtodis.text;
        
        
        if(gender.length==0 || dob.length==0 || phone.length==0 || [heightunit isEqualToString:@"Select Unit>>"] || [weightunit isEqualToString:@"Select Unit>>"] || BPvalue.length==0)
        {
            if(isMoved==YES)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"All fields are mandatory." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
                return;
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"All fields are mandatory." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
                return;
            }
            
        }
        
        
        else
        {
            if(isGrid==YES)
            {

                if([heightunit isEqualToString:@"Feet & Inches"])
                {
                    UILabel *feet=(UILabel*)[self.view viewWithTag:36];
                    UILabel *inches=(UILabel*)[self.view viewWithTag:38];
                    heightvalue=[NSString stringWithFormat:@"%@,%@",feet.text,inches.text];
                }
                
                if([heightunit isEqualToString:@"Centimetres"])
                {
                    UILabel *centi=(UILabel*)[self.view viewWithTag:32];
                    heightvalue=centi.text;
                }
                
                if([heightunit isEqualToString:@"Inches"])
                {
                    UILabel *Onlyinches=(UILabel*)[self.view viewWithTag:40];
                    heightvalue=Onlyinches.text;
                }
                if([heightunit isEqualToString:@"Metres"])
                {
                    UILabel *metres=(UILabel*)[self.view viewWithTag:42];
                    heightvalue=metres.text;
                }
                
                if([weightunit isEqualToString:@"Stones"])
                {
                    UILabel *stones=(UILabel*)[self.view viewWithTag:44];
                    UILabel *lbs=(UILabel*)[self.view viewWithTag:46];
                    weightvalue=[NSString stringWithFormat:@"%@,%@",stones.text,lbs.text];
                    
                }
                
                if([weightunit isEqualToString:@"Kg"])
                {
                    UILabel *kg=(UILabel*)[self.view viewWithTag:34];
                    weightvalue=kg.text;
                    
                }
                
                if([weightunit isEqualToString:@"Pounds"])
                {
                    UILabel *pounds=(UILabel*)[self.view viewWithTag:48];
                    weightvalue=pounds.text;
                    
                }
                
                [txtActiveField resignFirstResponder];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd-MM-yyyy"];
                NSDate *tD=[NSDate date];
                NSDate *birthDate=[df dateFromString:dob];
                NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                   components:NSYearCalendarUnit
                                                   fromDate:birthDate
                                                   toDate:tD
                                                   options:0];
                NSInteger age = [ageComponents year];
                if(age<18)
                {
                    UIAlertView *dateAlert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"You must be over 18 to use this service." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [dateAlert show];
                }
                else
                {
                    
                    
                    [self internetCheck];
                }

                
            }
            else
            {
                if([heightunit isEqualToString:@"Feet & Inches"])
                {
                    UILabel *feet=(UILabel*)[self.view viewWithTag:36];
                    UILabel *inches=(UILabel*)[self.view viewWithTag:38];
                    heightvalue=[NSString stringWithFormat:@"%@,%@",feet.text,inches.text];
                }
                
                if([heightunit isEqualToString:@"Centimetres"])
                {
                    UILabel *centi=(UILabel*)[self.view viewWithTag:32];
                    heightvalue=centi.text;
                }
                
                if([heightunit isEqualToString:@"Inches"])
                {
                    UILabel *Onlyinches=(UILabel*)[self.view viewWithTag:40];
                    heightvalue=Onlyinches.text;
                }
                if([heightunit isEqualToString:@"Metres"])
                {
                    UILabel *metres=(UILabel*)[self.view viewWithTag:42];
                    heightvalue=metres.text;
                }
                
                if([weightunit isEqualToString:@"Stones"])
                {
                    UILabel *stones=(UILabel*)[self.view viewWithTag:44];
                    UILabel *lbs=(UILabel*)[self.view viewWithTag:46];
                    weightvalue=[NSString stringWithFormat:@"%@,%@",stones.text,lbs.text];
                    
                }
                
                if([weightunit isEqualToString:@"Kg"])
                {
                    UILabel *kg=(UILabel*)[self.view viewWithTag:34];
                    weightvalue=kg.text;
                    
                }
                
                if([weightunit isEqualToString:@"Pounds"])
                {
                    UILabel *pounds=(UILabel*)[self.view viewWithTag:48];
                    weightvalue=pounds.text;
                    
                }
                
                [txtActiveField resignFirstResponder];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd-MM-yyyy"];
                NSDate *tD=[NSDate date];
                NSDate *birthDate=[df dateFromString:dob];
                NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                   components:NSYearCalendarUnit
                                                   fromDate:birthDate
                                                   toDate:tD
                                                   options:0];
                NSInteger age = [ageComponents year];
                if(age<18)
                {
                    UIAlertView *dateAlert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"You must be over 18 to use this service." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [dateAlert show];
                }
                else
                {
                    
                    
                    [self internetCheck];
                }
                
            }
            //
            
            //RegistrationViewController.loginView=self;
        }
    }
    else
    {
        fName = [[FNTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        lName = [[LNTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        username = [[emailTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        password = [[passwordTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        conPassword=[[conPasswordTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ( fName.length == 0 )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter your first name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             
             [alert show];

            return;
        }
        
        
        if ( lName.length == 0 )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter your last name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
            return;
        }
        
        if ( username.length == 0 )
        {
            UIAlertView *alertUser=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter your email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertUser show];
            return;
        }
        
        if ( password.length == 0 )
        {
            UIAlertView *alertUser=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter your password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertUser show];
            return;
        }
        
        if ( conPassword.length == 0 )
        {
            UIAlertView *alertUser=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter password again to confirm." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertUser show];
            return;
        }
        
        NSString *emailString = emailTextField.text;
        NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
        if (([emailTest evaluateWithObject:emailString] != YES))
        {
            UIAlertView *alertUser=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter a valid email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertUser show];
            return;
        }
        if([password isEqualToString:conPassword])
        {
            
            //return;
        }
        else
        {
            UIAlertView *alertUser=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Password does not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertUser show];
            return;

        }
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
        if(isProfile==YES)
        {
            if(isGrid==YES)
            {
                 [self UpdateProfile:gender date:dob bp:BPvalue mobile:phone weight:weightvalue height:heightvalue weightUnit:weightunit heightUnit:heightunit subtodis:subtodicuss medicalcond:currentmedication];
            }
            else
            {
                [self sendProfile:gender date:dob bp:BPvalue mobile:phone weight:weightvalue height:heightvalue weightUnit:weightunit heightUnit:heightunit subtodis:subtodicuss medicalcond:currentmedication];
            }
        }
        else
        {
            [self sendRegistration:fName lanme:lName email:username pass:password cpassword:conPassword];
        }
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        
        if(isProfile==YES)
        {
            if(isGrid==YES)
            {
                 [self UpdateProfile:gender date:dob bp:BPvalue mobile:phone weight:weightvalue height:heightvalue weightUnit:weightunit heightUnit:heightunit subtodis:subtodicuss medicalcond:currentmedication];
            }
            else
            {
                [self sendProfile:gender date:dob bp:BPvalue mobile:phone weight:weightvalue height:heightvalue weightUnit:weightunit heightUnit:heightunit subtodis:subtodicuss medicalcond:currentmedication];
            }
        }
        else
        {
            [self sendRegistration:fName lanme:lName email:username pass:password cpassword:conPassword];
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
    
    else if (alertView.tag==160)
    {
        if(buttonIndex==0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Registration Web Service
/////////////////////////////////////////////////////////////////////////////////

-(void)sendRegistration:(NSString *)fname lanme:(NSString *)lname email:(NSString*)email pass:(NSString*)pass cpassword:(NSString*)cpassword
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/signup",[appDelegate domainURl]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:fname forKey:kFname];
    [request setPostValue:lname forKey:kLname];
    [request setPostValue:email forKey:kUsernameKey];
    [request setPostValue:pass forKey:kPasswordKey];
    [request setPostValue:cpassword forKey:kCPasswordKey];
    [request setPostValue:[appDelegate domainId] forKey:kDomainId];
    [request setPostValue:kProfileType forKey:kProfileTypeFirst];
    [request setPostValue:kappname forKey:kapp];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    [request setDelegate:self];
    [request startSynchronous];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Profile Web Service
/////////////////////////////////////////////////////////////////////////////////

-(void)sendProfile:(NSString *)gen date:(NSString *)date bp:(NSString*)bp mobile:(NSString*)mobile weight:(NSString*)weight height:(NSString*)height weightUnit:(NSString*)weightUnit heightUnit:(NSString*)heightUnit subtodis:(NSString*)subtodis medicalcond:(NSString*)medicalcond
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/signup_details",[appDelegate domainURl]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:gen forKey:kGender];
    [request setPostValue:date forKey:kDOB];
    [request setPostValue:bp forKey:kBP];
    [request setPostValue:mobile forKey:kphone];
    [request setPostValue:weight forKey:kweight];
    [request setPostValue:height forKey:kheight];
    [request setPostValue:weightUnit forKey:kweightunit];
    [request setPostValue:heightUnit forKey:kheightunit];
    [request setPostValue:subtodis forKey:ksubtodis];
    [request setPostValue:medicalcond forKey:kcurrentmedical];
    [request setPostValue:username forKey:kUsernameKey];
    [request setPostValue:[appDelegate domainId] forKey:kDomainId];
    [request setPostValue:kProfileType forKey:kProfileTypeSecond];
    [request setPostValue:kappname forKey:kapp];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    [request setDelegate:self];
    [request startSynchronous];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Profile Update Web Service
/////////////////////////////////////////////////////////////////////////////////

-(void)UpdateProfile:(NSString *)gen date:(NSString *)date bp:(NSString*)bp mobile:(NSString*)mobile weight:(NSString*)weight height:(NSString*)height weightUnit:(NSString*)weightUnit heightUnit:(NSString*)heightUnit subtodis:(NSString*)subtodis medicalcond:(NSString*)medicalcond
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/update_profile",[appDelegate domainURl]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:gen forKey:kGender];
    [request setPostValue:date forKey:kDOB];
    [request setPostValue:bp forKey:kBP];
    [request setPostValue:mobile forKey:kphone];
    [request setPostValue:weight forKey:kweight];
    [request setPostValue:height forKey:kheight];
    [request setPostValue:weightUnit forKey:kweightunit];
    [request setPostValue:heightUnit forKey:kheightunit];
    [request setPostValue:subtodis forKey:ksubtodis];
    [request setPostValue:medicalcond forKey:kcurrentmedical];
    [request setPostValue:[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"email"] forKey:kUsernameKey];
    [request setPostValue:[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"cust_id"] forKey:kcid];
    [request setPostValue:[appDelegate domainId] forKey:kDomainId];
    [request setPostValue:kappname forKey:kapp];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    [request setDelegate:self];
    [request startSynchronous];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - ASIFormData Request Started
/////////////////////////////////////////////////////////////////////////////////

- (void)requestStarted:(ASIFormDataRequest *)request
{
    //start activity indicator on download start
    
}


//////////////////////////////////////////////////////////////////////////////////
#pragma mark - ASIFormData Request Finished
/////////////////////////////////////////////////////////////////////////////////

- (void)requestFinished:(ASIFormDataRequest *)request
{
    //NSString *str=[request responseString];
    //NSLog(@"XML response is %@",str);
    NSDictionary *responseDictionary = [[request responseString] JSONValue];
    NSLog(@"response is %@",responseDictionary);
    if(isProfile==YES)
    {
        if ( [(NSString *)[[responseDictionary objectForKey:@"posts"]objectForKey:kResponseKey] intValue] == 0 )
        {
            NSString *str=[[responseDictionary valueForKey:  @"posts"]valueForKey:kMessageKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        else
        {
            if(isGrid==YES)
            {
                [[LoginAppDelegate getCustomerInfo]setObject:[responseDictionary objectForKey:@"posts"] forKey:@"CustomerDetails"];
                NSInteger profileValue=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"] valueForKey:@"is_profile"] intValue];
                NSUserDefaults *profileText=[NSUserDefaults standardUserDefaults];
                [profileText setInteger:profileValue forKey:@"profile"];
                [profileText synchronize];
                UIAlertView *profileAlert=[[UIAlertView alloc]initWithTitle:nil message:@"Thank you for updating your information." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                profileAlert.tag=160;
                [profileAlert show];
            }
            else
            {
                [[LoginAppDelegate getCustomerInfo]setObject:[responseDictionary objectForKey:@"posts"] forKey:@"CustomerDetails"];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SignupSuccessful"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSInteger profileValue=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"] valueForKey:@"is_profile"] intValue];
                NSUserDefaults *profileText=[NSUserDefaults standardUserDefaults];
                [profileText setInteger:profileValue forKey:@"profile"];
                [profileText synchronize];
                LoginViewController *login=[[LoginViewController alloc]init];
                [self.navigationController pushViewController:login animated:YES];
                
            }
        }
        
    }
    else
    {
        if ( [(NSString *)[[responseDictionary objectForKey:@"posts"]objectForKey:kResponseKey] intValue] == 0 )
        {
            
            NSString *str=[[responseDictionary valueForKey:  @"posts"]valueForKey:kMessageKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        else
        {
        UIImageView *logo2=(UIImageView*)[self.view viewWithTag:99];
        logo2.hidden=YES;
        UIImageView *newImgView=(UIImageView*)[self.view viewWithTag:100];
        newImgView.hidden=YES;
        UILabel *newRegLbl=(UILabel*)[self.view viewWithTag:101];
        newRegLbl.hidden=YES;
        customView.hidden=YES;
        FNTextField.hidden=YES;
        LNTextField.hidden=YES;
        emailTextField.hidden=YES;
        passwordTextField.hidden=YES;
        conPasswordTextField.hidden=YES;
        submitButton.hidden=YES;
        scrollview.contentSize = CGSizeMake(0, 1400);
        scrollview.frame = CGRectMake(0, 0, 320, SCROLLVIEW_HEIGHT);
       scrollview.scrollEnabled=YES;
        [[LoginAppDelegate getRegistrationDetails]setObject:[responseDictionary objectForKey:@"posts"] forKey:@"RegistrationDetails"];
        [self Profile];
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

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button Next, Previous and Done
/////////////////////////////////////////////////////////////////////////////////

-(void)createInputAccessoryView{
    // Create the view that will play the part of the input accessory view.
    // Note that the frame width (third value in the CGRectMake method)
    // should change accordingly in landscape orientation. But we don’t care
    // about that now.
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    
    // Set the view’s background color. We’ ll set it here to gray. Use any color you want.
    [inputAccView setBackgroundColor:[UIColor blackColor]];
    
    // We can play a little with transparency as well using the Alpha property. Normally
    // you can leave it unchanged.
    [inputAccView setAlpha: 0.8];
    
    // If you want you may set or change more properties (ex. Font, background image,e.t.c.).
    // For now, what we’ ve already done is just enough.
    
    // Let’s create our buttons now. First the previous button.
    btnPrev = [UIButton buttonWithType: UIButtonTypeCustom];
    
    // Set the button’ s frame. We will set their widths to 80px and height to 40px.
    [btnPrev setFrame: CGRectMake(0.0, 0.0, 80.0, 40.0)];
    // Title.
    [btnPrev setTitle: @"Previous" forState: UIControlStateNormal];
    // Background color.
    [btnPrev setBackgroundColor: [UIColor blackColor]];
    
    // You can set more properties if you need to.
    // With the following command we’ ll make the button to react in finger tapping. Note that the
    // gotoPrevTextfield method that is referred to the @selector is not yet created. We’ ll create it
    // (as well as the methods for the rest of our buttons) later.
    [btnPrev addTarget: self action: @selector(gotoPrevTextfield) forControlEvents: UIControlEventTouchUpInside];
    
    // Do the same for the two buttons left.
    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNext setFrame:CGRectMake(85.0f, 0.0f, 80.0f, 40.0f)];
    [btnNext setTitle:@"Next" forState:UIControlStateNormal];
    [btnNext setBackgroundColor:[UIColor blackColor]];
    [btnNext addTarget:self action:@selector(gotoNextTextfield) forControlEvents:UIControlEventTouchUpInside];
    
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(240.0, 0.0f, 80.0f, 40.0f)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setBackgroundColor:[UIColor blackColor]];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    
    // Now that our buttons are ready we just have to add them to our view.
    [inputAccView addSubview:btnPrev];
    [inputAccView addSubview:btnNext];
    [inputAccView addSubview:btnDone];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    //    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    scrollview.scrollEnabled=YES;
    [self createInputAccessoryView];
    UIScrollView *scrollView=  (UIScrollView*)[self.view viewWithTag:143];
    // Now add the view as an input accessory view to the selected textfield.
    [textField setInputAccessoryView:inputAccView];
    
    // Set the active field. We' ll need that if we want to move properly
    // between our textfields.
    txtActiveField = textField;
    if(isProfile==YES)
    {
        
        
        
        
    }
    else
    {
        if(txtActiveField==FNTextField)
        {
            [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        if(txtActiveField==LNTextField)
        {
            [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        if(txtActiveField==emailTextField)
        {
            [scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
        }
        if(txtActiveField==passwordTextField)
        {
            [scrollView setContentOffset:CGPointMake(0, 70) animated:YES];
        }
        if(txtActiveField==conPasswordTextField)
        {
            [scrollView setContentOffset:CGPointMake(0, 130) animated:YES];
        }
    }
    NSLog(@"textFieldDidBeginEditing");
}

-(void)gotoPrevTextfield{
    // If the active textfield is the first one, can't go to any previous
    // field so just return.
    UIScrollView *scrollView=  (UIScrollView*)[self.view viewWithTag:143];
    
    if(isProfile==YES)
    {
//        if (txtActiveField == firstNameTxtFld)
//        {
//            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//            return;
//        }
//        else
//        {
//            if(txtActiveField==lastNameTxtFld)
//            {
//                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//                [firstNameTxtFld becomeFirstResponder];
//            }
//            else
//            {
//                [scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
//                [lastNameTxtFld becomeFirstResponder];
//            }
//        }
    }
    else
    {
        
        if (txtActiveField == FNTextField)
        {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            return;
        }
        
        if(txtActiveField==LNTextField)
        {
                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                [FNTextField becomeFirstResponder];
        }
        if(txtActiveField==emailTextField)
        {
                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                [LNTextField becomeFirstResponder];
        }
        
        if(txtActiveField==passwordTextField)
        {
            [scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
            [emailTextField becomeFirstResponder];
        }
        
        if(txtActiveField==conPasswordTextField)
        {
            [scrollView setContentOffset:CGPointMake(0, 70) animated:YES];
            [passwordTextField becomeFirstResponder];
        }
        
            // Otherwise if the second textfield has the focus, the operation
            // of "previous" button can be done and set the first field as the first
            // responder.
            //[emailTextField becomeFirstResponder];
        
    }
    
    // NOTE: If you have more than two textfields, you modify the if... blocks
    // according to your needs. The example here is quite simple and in a complete
    // app it's possible that you'll have more than two textfields.
}

-(void)gotoNextTextfield{
    // If the active textfield is the second one, there is no next so just return.
    UIScrollView *scrollView=  (UIScrollView*)[self.view viewWithTag:143];
    
    if(isProfile==YES)
    {
        //        if(txtActiveField == aboutMeTxtFld)
        //        {
        //            [scrollView setContentOffset:CGPointMake(0, 155) animated:YES];
        //            return;
        //        }
        //        else
        //        {
//        if(txtActiveField==firstNameTxtFld)
//        {
//            [scrollView setContentOffset:CGPointMake(0, 55) animated:YES];
//            [lastNameTxtFld becomeFirstResponder];
//        }
//        else
//        {
//            if(txtActiveField==lastNameTxtFld)
//            {
//                [scrollView setContentOffset:CGPointMake(0, 155) animated:YES];
//                [aboutMeTxtFld becomeFirstResponder];
//            }
//        }
        //}
    }
    else
    {
        if (txtActiveField == conPasswordTextField)
        {
            [scrollView setContentOffset:CGPointMake(0, 130) animated:YES];
            return;
        }
        
       else if(txtActiveField==FNTextField)
        {
                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                [LNTextField becomeFirstResponder];
        }
        
       else if(txtActiveField==LNTextField)
        {
                    [scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
                    [emailTextField becomeFirstResponder];
        }
        
       else if(txtActiveField==emailTextField)
        {
            [scrollView setContentOffset:CGPointMake(0, 70) animated:YES];
            [passwordTextField becomeFirstResponder];
        }
        
       else if(txtActiveField==passwordTextField)
        {
            [scrollView setContentOffset:CGPointMake(0, 130) animated:YES];
            [conPasswordTextField becomeFirstResponder];
        }
        
        
            // Make the second textfield our first responder.
            
        
    }
}

-(void)doneTyping{
    // When the "done" button is tapped, the keyboard should go away.
    // That simply means that we just have to resign our first responder.
    UIScrollView *scrollView=  (UIScrollView*)[self.view viewWithTag:143];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if(isProfile==YES)
    {
        scrollview.scrollEnabled=YES;
    }
    else
    {
        scrollview.scrollEnabled=NO;
    }
    
    [txtActiveField resignFirstResponder];
}



@end

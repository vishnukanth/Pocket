//
//  SendEmail.m
//  PocketDoctor
//
//  Created by vishnu on 09/12/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import "SendEmail.h"
#import "UIColor+UIColorCategory.h"
#import "JSON.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"
#import "RegistrationViewController.h"
@interface SendEmail ()

@end

@implementation SendEmail

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
    
    scrollview = [[UIScrollView alloc] init];
    scrollview.contentSize = CGSizeMake(0, 700);
    scrollview.frame = CGRectMake(0, 60, 320, 440);
    scrollview.scrollsToTop = NO;
    scrollview.tag=143;
    scrollview.delegate = self;
    [self.view addSubview:scrollview];
    scrollview.scrollEnabled=NO;
    
    UIImage *doctorImage=[UIImage imageNamed:@"dr-photo.png"];
    UIImageView *doctImgView=[[UIImageView alloc]initWithFrame:CGRectMake(13, 4, doctorImage.size.width, doctorImage.size.height)];
    doctImgView.image=doctorImage;
    [scrollview addSubview:doctImgView];
    
    UILabel *doctorNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(130, 4, 140, 30)];
    doctorNameLbl.backgroundColor=[UIColor clearColor];
    doctorNameLbl.text=@"Dr. Bram Brons";
    doctorNameLbl.textColor=[UIColor blackColor];
    doctorNameLbl.font=[UIFont fontWithName:@"Arial" size:19.0];
    [scrollview addSubview:doctorNameLbl];
    
    UILabel *doctRegNo=[[UILabel alloc]initWithFrame:CGRectMake(130, 26, 200, 30)];
    doctRegNo.backgroundColor=[UIColor clearColor];
    doctRegNo.text=@"UK GMC Reg. No.: 7010626";
    doctRegNo.textColor=[UIColor blackColor];
    doctRegNo.font=[UIFont fontWithName:@"Arial" size:14.0];
    [scrollview addSubview:doctRegNo];
    
    UILabel *doctPosition=[[UILabel alloc]initWithFrame:CGRectMake(130, 48, 170, 30)];
    doctPosition.backgroundColor=[UIColor clearColor];
    doctPosition.text=@"Position: GP";
    doctPosition.textColor=[UIColor blackColor];
    doctPosition.font=[UIFont fontWithName:@"Arial" size:14.0];
    [scrollview addSubview:doctPosition];
    
    UIButton *subTxtFld = [UIButton buttonWithType:UIButtonTypeCustom];
    subTxtFld.frame=CGRectMake(13,121,290,35);
    subTxtFld.layer.cornerRadius=5;
    subTxtFld.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithHexString:@"#FFFFFF"]);
	[subTxtFld setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    [subTxtFld addTarget:self action:@selector(subFieldClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:subTxtFld];
    
    subTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(13, 8, 260, 20)];
	subTextLbl.backgroundColor=[UIColor clearColor];
//    subTextLbl. text=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"subject_to_discuss"];
	subTextLbl.font=[UIFont fontWithName:@"Arial" size:15.0];
	[subTxtFld addSubview:subTextLbl];
    
    DoctTextView=[[UITextView alloc]initWithFrame:CGRectMake(13, 167, 290, 150)];
    DoctTextView.delegate=self;
    DoctTextView.layer.cornerRadius=7;
    DoctTextView.text = @"Write to Dr. Bram Bros";
    DoctTextView.textColor = [UIColor lightGrayColor];
    DoctTextView.returnKeyType = UIReturnKeyDone;
    [scrollview addSubview:DoctTextView];

    UIButton *sendEmailBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendEmailBtn.frame=CGRectMake(13, 340,290, 40);
    [sendEmailBtn setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
    sendEmailBtn.layer.cornerRadius=7;
    [sendEmailBtn setTitle:@"Send an Email" forState:UIControlStateNormal];
    sendEmailBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:20.0];
    [sendEmailBtn addTarget:self action:@selector(SendEmailClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:sendEmailBtn];
    
    

    // Do any additional setup after loading the view from its nib.
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Subject Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)subFieldClicked
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"To change the subject of your consult, please visit my profile section." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag=1111;
    [alert show];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Subject Button Click Event
/////////////////////////////////////////////////////////////////////////////////

-(void)SendEmailClicked
{
    if([DoctTextView.text isEqualToString:@"Write to Dr. Bram Bros"])
    {
        UIAlertView *textViewAlert=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the content." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [textViewAlert show];
        return;
    }
    else
    {
        [self internetCheck];
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
            RegistrationViewController *reg=[[RegistrationViewController alloc]initWithNibName:@"RegistrationViewController" bundle:nil];
            reg.isGrid=YES;
            [self.navigationController pushViewController:reg animated:YES];
        }
    }
    
    else if (alertView.tag==2222)
    {
        if(buttonIndex==0)
        {
            [self internetCheck];
        }
    }
    
    else if (alertView.tag==3333)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - TextView Delegate Methods
/////////////////////////////////////////////////////////////////////////////////

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text=@"";
    textView.textColor=[UIColor blackColor];
    scrollview.scrollEnabled=YES;
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
    scrollview.scrollEnabled=NO;
    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length == 0)
    {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Write to Dr. Bram Bros";
        [textView resignFirstResponder];
    }
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
    if(textView.text.length == 0)
    {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Write to Dr. bram Bros";
        [textView resignFirstResponder];
    }
    //This method is called when the user makes a change to the text in the textview
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSLog(@"textViewDidChangeSelection:------->>");
    //This method is called when a selection of text is made or changed
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
        alert.tag=2222;
        [alert show];
        
    }
    else if(remoteHostStatus == ReachableViaWiFi)
    {

        [self sendEmailAppointment];
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {

        [self sendEmailAppointment];
    }
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Sende Email Appointment to server
/////////////////////////////////////////////////////////////////////////////////

-(void)sendEmailAppointment
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/SaveAppointment",[appDelegate domainURl]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[appDelegate domainId] forKey:kDomainId];
    [request setPostValue:[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"cust_id"] forKey:kcid];
    [request setPostValue:subTextLbl.text forKey:kemailsub];
    [request setPostValue:DoctTextView.text forKey:kemailcontent];
    [request setPostValue:kappname forKey:kapp];
    [request setPostValue:@"1" forKey:kemailappointment];
    [request setPostValue:@"3" forKey:kappid];
    [request setPostValue:[[[[[LoginAppDelegate getLiveDoctor]objectForKey:@"LiveDetails"] valueForKey:@"result"] objectAtIndex:1] valueForKey:@"prod_master_id"] forKey:kgpid];
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
    if ( [(NSString *)[[responseDictionary objectForKey:@"posts"]objectForKey:kResponseKey] intValue] == 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You can book only one appointment per day." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Thank your for booking an appointment with PocketDoctor. Your query has been sent and the doctor will reply within 24 hours." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag=3333;
        [alert show];
    }
    NSLog(@"response is %@",responseDictionary);
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - viewWillAppear
/////////////////////////////////////////////////////////////////////////////////

-(void)viewWillAppear:(BOOL)animated
{
    subTextLbl.text=[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"subject_to_discuss"];
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

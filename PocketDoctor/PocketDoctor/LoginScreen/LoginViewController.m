//
//  LoginViewController.m
//  PocketDoctor
//
//  Created by vishnu on 18/11/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+UIColorCategory.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "RegistrationViewController.h"
#import "Constants.h"
#import "ASDepthModalViewController.h"
#import "EmailViewController.h"
#import "VideoList.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginView;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize loginButton;
@synthesize registerButton;
@synthesize fgView,forgotButton,forgotPasswordTextfield,submitButton,scrollview,txtActiveField,registerView;
#define SCROLLVIEW_HEIGHT 460
#define SCROLLVIEW_WIDTH  320

#define SCROLLVIEW_CONTENT_HEIGHT 720
#define SCROLLVIEW_CONTENT_WIDTH  320

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - View Life Cycle
/////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(LoginAppDelegate*)[UIApplication sharedApplication].delegate;
    isClicked=YES;
    self.navigationController.navigationBar.hidden=YES;
    self.view.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
//    kiosActivityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    kiosActivityIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
//    [self.view addSubview:kiosActivityIndicator];
   // [kiosActivityIndicator startAnimating];
    [self Loadscreen];
    
    //[self internetCheck];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)Loadscreen
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SignupSuccessful"])
    {
        
        UIImage *logoImg=[UIImage imageNamed:@"logo.png"];
        UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 254, 62)];
        logo.image=logoImg;
        
        
        loginView=[[UIView alloc]init];
        loginView.frame=CGRectMake(25, 0, 270, 420);
        loginView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:loginView];
        
        
        scrollview=[[UIScrollView alloc]init];
        scrollview.frame=CGRectMake(0, 0, 270, 420);
        [loginView addSubview:scrollview];
        [scrollview addSubview:logo];
        
        UIImage *toparrow=[UIImage imageNamed:@"top-arrow.png"];
        UIImageView *logo2=[[UIImageView alloc]initWithFrame:CGRectMake(150, 103, 19, 9)];
        logo2.tag=99;
        logo2.image=toparrow;
        [self.view addSubview:logo2];
        
        UIImage *logoImg1=[UIImage imageNamed:@"helogo-ico.png"];
        UIImageView *logo1=[[UIImageView alloc]initWithFrame:CGRectMake(35, 425, 254, 46)];
        logo1.image=logoImg1;
        logo1.tag=129;
        [self.view addSubview:logo1];
        
        //    CAGradientLayer *l = [CAGradientLayer layer];
        //    l.frame = self.view.bounds;
        //    l.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
        //    l.startPoint = CGPointMake(0.5f, 0.0f);
        //    l.endPoint = CGPointMake(0.5f, 1.0f);
        
        
        customView = [[UIView alloc] initWithFrame:CGRectMake(10, 110, 250, 296)]; //<- change to where you want it to show.
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
        
        
        loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame=CGRectMake(9, 120, 235, 40);
        [loginButton setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
        loginButton.layer.cornerRadius=8;
        [loginButton setTitle:@"Login" forState:UIControlStateNormal];
        loginButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:20.0];
        [loginButton addTarget:self action:@selector(LoginClicked) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:loginButton];
        
        
        //NSUserDefaults *emailLBL=[NSUserDefaults standardUserDefaults];
        //        NSString *emailplaceHolder=[emailLBL stringForKey:@"EmailPlaceHolder"];
        CGRect usernameTxtFldFrame = CGRectMake(9, 25, 235, 31);
        self.usernameTextField = [[UITextField alloc] initWithFrame:usernameTxtFldFrame];
        self.usernameTextField.placeholder=@"Email";
        self.usernameTextField.delegate=self;
       // [usernameTextField becomeFirstResponder];
        self.usernameTextField.keyboardType=UIKeyboardTypeEmailAddress;
        self.usernameTextField.textColor = [UIColor blackColor];
        self.usernameTextField.font = [UIFont systemFontOfSize:14.0f];
        self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.usernameTextField.textAlignment = NSTextAlignmentLeft;
        self.usernameTextField.backgroundColor=[UIColor whiteColor];
        self.usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.usernameTextField.tag = 1;
        self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [customView addSubview:self.usernameTextField];
        
        
        //        NSUserDefaults *pwdLBL=[NSUserDefaults standardUserDefaults];
        //        NSString *passwordplaceHolder=[pwdLBL stringForKey:@"PasswordPlaceHolder"];
        CGRect passwordTxtFldFrame = CGRectMake(9, 70, 235, 31);
        self.passwordTextField = [[UITextField alloc] initWithFrame:passwordTxtFldFrame];
        self.passwordTextField.placeholder=@"Password";
        self.passwordTextField.delegate=self;
        //loginView.backgroundColor = [UIColor clearColor];
        self.passwordTextField.secureTextEntry=YES;
        self.passwordTextField.textColor = [UIColor blackColor];
        self.passwordTextField.font = [UIFont systemFontOfSize:14.0f];
        self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwordTextField.textAlignment = NSTextAlignmentLeft;
        self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.passwordTextField.tag = 2;
        self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [customView addSubview:self.passwordTextField];
        
        UIImageView *newUserImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,13,
                                                                                  40, 40)];
        newUserImage.backgroundColor = [UIColor clearColor];
        newUserImage.image=[UIImage imageNamed:@"newuser-icons.png"];
        
        UIImageView *newUserArrow = [[UIImageView alloc] initWithFrame:CGRectMake(176,35,
                                                                                  15, 15)];
        newUserArrow.backgroundColor = [UIColor clearColor];
        newUserArrow.image=[UIImage imageNamed:@"orarrow-ico.png"];
        
        
        //        NSUserDefaults *RegisterText=[NSUserDefaults standardUserDefaults];
        //        NSString *registerStr=[RegisterText stringForKey:@"RegisterText"];
        //
        //
        //        NSUserDefaults *NewText=[NSUserDefaults standardUserDefaults];
        //        NSString *newUserText=[NewText stringForKey:@"NewUser"];
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0)
        {
            registerView=[[UIView alloc]init];
            registerView.frame=CGRectMake(11, 206, 233, 70);
            registerView.backgroundColor=[UIColor colorWithHexString:@"#F1F1F1"];
            registerView.layer.cornerRadius=7;
            [customView addSubview:registerView];
            UILabel *NewLabel=[[UILabel alloc]initWithFrame:CGRectMake(59, 10, 150, 26)];
            NewLabel.backgroundColor=[UIColor clearColor];
            NewLabel.text=@"New User?";
            NewLabel.textColor=[UIColor colorWithHexString:@"#4B4B4B"];
            NewLabel.font=[UIFont boldSystemFontOfSize:13.0];
            [registerView addSubview:NewLabel];
            registerButton=[UIButton buttonWithType:UIButtonTypeCustom];
            registerButton.frame=CGRectMake(40, 30, 150, 26);
            [registerButton setTitle:@"Register Here" forState:UIControlStateNormal];
            [registerButton setTitleColor:[UIColor colorWithHexString:@"#4B4B4B"] forState:UIControlStateNormal];
            [registerButton addTarget:self action:@selector(RegisterClicked:) forControlEvents:UIControlEventTouchUpInside];
            [registerView addSubview:registerButton];
            [registerView addSubview:newUserImage];
            [registerView addSubview:newUserArrow];
        }
        else
        {
            registerView=[[UIView alloc]init];
            registerView.frame=CGRectMake(11, 206, 233, 70);
            registerView.backgroundColor=[UIColor colorWithHexString:@"#F1F1F1"];
            registerView.layer.cornerRadius=7;
            [customView addSubview:registerView];
            UILabel *NewLabel=[[UILabel alloc]initWithFrame:CGRectMake(59, 10, 150, 26)];
            NewLabel.backgroundColor=[UIColor clearColor];
            NewLabel.text=@"New User?";
            NewLabel.textColor=[UIColor colorWithHexString:@"#4B4B4B"];
            NewLabel.font=[UIFont boldSystemFontOfSize:13.0];
            [registerView addSubview:NewLabel];
            registerButton=[UIButton buttonWithType:UIButtonTypeCustom];
            registerButton.frame=CGRectMake(40, 30, 150, 26);
            [registerButton setTitle:@"Register Here" forState:UIControlStateNormal];
            [registerButton setTitleColor:[UIColor colorWithHexString:@"#4B4B4B"] forState:UIControlStateNormal];
            [registerButton addTarget:self action:@selector(RegisterClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [registerView addSubview:registerButton];
            [registerView addSubview:newUserImage];
            [registerView addSubview:newUserArrow];
        }
        //    loginView.layer.cornerRadius = 5.0f;
        //	loginView.layer.borderColor = [UIColor blackColor].CGColor;
        //	loginView.layer.borderWidth = 2.0f;
        //loginView.backgroundColor=[UIColor whiteColor];
        //        NSUserDefaults *forgotText=[NSUserDefaults standardUserDefaults];
        NSString *forgotStr=@"Forgot Password?";
        if(forgotStr.length>=15)
        {
            forgotButton=[UIButton buttonWithType:UIButtonTypeCustom];
            forgotButton.frame=CGRectMake(40, 170, 185, 26);
            //[scrollview addSubview:forgotButton];
        }
        else
        {
            forgotButton.frame=CGRectMake(45, 170, 130, 26);
            //[scrollview addSubview:forgotButton];
        }
        [forgotButton setTitle:forgotStr forState:UIControlStateNormal];
        [forgotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [forgotButton addTarget:self action:@selector(ForgotButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:forgotButton];
        
        fgView=[[UIView alloc]init];
        fgView.frame=CGRectMake(9, 195, 235, 100);
        fgView.backgroundColor=[UIColor clearColor];
        fgView.hidden=YES;
        [customView addSubview:fgView];
        //[self.usernameTextField becomeFirstResponder];
        CGRect forgotFrame = CGRectMake(1, 20, 235, 31);
        self.forgotPasswordTextfield = [[UITextField alloc] initWithFrame:forgotFrame];
        self.forgotPasswordTextfield.delegate=self;
        self.forgotPasswordTextfield.placeholder=@"Email";
        self.forgotPasswordTextfield.keyboardType=UIKeyboardTypeEmailAddress;
        self.forgotPasswordTextfield.textColor = [UIColor blackColor];
        self.forgotPasswordTextfield.font = [UIFont systemFontOfSize:14.0f];
        self.forgotPasswordTextfield.borderStyle = UITextBorderStyleRoundedRect;
        self.forgotPasswordTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.forgotPasswordTextfield.textAlignment = NSTextAlignmentLeft;
        self.forgotPasswordTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.forgotPasswordTextfield.tag = 3;
        self.forgotPasswordTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        forgotPasswordTextfield.hidden=YES;
        [fgView addSubview:self.forgotPasswordTextfield];
        
        
        //        NSUserDefaults *submitText=[NSUserDefaults standardUserDefaults];
        //        NSString *submitStr=[submitText stringForKey:@"Submit"];
        submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
        submitButton.frame=CGRectMake(1, 70, 235, 40);
        [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        submitButton.layer.cornerRadius=8;
        [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitButton setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
        [submitButton addTarget:self action:@selector(SubmitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [fgView addSubview:submitButton];
    }
    else
    {
        
        NSUserDefaults *profileText=[NSUserDefaults standardUserDefaults];
        NSInteger profile=[profileText integerForKey:@"profile"];
        if (profile==0)
        {
            RegistrationViewController *reg=[[RegistrationViewController alloc]initWithNibName:@"RegistrationViewController" bundle:nil];
            [self.navigationController pushViewController:reg animated:YES];
        }
        else
        {
            //[self.navigationItem setHidesBackButton:YES animated:YES];
            isDeviceInfo=YES;
            [self internetCheck];
            
        }
    }
    
    
    
    
    [kiosActivityIndicator stopAnimating];
    scrollview.scrollEnabled=YES;
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Forgot Button Click event
/////////////////////////////////////////////////////////////////////////////////

-(void)ForgotButtonClicked
{
    if(isClicked==YES)
    {
        UIImageView *img=(UIImageView*)[self.view viewWithTag:99];
        img.frame=CGRectMake(150, 10, 19, 9);
        fgView.hidden=NO;
        forgotPasswordTextfield.hidden=NO;
        //fgView.backgroundColor=[UIColor redColor];
        isClicked=NO;
        loginView.frame=CGRectMake(25, 0, 270, 500);
        customView.frame=CGRectMake(10, 110, 250, 420);
        scrollview.frame=CGRectMake(0, 0, 270, 500);
        registerView.frame=CGRectMake(11, 330, 233, 70);
        //fgView.frame=CGRectMake(15, 310, 214, 100);
        [forgotPasswordTextfield becomeFirstResponder];
        //[loginView addSubview:scrollview];
        scrollview.scrollEnabled=YES;
        scrollview.showsVerticalScrollIndicator=YES;
        
        scrollview.userInteractionEnabled=YES;
        scrollview.contentSize = CGSizeMake(0,660 );
        [scrollview setContentOffset:CGPointMake(0, 180) animated:YES];
        //[scrollview addSubview:fgView];
        
    }
    else
    {
        UIImageView *img=(UIImageView*)[self.view viewWithTag:99];
        img.frame=CGRectMake(150, 103, 19, 9);
        fgView.hidden=YES;
        forgotPasswordTextfield.hidden=YES;
        isClicked=YES;
        loginView.frame=CGRectMake(25, 0, 270, 420);
        customView.frame=CGRectMake(10, 110, 250, 296);
        registerView.frame=CGRectMake(11, 206, 233, 70);
        scrollview.frame=CGRectMake(0, 0, 270, 420);
        //[loginView addSubview:scrollview];
        scrollview.scrollEnabled=NO;
        [forgotPasswordTextfield resignFirstResponder];
        [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        //[fgView removeFromSuperview];
        
    }
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Stop Loading Method
/////////////////////////////////////////////////////////////////////////////////

-(void)stopLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [alertLoader dismissWithClickedButtonIndex:0 animated:YES];
        
    });
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Hide Login Screen
/////////////////////////////////////////////////////////////////////////////////

-(void)hidescreen
{
    loginView.hidden=YES;
    UIImageView *toparrow=(UIImageView*)[self.view viewWithTag:99];
     UIImageView *logo=(UIImageView*)[self.view viewWithTag:129];
    [toparrow removeFromSuperview];
    [logo removeFromSuperview];
    
    
    UILabel *memberlabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 30, 160, 25)];
    memberlabel.backgroundColor=[UIColor clearColor];
    memberlabel.tag=300;
    memberlabel.text=@"Member Area";
    memberlabel.textColor=[UIColor blackColor];
    memberlabel.font=[UIFont fontWithName:@"Helvetica" size:15.0];
    [self.view addSubview:memberlabel];
    
    memberAreaView=[[UIView alloc]initWithFrame:CGRectMake(0, 70, 320, self.view.frame.size.height)];
    memberAreaView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:memberAreaView];
    
    UIButton *videoChatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    videoChatBtn.frame=CGRectMake(15, 120, 140, 100);
    videoChatBtn.layer.cornerRadius=5;
    [videoChatBtn setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
    [videoChatBtn addTarget:self action:@selector(videoChatClicked:) forControlEvents:UIControlEventTouchUpInside];
    [memberAreaView addSubview:videoChatBtn];
    UIImage *videoimg=[UIImage imageNamed:@"video-chat-icon.png"];
    UIImageView *videoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(51, 15, videoimg.size.width, videoimg.size.height)];
    videoImgView.image=videoimg;
    [videoChatBtn addSubview:videoImgView];
    UILabel *videoChatLbl=[[UILabel alloc]initWithFrame:CGRectMake(24, 61, 100, 40)];
    videoChatLbl.backgroundColor=[UIColor clearColor];
    videoChatLbl.text=@"Video Chat";
    videoChatLbl.textColor=[UIColor whiteColor];
    videoChatLbl.font=[UIFont fontWithName:@"Arial" size:19.0];
    [videoChatBtn addSubview:videoChatLbl];
    
    
    UIButton *emailChatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    emailChatBtn.frame=CGRectMake(165, 10, 140, 100);
    emailChatBtn.layer.cornerRadius=5;
    [emailChatBtn setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
    [emailChatBtn addTarget:self action:@selector(emailChatClicked:) forControlEvents:UIControlEventTouchUpInside];
    [memberAreaView addSubview:emailChatBtn];
    UIImage *emailimg=[UIImage imageNamed:@"email-chat-icon.png"];
    UIImageView *emailImgView=[[UIImageView alloc]initWithFrame:CGRectMake(51, 15, emailimg.size.width, emailimg.size.height)];
    emailImgView.image=emailimg;
    [emailChatBtn addSubview:emailImgView];
    UILabel *emailChatLbl=[[UILabel alloc]initWithFrame:CGRectMake(25, 61, 100, 40)];
    emailChatLbl.backgroundColor=[UIColor clearColor];
    emailChatLbl.text=@"Email Chat";
    emailChatLbl.textColor=[UIColor whiteColor];
    emailChatLbl.font=[UIFont fontWithName:@"Arial" size:19.0];
    [emailChatBtn addSubview:emailChatLbl];
    
    
    UIButton *teleChatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    teleChatBtn.frame=CGRectMake(165, 120, 140, 100);
    teleChatBtn.layer.cornerRadius=5;
    [teleChatBtn setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
    [teleChatBtn addTarget:self action:@selector(teleChatClicked:) forControlEvents:UIControlEventTouchUpInside];
    [memberAreaView addSubview:teleChatBtn];
    UIImage *teleimg=[UIImage imageNamed:@"telephone-icon.png"];
    UIImageView *teleImgView=[[UIImageView alloc]initWithFrame:CGRectMake(54, 17, teleimg.size.width, teleimg.size.height)];
    teleImgView.image=teleimg;
    [teleChatBtn addSubview:teleImgView];
    UILabel *teleChatLbl=[[UILabel alloc]initWithFrame:CGRectMake(27, 61, 100, 40)];
    teleChatLbl.backgroundColor=[UIColor clearColor];
    teleChatLbl.text=@"Telephone";
    teleChatLbl.textColor=[UIColor whiteColor];
    teleChatLbl.font=[UIFont fontWithName:@"Arial" size:19.0];
    [teleChatBtn addSubview:teleChatLbl];
    
    
    UIButton *profileBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    profileBtn.frame=CGRectMake(15, 10, 140, 100);
    profileBtn.layer.cornerRadius=5;
    profileBtn.tag=200;
    [profileBtn setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
    [profileBtn addTarget:self action:@selector(profileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [memberAreaView addSubview:profileBtn];
    UIImage *profileimg=[UIImage imageNamed:@"my-profile-icon.png"];
    UIImageView *profileImgView=[[UIImageView alloc]initWithFrame:CGRectMake(46, 15, profileimg.size.width, profileimg.size.height)];
    profileImgView.image=profileimg;
    [profileBtn addSubview:profileImgView];
    UILabel *profileLbl=[[UILabel alloc]initWithFrame:CGRectMake(30, 61, 100, 40)];
    profileLbl.backgroundColor=[UIColor clearColor];
    profileLbl.text=@"My Profile";
    profileLbl.textColor=[UIColor whiteColor];
    profileLbl.font=[UIFont fontWithName:@"Arial" size:19.0];
    [profileBtn addSubview:profileLbl];
    
    
    UIButton *passwordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    passwordBtn.frame=CGRectMake(15, 230, 140, 100);
    passwordBtn.layer.cornerRadius=5;
    [passwordBtn setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
    [passwordBtn addTarget:self action:@selector(forgotPasswordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [memberAreaView addSubview:passwordBtn];
    UIImage *passwordimg=[UIImage imageNamed:@"password-icon.png"];
    UIImageView *passswordImgView=[[UIImageView alloc]initWithFrame:CGRectMake(39, 15, passwordimg.size.width, passwordimg.size.height)];
    passswordImgView.image=passwordimg;
    [passwordBtn addSubview:passswordImgView];
    UILabel *passwordLbl=[[UILabel alloc]initWithFrame:CGRectMake(30, 61, 100, 40)];
    passwordLbl.backgroundColor=[UIColor clearColor];
    passwordLbl.text=@"Password";
    passwordLbl.textColor=[UIColor whiteColor];
    passwordLbl.font=[UIFont fontWithName:@"Arial" size:19.0];
    [passwordBtn addSubview:passwordLbl];
    
    
    UIButton *logoutBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame=CGRectMake(165, 230, 140, 100);
    logoutBtn.layer.cornerRadius=5;
    [logoutBtn setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
    [logoutBtn addTarget:self action:@selector(logoutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [memberAreaView addSubview:logoutBtn];
    UIImage *logoutimg=[UIImage imageNamed:@"logout-icon.png"];
    UIImageView *logoutImgView=[[UIImageView alloc]initWithFrame:CGRectMake(55, 15, logoutimg.size.width, logoutimg.size.height)];
    logoutImgView.image=logoutimg;
    [logoutBtn addSubview:logoutImgView];
    UILabel *logoutLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, 61, 100, 40)];
    logoutLbl.backgroundColor=[UIColor clearColor];
    logoutLbl.text=@"Logout";
    logoutLbl.textColor=[UIColor whiteColor];
    logoutLbl.font=[UIFont fontWithName:@"Arial" size:19.0];
    [logoutBtn addSubview:logoutLbl];
    
    popUpView=[[UIView alloc]initWithFrame:CGRectMake(20, 20, 270, 270)];
    popUpView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:popUpView];
    
    oldPwdTxtFld = [[UITextField alloc] initWithFrame:CGRectMake(5 ,5,230,30)];
    oldPwdTxtFld.tag=120;
    oldPwdTxtFld.delegate = self;
    oldPwdTxtFld.placeholder=@"Old Password";
    oldPwdTxtFld.font=[UIFont fontWithName:@"Arial" size:16.0];
    oldPwdTxtFld.textAlignment = NSTextAlignmentLeft;
    oldPwdTxtFld.returnKeyType=UIReturnKeyNext;
    oldPwdTxtFld.secureTextEntry=YES;
    oldPwdTxtFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [popUpView addSubview:oldPwdTxtFld];
    oldPwdTxtFld.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [[oldPwdTxtFld layer] setBorderColor:[[UIColor colorWithHexString:@"#FFFFFF"] CGColor]];
    [[oldPwdTxtFld layer] setBorderWidth:1.0];
    [[oldPwdTxtFld layer] setCornerRadius:5];
    
    newPwdTxtFld = [[UITextField alloc] initWithFrame:CGRectMake(5,55,230,30)];
    newPwdTxtFld.tag=121;
    newPwdTxtFld.delegate = self;
    newPwdTxtFld.placeholder=@"New Password";
    newPwdTxtFld.font=[UIFont fontWithName:@"Arial" size:16.0];
    newPwdTxtFld.textAlignment = NSTextAlignmentLeft;
    newPwdTxtFld.returnKeyType=UIReturnKeyNext;
    newPwdTxtFld.secureTextEntry=YES;
    newPwdTxtFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [popUpView addSubview:newPwdTxtFld];
    newPwdTxtFld.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [[newPwdTxtFld layer] setBorderColor:[[UIColor colorWithHexString:@"#FFFFFF"] CGColor]];
    [[newPwdTxtFld layer] setBorderWidth:1.0];
    [[newPwdTxtFld layer] setCornerRadius:5];
    
    confirmTxtFld = [[UITextField alloc] initWithFrame:CGRectMake(5,105,230,30)];
    confirmTxtFld.tag=122;
    confirmTxtFld.delegate = self;
    confirmTxtFld.placeholder=@"Confirm Password";
    confirmTxtFld.font=[UIFont fontWithName:@"Arial" size:16.0];
    confirmTxtFld.textAlignment = NSTextAlignmentLeft;
    confirmTxtFld.secureTextEntry=YES;
    confirmTxtFld.returnKeyType=UIReturnKeyDone;
    confirmTxtFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [popUpView addSubview:confirmTxtFld];
    confirmTxtFld.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [[confirmTxtFld layer] setBorderColor:[[UIColor colorWithHexString:@"#FFFFFF"] CGColor]];
    [[confirmTxtFld layer] setBorderWidth:1.0];
    [[confirmTxtFld layer] setCornerRadius:5];
    
    
   UIButton *changePwdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    changePwdBtn.tag=123;
    changePwdBtn.frame=CGRectMake(6, 150, 235, 40);
    [changePwdBtn setTitle:@"Change Your Password" forState:UIControlStateNormal];
    changePwdBtn.layer.cornerRadius=8;
    [changePwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changePwdBtn setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
    [changePwdBtn addTarget:self action:@selector(ChangeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:changePwdBtn];
    
    popUpView.hidden=YES;
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Register Button Click event
/////////////////////////////////////////////////////////////////////////////////
-(void)RegisterClicked:(UIButton*)sender
{
    
    RegistrationViewController *reg=[[RegistrationViewController alloc]initWithNibName:@"RegistrationViewController" bundle:nil];
    [self.navigationController pushViewController:reg animated:YES];
}


//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Member Area Button Click events (Profile Button)
/////////////////////////////////////////////////////////////////////////////////

-(void)profileBtnClicked:(UIButton*)sender
{
    RegistrationViewController *reg=[[RegistrationViewController alloc]initWithNibName:usernameTextField.text];
    reg.isGrid=YES;
    [self.navigationController pushViewController:reg animated:YES];
}

-(void)emailChatClicked:(UIButton*)sender
{
    EmailViewController *emailChat=[[EmailViewController alloc]initWithNibName:@"EmailViewController" bundle:nil];
    [self.navigationController pushViewController:emailChat animated:YES];
}

-(void)forgotPasswordBtnClicked:(UIButton*)sender
{
    UIColor *color = nil;
    popUpView.hidden=NO;
    popUpView.layer.cornerRadius = 12;
    popUpView.layer.shadowOpacity = 0.7;
    popUpView.layer.shadowOffset = CGSizeMake(6, 6);
    popUpView.layer.shouldRasterize = YES;
    popUpView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    ASDepthModalOptions style = ASDepthModalOptionAnimationGrow;
    ASDepthModalOptions options;
    
    options = style | (ASDepthModalOptionBlurNone) | (ASDepthModalOptionTapOutsideToClose);
    
    [ASDepthModalViewController presentView:popUpView
                            backgroundColor:color
                                    options:options
                          completionHandler:^{
                              NSLog(@"Modal view closed.");
                          }];
    
    
}

-(void)logoutBtnClicked:(UIButton*)sender
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SignupSuccessful"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    memberAreaView.hidden=YES;
    UILabel *memLbl=(UILabel*)[self.view viewWithTag:300];
    [memLbl removeFromSuperview];
    [self Loadscreen];
    
}

-(void)videoChatClicked:(UIButton*)sender
{
    VideoList *videoView=[[VideoList alloc]initWithNibName:@"VideoList" bundle:nil];
    videoView.isVideo=YES;
    videoView.isTelephone=NO;
    [self.navigationController pushViewController:videoView animated:YES];
}

-(void)teleChatClicked:(UIButton*)sender
{
    VideoList *videoView=[[VideoList alloc]initWithNibName:@"VideoList" bundle:nil];
    videoView.isVideo=NO;
    videoView.isTelephone=YES;
    [self.navigationController pushViewController:videoView animated:YES];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Change Pwd Button Clicked
/////////////////////////////////////////////////////////////////////////////////

-(void)ChangeButtonClicked:(UIButton*)sender
{
    if(oldPwdTxtFld.text.length==0 && newPwdTxtFld.text.length==0 && confirmTxtFld.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"All fields are mandatory." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
    else if (oldPwdTxtFld.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter your old password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
    else if (newPwdTxtFld.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter your new password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
    else if (confirmTxtFld.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter password again to confirm." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
   else if(![newPwdTxtFld.text isEqualToString:confirmTxtFld.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Password does not match." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
        
    }
    
        isForgotPwd=YES;
        [self internetCheck];
    
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Login Button Click event
/////////////////////////////////////////////////////////////////////////////////

-(void)LoginClicked
{
    alertLoader = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Wait..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    alertLoader.tag=6666;
    [alertLoader show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(130, 60, 25, 25)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	indicator.backgroundColor = [UIColor clearColor];
	[alertLoader addSubview:indicator];
    [indicator startAnimating];
    username = [[self.usernameTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    password = [[self.passwordTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    if ( username.length == 0 )
    {
        [self stopLoading];
        UIAlertView *alertUser=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter your email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertUser show];
        return;
    }
    else if(password .length==0)
    {
        [self stopLoading];
        UIAlertView *alertUser=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertUser show];
        return;
    }
    NSString *emailString = self.usernameTextField.text;
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    if (([emailTest evaluateWithObject:emailString] != YES))
    {
        [self stopLoading];
        UIAlertView *alertUser=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter a valid email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertUser show];
        return;
        
    }
    [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    [txtActiveField resignFirstResponder];
    //[self hidescreen];
    [kiosActivityIndicator startAnimating];
    //    //        NSUserDefaults *Loading=[NSUserDefaults standardUserDefaults];
    //    //        NSString *loadingAlert= [Loading stringForKey:@"LoadingAlert"];
    //    //        self.progressView=[self.sharedController createProgressViewToParentView:self.view withTitle:loadingAlert];
    isLogin=YES;
    [self internetCheck];
    
    
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Submit Button Click event
/////////////////////////////////////////////////////////////////////////////////

-(void)SubmitButtonClicked
{
    alertLoader = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Wait..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    alertLoader.tag=6666;
    [alertLoader show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(130, 60, 25, 25)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	indicator.backgroundColor = [UIColor clearColor];
	[alertLoader addSubview:indicator];
    [indicator startAnimating];
    username = [[self.forgotPasswordTextfield text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
//    NSUserDefaults *enterEmail=[NSUserDefaults standardUserDefaults];
//    NSString *emptyEmail=[enterEmail stringForKey:@"EnterEmail"];
//    
//    NSUserDefaults *validEmailText=[NSUserDefaults standardUserDefaults];
//    NSString *validEmail=[validEmailText stringForKey:@"ValidEmail"];
    
    
    
    if ( username.length==0 )
    {
        [self stopLoading];
        UIAlertView *alertUser=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter your email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertUser show];
        return;
    }
    
    
    NSString *emailString = self.forgotPasswordTextfield.text;
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    if (([emailTest evaluateWithObject:emailString] != YES))
    {
        [self stopLoading];
        UIAlertView *alertUser=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter a valid email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertUser show];
        return;
        
        
    }
    
    [txtActiveField resignFirstResponder];
    [kiosActivityIndicator startAnimating];
    //        NSUserDefaults *Loading=[NSUserDefaults standardUserDefaults];
    //        NSString *loadingAlert= [Loading stringForKey:@"LoadingAlert"];
    //        self.progressView=[self.sharedController createProgressViewToParentView:self.view withTitle:loadingAlert];
    
    isForgot=YES;
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
        [self stopLoading];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" message:@"NO Internet Connection" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        alert.tag=1111;
        [alert show];
        
    }else if(remoteHostStatus == ReachableViaWiFi)
    {
        if(isForgot==YES)
        {
            [self getPassword:username did:[appDelegate domainId]];
        }
        else if(isLogin==YES)
        {
         [self getLogin:username variabl:password did:[appDelegate domainId]];
        }
        else if (isForgotPwd==YES)
        {
            [self getChangePassword:[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"cust_id"] oldpwd:oldPwdTxtFld.text newpwd:newPwdTxtFld.text did:[appDelegate domainId]];
        }
        
        else if (isDeviceInfo==YES)
        {
            [self sendDevice];
        }

        //        [kiosActivityIndicator stopAnimating];
        //        [self LoadScreen];
        
        
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        
        if(isForgot==YES)
        {
            [self getPassword:username did:[appDelegate domainId]];
        }
        else if(isLogin==YES)
        {
            [self getLogin:username variabl:password did:[appDelegate domainId]];
        }
        else if (isForgotPwd==YES)
        {
            [self getChangePassword:[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"cust_id"] oldpwd:oldPwdTxtFld.text newpwd:newPwdTxtFld.text did:[appDelegate domainId]];
        }
        else if (isDeviceInfo==YES)
        {
            [self sendDevice];
        }

        
        //        [kiosActivityIndicator stopAnimating];
        //        [self LoadScreen];
        
        
        
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
#pragma mark - Login Web Service
/////////////////////////////////////////////////////////////////////////////////

-(void)getLogin:(NSString *)value variabl:(NSString *)variablename did:(NSString*)did
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/getLogin",[appDelegate domainURl]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:value forKey:kUsernameKey];
    [request setPostValue:variablename forKey:kPasswordKey];
    [request setPostValue:did forKey:kDomainId];
    [request setPostValue:kappname forKey:kapp];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    [request setDelegate:self];
    [request startSynchronous];

}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Forgot Password Web Service
/////////////////////////////////////////////////////////////////////////////////

-(void)getPassword:(NSString*)usern did:(NSString*)did
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/SendPassword",[appDelegate domainURl]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:usern forKey:kUsernameKey];
    [request setPostValue:did forKey:kDomainId];
    [request setPostValue:kappname forKey:kapp];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    [request setDelegate:self];
    [request startSynchronous];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Forgot Password Web Service
/////////////////////////////////////////////////////////////////////////////////

-(void)getChangePassword:(NSString*)cid oldpwd:(NSString*)oldpwd newpwd:(NSString*)newpwd did:(NSString*)did
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/changePassword",[appDelegate domainURl]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:cid forKey:kcid];
    [request setPostValue:oldpwd forKey:koldpwd];
    [request setPostValue:newpwd forKey:knewpwd];
    [request setPostValue:did forKey:kDomainId];
    [request setPostValue:kappname forKey:kapp];
    [request setPostValue:kProfileType forKey:kProfileTypeFirst];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    [request setDelegate:self];
    [request startSynchronous];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Device Info Web Service
/////////////////////////////////////////////////////////////////////////////////

-(void)sendDevice
{
    NSUserDefaults *tokenString=[NSUserDefaults standardUserDefaults];
    NSString *phonetoken=[tokenString stringForKey:@"DeviceToken"];
    NSUserDefaults *deviceid=[NSUserDefaults standardUserDefaults];
    NSString *phoneid=[deviceid stringForKey:@"DeviceId"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/saveDeviceInfo",[appDelegate domainURl]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"cust_id"] forKey:kcid];
    [request setPostValue:[appDelegate domainId] forKey:kDomainId];
    [request setPostValue:kappname forKey:kapp];
    [request setPostValue:@"3" forKey:kappid];
    [request setPostValue:phonetoken forKey:ktoken];
    [request setPostValue:phoneid forKey:kdeviceid];
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
    [self stopLoading];
    NSDictionary *responseDictionary = [[request responseString] JSONValue];
    NSLog(@"response is %@",responseDictionary);
    if(isLogin==YES)
    {
        
        
        if ( [(NSString *)[[responseDictionary objectForKey:@"posts"]objectForKey:kResponseKey] intValue] == 0 )
        {
            isLogin=NO;
            //[kiosActivityIndicator stopAnimating];
            NSString *str=[[responseDictionary valueForKey:  @"posts"]valueForKey:kMessageKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
        else
        {
            isLogin=NO;
            NSInteger profileValue=[[[responseDictionary valueForKey:  @"posts"]valueForKey:@"is_profile"] intValue];
            NSUserDefaults *profileText=[NSUserDefaults standardUserDefaults];
            [profileText setInteger:profileValue forKey:@"profile"];
            [profileText synchronize];
            if(profileValue==0)
            {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SignupSuccessful"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[LoginAppDelegate getRegistrationDetails]setObject:[responseDictionary objectForKey:@"posts"] forKey:@"RegistrationDetails"];
                //RegistrationViewController *registerViewCO=[[RegistrationViewController alloc]initWithNibName:[[[LoginAppDelegate getRegistrationDetails]objectForKey:@"RegistrationDetails"]valueForKey:@"cust_details"]];
                RegistrationViewController *registerViewCO=[[RegistrationViewController alloc]initWithNibName:usernameTextField.text];
                [self.navigationController pushViewController:registerViewCO animated:YES];

            }
            else
            {
                 //[kiosActivityIndicator stopAnimating];
            [[LoginAppDelegate getCustomerInfo]setObject:[responseDictionary objectForKey:@"posts"] forKey:@"CustomerDetails"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SignupSuccessful"];
            [[NSUserDefaults standardUserDefaults]synchronize];
                isDeviceInfo=YES;
                [self internetCheck];
            }

        }
    }
    else
    {  if(isForgot==YES)
      {
        if ( [(NSString *)[[responseDictionary objectForKey:@"posts"]objectForKey:kResponseKey] intValue] == 0 )
        {
            isForgot=NO;
            //[kiosActivityIndicator stopAnimating];
            NSString *str=[[responseDictionary valueForKey:  @"posts"]valueForKey:kMessageKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            
            [alert show];
        }
          else if ([(NSString *)[[responseDictionary objectForKey:@"posts"]objectForKey:kResponseKey] intValue] == 1)
          {
              isForgot=NO;
             // [kiosActivityIndicator stopAnimating];
              NSString *str=[[responseDictionary valueForKey:  @"posts"]valueForKey:kMessageKey];
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
              
              [alert show];
          }
      }
        
        else
        {
            if(isForgotPwd==YES)
            {
                isForgotPwd=NO;
                [ASDepthModalViewController dismiss];
            }
            
            else if (isDeviceInfo==YES)
            {
                isDeviceInfo=NO;
                [self hidescreen];
            }
        }
    }

}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - TextField Delegate Methods
/////////////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //NSLog(@"textFieldShouldReturn:");
    txtActiveField = textField;
    UIImageView *img=(UIImageView*)[self.view viewWithTag:99];
    if(txtActiveField==usernameTextField)
    {
        img.frame=CGRectMake(150, 110, 19, 9);
        [passwordTextField becomeFirstResponder];
        
    }
   else if(txtActiveField==passwordTextField)
    {
        img.frame=CGRectMake(150, 103, 19, 9);
        [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        [txtActiveField resignFirstResponder];
        
        //[scrollview setContentOffset:CGPointMake(0, 55) animated:YES];
    }
  else if(txtActiveField==forgotPasswordTextfield)
    {
        img.frame=CGRectMake(150, 103, 19, 9);
        [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        [txtActiveField resignFirstResponder];
        //[scrollview setContentOffset:CGPointMake(0, 140) animated:YES];
    }
    
  else if(txtActiveField==oldPwdTxtFld)
  {
     
      
      [newPwdTxtFld becomeFirstResponder];
      //[scrollview setContentOffset:CGPointMake(0, 140) animated:YES];
  }
  else if(txtActiveField==newPwdTxtFld)
  {
      
     
      [confirmTxtFld becomeFirstResponder];
      //[scrollview setContentOffset:CGPointMake(0, 140) animated:YES];
  }
  else if(txtActiveField==confirmTxtFld)
  {
      
      
      [txtActiveField resignFirstResponder];
      //[scrollview setContentOffset:CGPointMake(0, 140) animated:YES];
  }
    
    
    return YES;
//    NSInteger nextTag = textField.tag + 1;
//    // Try to find next responder
//    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//    if (nextResponder) {
//        // Found next responder, so set it.
//        [nextResponder becomeFirstResponder];
//    } else {
//        // Not found, so remove keyboard.
//        //scrollview.scrollEnabled=YES;
//        [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
//        [txtActiveField resignFirstResponder];
//    }
    return YES;
}

//- (void) animateTextField: (UITextField*) textField up: (BOOL) up
//{
//    
//    UITextField *moneyFld=(UITextField*)[popUpView viewWithTag:121];
//    UITextField *moneyFld1=(UITextField*)[popUpView viewWithTag:122];
//    if(textField == moneyFld)
//    {
//        const int movementDistance = 60; // tweak as needed
//        const float movementDuration = 0.8f; // tweak as needed
//        
//        int movement = (up ? -movementDistance : movementDistance);
//        
//        [UIView beginAnimations: @"anim" context: nil];
//        [UIView setAnimationBeginsFromCurrentState: YES];
//        [UIView setAnimationDuration: movementDuration];
//        popUpView.frame = CGRectOffset(popUpView.frame, 0, movement);
//        [UIView commitAnimations];
//    }
//    
//    if(textField == moneyFld1)
//    {
//        const int movementDistance = 69; // tweak as needed
//        const float movementDuration = 0.8f; // tweak as needed
//        
//        int movement = (up ? -movementDistance : movementDistance);
//        
//        [UIView beginAnimations: @"anim" context: nil];
//        [UIView setAnimationBeginsFromCurrentState: YES];
//        [UIView setAnimationDuration: movementDuration];
//        popUpView.frame = CGRectOffset(popUpView.frame, 0, movement);
//    }
//    
//    
//    
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    scrollview.scrollEnabled=YES;
    
    
    // Now add the view as an input accessory view to the selected textfield.
    
    // Set the active field. We' ll need that if we want to move properly
    // between our textfields.
    txtActiveField = textField;
    UIImageView *img=(UIImageView*)[self.view viewWithTag:99];
//    UIImageView *logo2=[[UIImageView alloc]initWithFrame:CGRectMake(150, 103, 19, 9)];
//    logo2.tag=99;
    if(txtActiveField==usernameTextField)
    {
        [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        img.frame=CGRectMake(150, 103, 19, 9);
    }
    if(txtActiveField==passwordTextField)
    {
        [scrollview setContentOffset:CGPointMake(0, 55) animated:YES];
        img.frame=CGRectMake(150, 47, 19, 9);
    }
    if(txtActiveField==forgotPasswordTextfield)
    {
        [scrollview setContentOffset:CGPointMake(0, 140) animated:YES];
        img.frame=CGRectMake(150, 10, 19, 9);
    }
    
    if(txtActiveField==newPwdTxtFld)
    {
        
    }
    
    if(txtActiveField==confirmTxtFld)
    {
        
    }
    //NSLog(@"textFieldDidBeginEditing");
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

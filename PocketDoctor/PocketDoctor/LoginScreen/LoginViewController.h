//
//  LoginViewController.h
//  PocketDoctor
//
//  Created by vishnu on 18/11/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAppDelegate.h"
#import "RegistrationViewController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIView *loginView;
    UIView *fgView;
    UIView *registerView;
    UIView *customView;
    UIView *memberAreaView;
    
    LoginAppDelegate *appDelegate;
    
    UIButton *forgotButton;
    UIButton *submitButton;
    UIButton *loginButton;
    UIButton *registerButton;
    
    UITextField *forgotPasswordTextfield;
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UITextField *txtActiveField;
    UITextField *oldPwdTxtFld;
    UITextField *newPwdTxtFld;
    UITextField *confirmTxtFld;
    NSString *username;
    NSString *password;
    BOOL isDeviceInfo;
    UIView *popUpView;
   
    
    UIActivityIndicatorView *kiosActivityIndicator;
     UIAlertView *alertLoader;
    
    UIScrollView  *scrollview;
    
    BOOL isClicked;
    BOOL isLogin;
    BOOL isForgot;
    BOOL isForgotPwd;
}
@property (nonatomic, retain)  UIView *registerView;
@property (nonatomic, retain)  UIView *fgView;
@property (nonatomic, retain)  UIView *loginView;

@property (nonatomic, retain)  UIButton *forgotButton;
@property (nonatomic, retain)  UIButton *submitButton;
@property (nonatomic, retain)  UIButton *loginButton;
@property (nonatomic, retain) UIButton *registerButton;

@property (nonatomic, retain)  UITextField *forgotPasswordTextfield;
@property (nonatomic, retain)  UITextField *usernameTextField;
@property (nonatomic, retain)  UITextField *passwordTextField;
@property (nonatomic, retain) UITextField *txtActiveField;

@property (nonatomic, retain) UIScrollView *scrollview;
-(void)hidescreen;
@end

//
//  SendEmail.h
//  PocketDoctor
//
//  Created by vishnu on 09/12/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAppDelegate.h"

@interface SendEmail : UIViewController<UITextViewDelegate,UIScrollViewDelegate>
{
    LoginAppDelegate *appDelegate;
    UIImageView *backBtn;
    UIButton *backBtnTitle;
    
    UIActivityIndicatorView *activityView;
    UIView *loadingView;
    UILabel *loadingLabel;
    UILabel *subTextLbl;
    UIScrollView  *scrollview;
    UITextView *DoctTextView;
}

@end

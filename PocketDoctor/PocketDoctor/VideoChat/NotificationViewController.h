//
//  NotificationViewController.h
//  PocketDoctor
//
//  Created by vishnu on 17/12/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAppDelegate.h"
#define MAX_VALUE 10
@interface NotificationViewController : UIViewController
{
    LoginAppDelegate *appDelegate;
    UIImageView *backBtn;
    UIButton *backBtnTitle;
}
@property (strong,nonatomic) UILabel *counterLabel;
@property int counterValue;
@property (copy) NSTimer *timer;
- (void)startTimer;
- (void)killTimer;
- (void)updateLabel:(id)sender;
@end

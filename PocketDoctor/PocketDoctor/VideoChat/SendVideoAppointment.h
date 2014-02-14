//
//  SendVideoAppointment.h
//  PocketDoctor
//
//  Created by vishnu on 11/12/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAppDelegate.h"

@interface SendVideoAppointment : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    LoginAppDelegate *appDelegate;
    UIImageView *backBtn;
    UIButton *backBtnTitle;
    BOOL isCalendar;
    BOOL isVideo;
    
    UIActivityIndicatorView *activityView;
    UIView *loadingView;
    UILabel *loadingLabel;
    
    UIView *customPickerViewDate;
    UIView *customPickerViewTime;
    UIPickerView *pickerViewDate;
    UIPickerView *pickerViewTime;
    NSMutableArray *timeArray;
    BOOL isTelephone;
    BOOL isVideos;
    
}

@property(nonatomic,assign)BOOL isTelephone;
@property(nonatomic,assign)BOOL isVideos;

@end

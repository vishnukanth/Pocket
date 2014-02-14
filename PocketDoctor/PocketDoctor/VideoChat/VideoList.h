//
//  VideoList.h
//  PocketDoctor
//
//  Created by vishnu on 11/12/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAppDelegate.h"

@interface VideoList : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    LoginAppDelegate *appDelegate;
    UIImageView *backBtn;
    UIButton *backBtnTitle;
    
    UITableView *videoApptTableView;
    UITableView *nextAppointmentTableView;
    NSMutableArray *DateArray;
    NSMutableArray *TimeArray;
    NSMutableArray *NextDateArray;
    NSMutableArray *NextTimeArray;
    BOOL isTelephone;
    BOOL isVideo;
    
    
}
@property(nonatomic,assign)BOOL isTelephone;
@property(nonatomic,assign)BOOL isVideo;
@end

//
//  LoginAppDelegate.h
//  PocketDoctor
//
//  Created by vishnu on 18/11/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;
@interface LoginAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *domainURl;
    NSString *domainId;
    BOOL isCalendar;
    BOOL isUnit;
    BOOL isLiveDoctor;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *viewController;
@property (strong, nonatomic) NSString *domainURl;
@property (strong, nonatomic)NSString *domainId;
+(NSMutableDictionary *)getCustomerInfo;
+(NSMutableDictionary *)getRegistrationDetails;
+(NSMutableDictionary *)getUnitDetails;
+(NSMutableDictionary*)getCalendar;
+(NSMutableDictionary*)getLiveDoctor;
+(NSMutableDictionary*)getBookedAppointments;
+(NSMutableDictionary*)getEmailConversation;
+(NSMutableDictionary*)getAVAppointments;
@end

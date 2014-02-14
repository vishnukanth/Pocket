//
//  LoginAppDelegate.m
//  PocketDoctor
//
//  Created by vishnu on 18/11/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import "LoginAppDelegate.h"
#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "JSON.h"
#import "Constants.h"
#import "UIDevice-Hardware.h"
#import "UIDevice+IdentifierAddition.h"
#import "NotificationViewController.h"

@implementation LoginAppDelegate
@synthesize domainId,domainURl;

NSMutableDictionary *getCustomerList;
NSMutableDictionary *getRegDetails;
NSMutableDictionary *getUnit;;
NSMutableDictionary *getDates;
NSMutableDictionary *getProductInfo;
NSMutableDictionary *getAppointments;
NSMutableDictionary *getConversation;
NSMutableDictionary *getallAppointments;;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    domainId=[NSString stringWithFormat:@"%d",1];
    domainURl=@"www.hexpress.net";
    getCustomerList=[[NSMutableDictionary alloc]init];
    getRegDetails=[[NSMutableDictionary alloc]init];
    getUnit=[[NSMutableDictionary alloc]init];
    getDates=[[NSMutableDictionary alloc]init];
    getProductInfo=[[NSMutableDictionary alloc]init];
    getAppointments=[[NSMutableDictionary alloc]init];
    getConversation=[[NSMutableDictionary alloc]init];
    getallAppointments=[[NSMutableDictionary alloc]init];
    isUnit=YES;
    
    [self internetCheck];
    self.viewController = [[LoginViewController alloc] init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = nav;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    [UIApplication sharedApplication].applicationIconBadgeNumber= 0;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"devide token is %@",deviceToken);
    UIDevice *dev = [UIDevice currentDevice];
    //NSString *deviceUuid;
    NSString *uuid=dev.uniqueDeviceIdentifier;
    NSLog(@"id is %@",uuid);
    NSString *tokenStr=[deviceToken description];
    NSString *pushToken = [[[tokenStr
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    
    NSUserDefaults *tokenString=[NSUserDefaults standardUserDefaults];
    [tokenString setObject:pushToken forKey:@"DeviceToken"];
    [tokenString synchronize];
    
    NSUserDefaults *deviceid=[NSUserDefaults standardUserDefaults];
    [deviceid setObject:uuid forKey:@"DeviceId"];
    [deviceid synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    NotificationViewController *notificationViewController = [[NotificationViewController alloc] init];
    [navController pushViewController:notificationViewController animated:YES];

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    //application.applicationIconBadgeNumber=0;
	NSLog(@"Failed to get token, error: %@", error);
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
        
         [self getUnitDetails];
        
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        
        [self getUnitDetails];
    }
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Get Unit Details Web Service
/////////////////////////////////////////////////////////////////////////////////

-(void)getUnitDetails
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/getHeightWeight", domainURl]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    [request setDelegate:self];
    [request startSynchronous];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - ASIFormData Request Started
/////////////////////////////////////////////////////////////////////////////////

- (void)requestStarted:(ASIHTTPRequest *)request
{
    //start activity indicator on download start
    
}


//////////////////////////////////////////////////////////////////////////////////
#pragma mark - ASIHttpData Request Finished
/////////////////////////////////////////////////////////////////////////////////

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSString *str=[request responseString];
    //NSLog(@"XML response is %@",str);
    NSDictionary *responseDictionary = [[request responseString] JSONValue];
    NSLog(@"dict is %@",responseDictionary);
    if(isUnit==YES)
    {
      isUnit=NO;
      [[LoginAppDelegate getUnitDetails]setObject:[responseDictionary objectForKey:@"posts"] forKey:@"UnitDetails"];
      NSLog(@"response is %@",[[LoginAppDelegate getUnitDetails]objectForKey:@"UnitDetails"]);
        //[self getCalendar];
        [self getLiveDoctor];
    }
//    else if(isCalendar==YES)
//    {
//        isCalendar=NO;
//        [[LoginAppDelegate getCalendar]setObject:[responseDictionary objectForKey:@"posts"] forKey:@"CalendarDetails"];
//        NSLog(@"response1 is %@",[[LoginAppDelegate getCalendar]objectForKey:@"CalendarDetails"]);
//        [self getLiveDoctor];
//    }
    
    else if(isLiveDoctor==YES)
    {
        isLiveDoctor=NO;
        [[LoginAppDelegate getLiveDoctor]setObject:[responseDictionary objectForKey:@"posts"] forKey:@"LiveDetails"];
        NSLog(@"response2 is %@",[[[[LoginAppDelegate getLiveDoctor]objectForKey:@"LiveDetails"]valueForKey:@"result"]objectAtIndex:0]);
        
    }
    
    
}

////////////////////////////////////////////////////////////////////////////////////
//#pragma mark -  Get Calendar Details Web Service
///////////////////////////////////////////////////////////////////////////////////
//
//- (void)getCalendar
//{
//    isCalendar=YES;
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/getCalendar", domainURl]];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setRequestMethod:@"POST"];
//    [request addRequestHeader:@"Accept" value:@"application/json"];
//    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
//    [request setDelegate:self];
//    [request startSynchronous];
//}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark -  Get Live Doctor Details Web Service
/////////////////////////////////////////////////////////////////////////////////

- (void)getLiveDoctor
{
    isLiveDoctor=YES;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/getLiveDoctorInfo", domainURl]];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    NSString *dataString = [NSString stringWithFormat:@"app=%@&id=%@",kappname ,domainId ];
    
    NSMutableData *requestBody = [[NSMutableData alloc] initWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    [request setPostBody:requestBody];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    [request setDelegate:self];
    [request startSynchronous];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(NSMutableDictionary *)getCustomerInfo
{
    
    return getCustomerList;
    
}

+(NSMutableDictionary *)getRegistrationDetails
{
    
    return getRegDetails;
    
}

+(NSMutableDictionary *)getUnitDetails
{
    
    return getUnit;
    
}

+(NSMutableDictionary *)getCalendar
{
    
    return getDates;
    
}

+(NSMutableDictionary *)getLiveDoctor
{
    
    return getProductInfo;
    
}

+(NSMutableDictionary *)getBookedAppointments
{
    
    return getAppointments;
    
}

+(NSMutableDictionary *)getEmailConversation
{
    
    return getConversation;
    
}

+(NSMutableDictionary *)getAVAppointments
{
    
    return getallAppointments;
    
}

@end

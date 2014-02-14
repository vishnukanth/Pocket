//
//  EmailConversation.h
//  PocketDoctor
//
//  Created by vishnu on 10/12/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAppDelegate.h"
#import "HPGrowingTextView.h"


@interface EmailConversation : UIViewController<UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate>
{
    LoginAppDelegate *appDelegate;
    UIImageView *backBtn;
    UIButton *backBtnTitle;
    UIActivityIndicatorView *activityView;
    UIView *loadingView;
    UILabel *loadingLabel;
    UITableView *conversationTableView;
    UIView *containerView;
    HPGrowingTextView *textView;
    NSString *appoinId;
}
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf;

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array;
-(UIView *)assembleMessageAtIndex : (NSString *) message from: (BOOL)fromself;

-(id)initWithNibName:(NSString*)appointmentId;
@end

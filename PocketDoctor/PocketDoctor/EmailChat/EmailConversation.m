//
//  EmailConversation.m
//  PocketDoctor
//
//  Created by vishnu on 10/12/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import "EmailConversation.h"
#import "UIColor+UIColorCategory.h"
#import "JSON.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"
@interface EmailConversation ()

@end

@implementation EmailConversation

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

-(id)initWithNibName:(NSString*)appointmentId
{
    if(self)
    {
        appoinId=appointmentId;
        
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
    [self setUpTextFieldforIphone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    conversationTableView=[[UITableView alloc]initWithFrame:CGRectMake(20, 40, 290, 390) style:UITableViewStylePlain];
    conversationTableView.delegate=self;
    conversationTableView.dataSource=self;
    conversationTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:conversationTableView];
    // Do any additional setup after loading the view from its nib.
}


//////////////////////////////////////////////////////////////////////////////////
#pragma mark - setup TextView
/////////////////////////////////////////////////////////////////////////////////

- (void)setUpTextFieldforIphone {
    //	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    //    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1];
	
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-40, 320, 40)];
    
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	textView.returnKeyType = UIReturnKeyGo; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Type to see the textView grow!";
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
    //    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    //    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"Send" forState:UIControlStateNormal];
    doneBtn.layer.cornerRadius=5;
    // [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    // doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundColor:[UIColor colorWithHexString:@"#F68213"]];
    //    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    //    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - resigningTextView
/////////////////////////////////////////////////////////////////////////////////

-(void)resignTextView
{
    [self internetCheck];
	
}


//////////////////////////////////////////////////////////////////////////////////
#pragma mark - KeyBoardShow
/////////////////////////////////////////////////////////////////////////////////

-(void)scrollTableview
{
    [conversationTableView reloadData];
    int lastSection=[conversationTableView numberOfSections]-1;
    int lastRowNumber = [conversationTableView numberOfRowsInSection:lastSection]-1;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:lastSection];
    [conversationTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}



-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
     [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    // get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
    CGRect tableviewframe=conversationTableView.frame;
    tableviewframe.size.height-=220;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	containerView.frame = containerFrame;
    conversationTableView.frame=tableviewframe;
    
	[UIView commitAnimations];
//	CGRect keyboardBounds;
//    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    
//    // Need to translate the bounds to account for rotation.
//    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
//    
//	// get a rect for the textView frame
//	CGRect containerFrame = containerView.frame;
//    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
//	// animations settings
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
//	
//	// set views with new info
//	containerView.frame = containerFrame;
//    
//	
//	// commit animations
//	[UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - KeyBoardHide
/////////////////////////////////////////////////////////////////////////////////

-(void) keyboardWillHide:(NSNotification *)note{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    CGRect tableviewframe=conversationTableView.frame;
    tableviewframe.size.height+=200;
    
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	// set views with new info
    conversationTableView.frame=tableviewframe;
	containerView.frame = containerFrame;
	// commit animations
	[UIView commitAnimations];
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//	
//	// get a rect for the textView frame
//	CGRect containerFrame = containerView.frame;
//    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
//	
//	// animations settings
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
//    
//	// set views with new info
//	containerView.frame = containerFrame;
//	
//	// commit animations
//	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
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
        
        [self saveMessage];
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        
        [self saveMessage];
    }
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Sende Email Message to server
/////////////////////////////////////////////////////////////////////////////////

-(void)saveMessage
{
    if(textView.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter some message." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/service/api/SaveMessage",[appDelegate domainURl]]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:[appDelegate domainId] forKey:kDomainId];
        [request setPostValue:[[[[LoginAppDelegate getCustomerInfo]objectForKey:@"CustomerDetails"]valueForKey:@"cust_details"]valueForKey:@"cust_id"] forKey:kcid];
        [request setPostValue:textView.text forKey:kecText];
        [request setPostValue:appoinId forKey:@"appointment_id"];
        [request setPostValue:kappname forKey:kapp];
        [request setRequestMethod:@"POST"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
        [request setDelegate:self];
        [request startSynchronous];

    }
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
        [textView resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
    //NSLog(@"response is %@",responseDictionary);
}

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Alert View Delegate Method
/////////////////////////////////////////////////////////////////////////////////

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==2222)
    {
        if(buttonIndex==0)
        {
            [self internetCheck];
        }
    }
    
    
}

////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view datasource
////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [[[[LoginAppDelegate getEmailConversation]objectForKey:@"Conversation"] valueForKey:@"result"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UIImageView *balloonView;
    UILabel *label;
    UIImageView *userView;
    UIImageView *doctorView;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
        balloonView.tag = 1;
        
        userView = [[UIImageView alloc] initWithFrame:CGRectZero];
        userView.tag = 3;
        
        doctorView = [[UIImageView alloc] initWithFrame:CGRectZero];
        doctorView.tag = 4;
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 2;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont systemFontOfSize:14.0];
        
        UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
        message.tag = 0;
        [message addSubview:balloonView];
        [message addSubview:userView];
        [message addSubview:doctorView];
        [message addSubview:label];
        [cell.contentView addSubview:message];
        
        
    }
    else
    {
        balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
        
        label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
    }
    
    NSString *text = [[[[[LoginAppDelegate getEmailConversation]objectForKey:@"Conversation"] valueForKey:@"result"] objectAtIndex:indexPath.row]valueForKey:@"ec_text"];
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    UIImage *balloon;
    UIImage *user;
    UIImage *doctor;
    
    
   
    if([[[[[[LoginAppDelegate getEmailConversation]objectForKey:@"Conversation"] valueForKey:@"result"] objectAtIndex:indexPath.row]valueForKey:@"ec_by"]isEqualToString:@"D"])
    {
        doctorView=(UIImageView*)[[cell.contentView viewWithTag:0]viewWithTag:4];
        balloon = [[UIImage imageNamed:@"bubbleFlatOut.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        doctor=[UIImage imageNamed:@"dr-small-photo.png"];
        doctorView.frame=CGRectMake(-2, 2, doctor.size.width, doctor.size.height);
        doctorView.image=doctor;
         balloonView.frame = CGRectMake(30.0, 2.0, size.width + 28, size.height + 15);
        label.frame = CGRectMake(50, 8, size.width + 5, size.height);
    }
    else
    {
        //doctorView.hidden=YES;
//        user=[UIImage imageNamed:@"dr-small-photo.png"];
//        userView.frame=CGRectMake(120, 2, user.size.width, user.size.height);
//        userView.image=user;
        balloon = [[UIImage imageNamed:@"bubbleFlatIn.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        balloonView.frame = CGRectMake(2.0, 2.0, size.width + 28, size.height + 15);
        label.frame = CGRectMake(14, 8, size.width + 5, size.height);
    }
    
    
    
    
    balloonView.image = balloon;
    label.text = text;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *body = [[[[[LoginAppDelegate getEmailConversation]objectForKey:@"Conversation"] valueForKey:@"result"] objectAtIndex:indexPath.row]valueForKey:@"ec_text"];
    CGSize size = [body sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0, 480.0) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 15;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
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

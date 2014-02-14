//
//  RegistrationViewController.h
//  PocketDoctor
//
//  Created by vishnu on 18/11/13.
//  Copyright (c) 2013 HexpressHealthCare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAppDelegate.h"

@interface RegistrationViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate>
{
    UIView *customView;
    LoginAppDelegate *appDelegate;
    UIScrollView  *scrollview;
    UIImageView *backBtn;
    
    UIButton *backBtnTitle;
    UIButton *btnDone;
    UIButton *btnNext;
    UIButton *btnPrev;
    UIButton *submitButton;
    
    UITextField *txtActiveField;
    UITextField *FNTextField;
    UITextField *LNTextField;
    UITextField *emailTextField;
    UITextField *passwordTextField;
    UITextField *conPasswordTextField;
    
    UIView *customPickerView;
    UIDatePicker *DatepickerView;
    UIPickerView *genderpicker;
    UIPickerView *heightPicker;
    UIPickerView *weightPicker;
    UIPickerView *BPPicker;
    UIPickerView *heightCentiPicker;
    UIPickerView *FeetPicker;
    UIPickerView *InchPicker;
    UIPickerView *OnlyInchPicker;
    UIPickerView *metrePicker;
    UIPickerView *KGPicker;
    UIPickerView *stonePicker;
    UIPickerView *LbsPicker;
    UIPickerView *poundPicker;
    UIView *inputAccView;
    
    NSString *fName;
    NSString *lName;
    NSString *username;
    NSString *password ;
    NSString *conPassword;
    NSString *gender;
    NSString   *dob;
    NSString *subtodicuss;
    NSString *currentmedication;
    NSString *heightunit;
    NSString *weightunit;
    NSString *heightvalue;
    NSString *weightvalue;
    NSString *BPvalue;
    NSString *phone;
   
    
    NSMutableArray *genderArray;
    NSMutableArray *heightUnitArray;
    NSMutableArray *weightUnitArray;
    NSMutableArray *BPArray;
    
    BOOL isProfile;
    BOOL isGrid;
    BOOL isMoved;
}
@property(nonatomic,assign)BOOL isGrid;
-(id)initWithNibName:(NSString*)email;
@end

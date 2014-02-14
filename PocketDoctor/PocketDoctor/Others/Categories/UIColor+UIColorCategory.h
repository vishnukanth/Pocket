//
//  UIColor+UIColorCategory.h
//  euroClinix
//
//  Created by vishnu on 18/06/12.
//  Copyright (c) 2012 DSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColorCategory)
+ (UIColor *)colorWithHex:(UInt32)col;

+ (UIColor *)colorWithHexString:(NSString *)str;
@end

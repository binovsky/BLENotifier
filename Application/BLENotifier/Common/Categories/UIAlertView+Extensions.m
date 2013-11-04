//
//  UIAlertView+Extensions.m
//  BLENotifier
//
//  Created by Michal Binovsky on 04/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "UIAlertView+Extensions.h"

@implementation UIAlertView (Extensions)

+ (void)showSimpleAlertWithTitle:(NSString *)title message:(NSString *)message andCancelButtonTitle:(NSString *)cancelBtnText
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelBtnText otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end

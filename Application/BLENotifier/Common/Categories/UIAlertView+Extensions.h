//
//  UIAlertView+Extensions.h
//  BLENotifier
//
//  Created by Michal Binovsky on 04/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Extensions)

+ (void)showSimpleAlertWithTitle:(NSString *)title message:(NSString *)message andCancelButtonTitle:(NSString *)cancelBtnText;

@end

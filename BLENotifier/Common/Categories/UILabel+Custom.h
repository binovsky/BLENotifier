//
//  UIFont+Custom.h
//  BLENotifier
//
//  Created by Michal Binovsky on 25/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum EFontType_
{
	FontTypeRegular			= 0,
	FontTypeBold			= 1,
	FontTypeItalic			= 2
}EFontType;

@interface UILabel (CustomFont)

- (UIFont *)customFont;

@end

@interface UIFont (CustomFont)



@end


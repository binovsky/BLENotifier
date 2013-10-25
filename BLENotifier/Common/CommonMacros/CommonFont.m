//
//  CommonFont.m
//  BLENotifier
//
//  Created by Michal Binovsky on 25/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "CommonFont.h"

// FONT
CGFloat		const DEFAULT_FONT_SIZE								= 16.f;
NSString*	const DEFAULT_FONT_NAME								= @"OpenSans-CondensedLight";
NSString*	const DEFAULT_BOLD_FONT_NAME						= @"OpenSans-CondensedBold";
NSString*	const DEFAULT_ITALIC_FONT_NAME						= @"OpenSans-CondensedLightItalic";

UIFont* GET_DEFAULT_FONT(NSString* strFontName, int nSize)
{
    return nSize ? [UIFont fontWithName:strFontName size:nSize] : [UIFont fontWithName:strFontName size:DEFAULT_FONT_SIZE];
}
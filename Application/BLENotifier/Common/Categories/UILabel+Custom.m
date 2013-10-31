//
//  UIFont+Custom.m
//  BLENotifier
//
//  Created by Michal Binovsky on 25/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "UILabel+Custom.h"
#import <objc/runtime.h>
#import <objc/message.h>

#pragma GCC diagnostic ignored "-Wwarning-flag"

static NSString *const FONT_TYPE_KEY	= @"FontType";

@implementation UILabel (CustomFont)

- (UIFont *)customFont
{
	UIFont *fnt = [self customFont];
	CGFloat fontSize = [fnt pointSize];
	
	NSNumber *numFontType = (NSNumber *)objc_getAssociatedObject( fnt, FONT_TYPE_KEY );
	EFontType fontType = (EFontType)[numFontType intValue];
	
	NSString *rtnFontName = nil;
	
	switch ( fontType )
	{
		case FontTypeBold:
		{
			rtnFontName = DEFAULT_BOLD_FONT_NAME;
		}
			break;
			
		case FontTypeItalic:
		{
			rtnFontName = DEFAULT_ITALIC_FONT_NAME;
		}
			break;
			
		default:
		{
			rtnFontName = DEFAULT_FONT_NAME;
		}
			break;
	}
	
	return [UIFont fontWithName:rtnFontName size:fontSize];
}

@end

@implementation UIFont (CustomFont)

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize
{
	UIFont *font = [UIFont fontWithName:DEFAULT_FONT_NAME size:fontSize];
	
	objc_setAssociatedObject( font, FONT_TYPE_KEY, @( FontTypeRegular ), OBJC_ASSOCIATION_ASSIGN );
	
	return font;
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize
{
	UIFont *font = [UIFont fontWithName:DEFAULT_BOLD_FONT_NAME size:fontSize];
	
	objc_setAssociatedObject( font, FONT_TYPE_KEY, @( FontTypeBold ), OBJC_ASSOCIATION_ASSIGN );
	
	return font;
}

+ (UIFont *)italicSystemFontOfSize:(CGFloat)fontSize
{
	UIFont *font = [UIFont fontWithName:DEFAULT_ITALIC_FONT_NAME size:fontSize];
	
	objc_setAssociatedObject( font, FONT_TYPE_KEY, @( FontTypeItalic ), OBJC_ASSOCIATION_ASSIGN );
	
	return font;
}

@end

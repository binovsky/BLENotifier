//
//  ContentView.m
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "BarItemView.h"


const CGFloat   STATUS_BAR_ITEM_IMG_OFFSET      = 10.f;

@interface BarItemView()
{
    BOOL _bSelected;
    NSImage *_img;
    NSImage *_imgSelected;
    NSImageView *_imgView;
}

@end

@implementation BarItemView

- (id)init
{
    if ( ( self = [super init] ) )
    {
        [self initDefaults];
    }
    
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE( _img );
    SAFE_RELEASE( _imgSelected );
    SAFE_RELEASE( _imgView );
    
    [super dealloc];
}

#pragma mark - @Override
- (void)mouseDown:(NSEvent *)theEvent
{
    _bSelected = !_bSelected;
    [self setNeedsDisplay:YES];
    
    if ( _bSelected )
    {
        if ( [_barViewDelegate respondsToSelector:@selector(barItemViewShouldShow:)] )
            [_barViewDelegate barItemViewShouldShow:self];
        else
            [NSException raise:@"RequiredDelegateMethodNotImplemebted" format:@"BarItemViewDelegate require to implement method 'barItemViewSelected:' "];
    }
    else
    {
        if ( [_barViewDelegate respondsToSelector:@selector(barItemViewShouldHide:)] )
            [_barViewDelegate barItemViewShouldHide:self];
        else
            [NSException raise:@"RequiredDelegateMethodNotImplemebted" format:@"BarItemViewDelegate require to implement method 'barItemViewSelected:' "];
    }
}


- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    NSRect fullBounds = [self bounds];
    fullBounds.size.height += 4;
    [[NSBezierPath bezierPathWithRect:fullBounds] setClip];
    
    // Then do your drawing, for example...
    
    ( _bSelected ) ? [[NSColor colorWithSRGBRed:0.3f green:0.68f blue:0.93f alpha:0.8f] set] : [[NSColor clearColor] set];
    NSRectFill( fullBounds );
}

#pragma mark - @Custom
- (void)initDefaults
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    _bSelected = NO;
    
    _img = [[NSImage imageNamed:@"ble_icon"] retain];
    _imgSelected = [[NSImage imageNamed:@"ble_icon_selected"] retain];
    
    CGFloat imgHeight = [NSStatusBar systemStatusBar].thickness;
    CGFloat imgWidth = [_img size].width;
    
    _imgView = [[NSImageView alloc] init];
    [_imgView setImage:_img];
    [_imgView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_imgView addConstraint:[NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:imgHeight]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:imgWidth + ( 2 * STATUS_BAR_ITEM_IMG_OFFSET )]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:imgHeight]];
    [self addSubview:_imgView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(IMG_OFFSET)-[_imgView]-(IMG_OFFSET)-|" options:0 metrics:@{ @"IMG_OFFSET" : @( STATUS_BAR_ITEM_IMG_OFFSET ) } views:NSDictionaryOfVariableBindings( _imgView )]];
}

@end

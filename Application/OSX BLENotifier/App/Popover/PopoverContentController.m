//
//  PopoverContentController.m
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "PopoverContentController.h"
#import <App/Popover/Views/PopoverContentView.h>

@interface PopoverContentController ()

@end

@implementation PopoverContentController

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
    SAFE_RELEASE( _core );
    
    [super dealloc];
}


#pragma mark - @Override
- (void)loadView
{
    _ASSERT( _core );
    
    PopoverContentView *v = [PopoverContentView new];
    [v setContentViewDelegate:self];
    
    [v addConstraint:[NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:200.f]];
    [v addConstraint:[NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:100.f]];
    
    [self setView:[v autorelease]];
    [[self view] setTranslatesAutoresizingMaskIntoConstraints:NO];
}

#pragma mark - @Custom
- (void)initDefaults
{
    _ASSERT( !_core );
    
    _core = [[NotifierCore instance] retain];
    [_core initBeacon];
}

- (void)startBeaconSearching:(id)sender
{
    _ASSERT( _core );
    
    [_core startCentralRoleSession];
}

#pragma mark - PopoverContentViewDelegate
- (void)popoverContentView:(PopoverContentView *)popover startSeekingButtonTapped:(NSButton *)btn
{
    [self startBeaconSearching:btn];
}

@end

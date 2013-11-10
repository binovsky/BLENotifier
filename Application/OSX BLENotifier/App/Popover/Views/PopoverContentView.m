//
//  PopoverContentView.m
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "PopoverContentView.h"

@implementation PopoverContentView

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
    SAFE_RELEASE( _startSeekingBtn );
    
    [super dealloc];
}

//- (void)drawRect:(NSRect)dirtyRect
//{
//	[super drawRect:dirtyRect];
//	
//    // Drawing code here.
//}
#pragma mark - @Overide


#pragma mark - @Custom
- (void)initDefaults
{
    _ASSERT( !_startSeekingBtn );
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _startSeekingBtn = [[NSButton alloc] init];
    [_startSeekingBtn setTitle:@"Start search for beacons"];
    [_startSeekingBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_startSeekingBtn setBezelStyle:NSRoundRectBezelStyle];
    [_startSeekingBtn setBordered:YES];
    [_startSeekingBtn setTarget:self];
    [_startSeekingBtn setAction:@selector(startSeekingBtnTapped:)];
    [self addSubview:_startSeekingBtn];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_startSeekingBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_startSeekingBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
}

- (void)startSeekingBtnTapped:(id)sender
{
    _ASSERT( [sender isEqual:_startSeekingBtn] );
    
    if ( [[self contentViewDelegate] respondsToSelector:@selector(popoverContentView:startSeekingButtonTapped:)] )
        [[self contentViewDelegate] popoverContentView:self startSeekingButtonTapped:_startSeekingBtn];
    else
        [NSException raise:@"RequiredDelegateMethodNotImplemebted" format:@"PopoverContentViewDelegate require to implement method 'popoverContentView:startSeekingButtonTapped:'"];
}

@end

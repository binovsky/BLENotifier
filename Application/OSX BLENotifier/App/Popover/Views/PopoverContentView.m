//
//  PopoverContentView.m
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "PopoverContentView.h"

const CGFloat kActivityIndicatorSize = 30.f;
const CGFloat kPeripheralListTableWidth = 180.f;
const CGFloat kPeripheralListTableHeight = 95.f;
const CGFloat kPeripheralListTableRowHeight = 35.f;

@interface PopoverContentView()
{
    NSLayoutConstraint *_seekingBtnCenterX;
    NSLayoutConstraint *_seekingBtnCenterY;
    
    NSLayoutConstraint *_searchingIndicatorCenterX;
    NSLayoutConstraint *_searchingIndicatorCenterY;
    
    NSLayoutConstraint *_peripheralTableCenterX;
    NSLayoutConstraint *_peripheralTableCenterY;
}

@end

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
    SAFE_RELEASE( _seekingBtnCenterX );
    SAFE_RELEASE( _seekingBtnCenterY );
    SAFE_RELEASE( _searchingPeripheralsIndicator );
    SAFE_RELEASE( _searchingIndicatorCenterX );
    SAFE_RELEASE( _searchingIndicatorCenterY );
    SAFE_RELEASE( _peripheralsTable );
    SAFE_RELEASE( _peripheralTableCenterX );
    SAFE_RELEASE( _peripheralTableCenterY );
    
    [super dealloc];
}

#pragma mark - @Overide
//- (void)drawRect:(NSRect)dirtyRect
//{
//	[super drawRect:dirtyRect];
//
//    // Drawing code here.
//}

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
    
    _searchingPeripheralsIndicator = [[ProgressIndicator alloc] init];
    [_searchingPeripheralsIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_searchingPeripheralsIndicator setStyle:NSProgressIndicatorSpinningStyle];
    [_searchingPeripheralsIndicator addConstraint:[NSLayoutConstraint constraintWithItem:_searchingPeripheralsIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:kActivityIndicatorSize]];
    [_searchingPeripheralsIndicator addConstraint:[NSLayoutConstraint constraintWithItem:_searchingPeripheralsIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:kActivityIndicatorSize]];
    
    _peripheralsTable = [[NSTableView alloc] init];
    [_peripheralsTable setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_peripheralsTable addConstraint:[NSLayoutConstraint constraintWithItem:_peripheralsTable attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:kPeripheralListTableWidth]];
    [_peripheralsTable addConstraint:[NSLayoutConstraint constraintWithItem:_peripheralsTable attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:kPeripheralListTableHeight]];
    
    
    // DEFAULT APPEREANCE
    [self startSeekingAppereance];
}

- (void)startSeekingBtnTapped:(id)sender
{
    _ASSERT( [sender isEqual:_startSeekingBtn] );
    
    if ( [[self contentViewDelegate] respondsToSelector:@selector(popoverContentView:startSeekingButtonTapped:)] )
        [[self contentViewDelegate] popoverContentView:self startSeekingButtonTapped:_startSeekingBtn];
    else
        [NSException raise:@"RequiredDelegateMethodNotImplemebted" format:@"PopoverContentViewDelegate require to implement method 'popoverContentView:startSeekingButtonTapped:'"];
}

- (void)startSeekingAppereance
{
    _ASSERT( _startSeekingBtn );
    
    [self cleanupInterface];
    
    if ( [_startSeekingBtn superview] == nil )
        [self addSubview:_startSeekingBtn];
    
    if ( !_seekingBtnCenterX )
        _seekingBtnCenterX = [[NSLayoutConstraint constraintWithItem:_startSeekingBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f] retain];
        
    [self addConstraint:_seekingBtnCenterX];
    
    if ( !_seekingBtnCenterY )
        _seekingBtnCenterY = [[NSLayoutConstraint constraintWithItem:_startSeekingBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f] retain];
    
    [self addConstraint:_seekingBtnCenterY];
}

- (void)searchingForPeripheralsAppereance
{
    _ASSERT( _searchingPeripheralsIndicator );
    
    [self cleanupInterface];
    
    if ( [_searchingPeripheralsIndicator superview] == nil )
        [self addSubview:_searchingPeripheralsIndicator];
    
    [_searchingPeripheralsIndicator startAnimation:self];
    
    if ( !_searchingIndicatorCenterX )
        _searchingIndicatorCenterX = [[NSLayoutConstraint constraintWithItem:_searchingPeripheralsIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f] retain];
    
    [self addConstraint:_searchingIndicatorCenterX];
        
    if ( !_searchingIndicatorCenterY )
        _searchingIndicatorCenterY = [[NSLayoutConstraint constraintWithItem:_searchingPeripheralsIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f] retain];
    
    [self addConstraint:_searchingIndicatorCenterY];
}

- (void)peripheralListAppereance
{
    _ASSERT( _peripheralsTable );
    
    [self cleanupInterface];
    
    if ( [_peripheralsTable superview] == nil )
        [self addSubview:_peripheralsTable];
    
    [_peripheralsTable setDelegate:self];
    
    if ( [[self contentViewDelegate] respondsToSelector:@selector(popoverContentViewPeripheralsListDataSource)] )
        [_peripheralsTable setDataSource:[[self contentViewDelegate] popoverContentViewPeripheralsListDataSource]];
    else
        [NSException raise:@"RequiredDelegateMethodNotImplemebted" format:@"PopoverContentViewDelegate require to implement method 'popoverContentViewPeripheralsListDataSource'"];
    
    if ( !_peripheralTableCenterX )
        _peripheralTableCenterX = [[NSLayoutConstraint constraintWithItem:_peripheralsTable attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f] retain];;
    
    [self addConstraint:_peripheralTableCenterX];
        
    if ( !_peripheralTableCenterY )
        _peripheralTableCenterY = [[NSLayoutConstraint constraintWithItem:_peripheralsTable attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f] retain];;
    
    [self addConstraint:_peripheralTableCenterY];
}

- (void)cleanupInterface
{
    _ASSERT( _startSeekingBtn );
    _ASSERT( _searchingPeripheralsIndicator );
    _ASSERT( _peripheralsTable );
    
    if ( [_startSeekingBtn superview] )
    {
        [_startSeekingBtn removeFromSuperview];
        [self removeConstraints:@[_seekingBtnCenterX, _seekingBtnCenterY]];
    }
    
    if ( [_searchingPeripheralsIndicator superview] )
    {
        [_searchingPeripheralsIndicator stopAnimation:self];
        [_searchingPeripheralsIndicator removeFromSuperview];
        [self removeConstraints:@[_searchingIndicatorCenterX, _searchingIndicatorCenterY]];
    }
    
    if ( [_peripheralsTable superview] )
    {
        [_peripheralsTable setDelegate:nil];
        [_peripheralsTable setDataSource:nil];
        [_peripheralsTable removeFromSuperview];
        [self removeConstraints:@[_peripheralTableCenterX, _peripheralTableCenterY]];
    }
}

#pragma mark - NSTableViewDelegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return kPeripheralListTableRowHeight;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTextField *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    [result setStringValue:@"aaaaaa"];
    
    return result;
}

@end

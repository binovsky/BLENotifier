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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDiscoveredPeripheral:) name:CentralDidDiscoverPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectPeripheral:) name:CentralDidConnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDisconnectPeripheral:) name:CentralDidDisconnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailToConnectPeripheral:) name:CentralDidFailConnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFoundPeripheralServices:) name:CentralDidFoundPeripheralServices object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotFoundPeripheralServices:) name:CentralDidNotFoundPeripheralServices object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFoundServiceCharactestics:) name:CentralDidFoundPeripheralServiceCharacteristics object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotFoundServiceCharactestics:) name:CentralDidNotFoundPeripheralServiceCharacteristics object:nil];
    
    _core = [[NotifierCore instance] retain];
    [_core initBeacon];
}

- (void)startBeaconSearching:(id)sender
{
    _ASSERT( _core );
    
    [_core startCentralRoleSession];
    
    [(PopoverContentView *)[self view] searchingForPeripheralsAppereance];
}

#pragma mark - PopoverContentViewDelegate
- (void)popoverContentView:(PopoverContentView *)popover startSeekingButtonTapped:(NSButton *)btn
{
    [self startBeaconSearching:btn];
}

 - (id<NSTableViewDataSource>)popoverContentViewPeripheralsListDataSource
{
    return self;
}

#pragma mark - Core Central role notificaitons
- (void)didDiscoveredPeripheral:(NSNotification *)aNotification
{
    DLog( @"%@", NSStringFromSelector( _cmd ) );
    [(PopoverContentView *)[self view] peripheralListAppereance];
}

- (void)didConnectPeripheral:(NSNotification *)aNotification
{
    DLog( @"%@", NSStringFromSelector( _cmd ) );
}

- (void)didDisconnectPeripheral:(NSNotification *)aNotification
{
    DLog( @"%@", NSStringFromSelector( _cmd ) );
}

- (void)didFailToConnectPeripheral:(NSNotification *)aNotification
{
    DLog( @"%@", NSStringFromSelector( _cmd ) );
}

- (void)didFoundPeripheralServices:(NSNotification *)aNotification
{
    DLog( @"%@", NSStringFromSelector( _cmd ) );
}

- (void)didNotFoundPeripheralServices:(NSNotification *)aNotification
{
    DLog( @"%@", NSStringFromSelector( _cmd ) );
}

- (void)didFoundServiceCharactestics:(NSNotification *)aNotification
{
    DLog( @"%@", NSStringFromSelector( _cmd ) );
}

- (void)didNotFoundServiceCharactestics:(NSNotification *)aNotification
{
    DLog( @"%@", NSStringFromSelector( _cmd ) );
}

#pragma mark - NSTableViewDataSource
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    return @"AAAAAAA";
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [[_core peripherals] count];
}

@end

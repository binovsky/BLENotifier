//
//  RootController.m
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "RootController.h"

@interface RootController ()

@end

@implementation RootController

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
    SAFE_RELEASE( _statusBar );
    SAFE_RELEASE( _statusItem );
    SAFE_RELEASE( _statusMenu );
    SAFE_RELEASE( _barView );
    SAFE_RELEASE( _popover );
    SAFE_RELEASE( _popoverContentController );
    
    [super dealloc];
}


#pragma mark - @Override
- (void)loadView
{
    _ASSERT( _core );
    _ASSERT( _statusBar );
    
    _barView = [[[BarItemView alloc] init] autorelease];
    [_barView setBarViewDelegate:self];
    
    _statusItem = [[_statusBar statusItemWithLength:NSVariableStatusItemLength] retain];
    [_statusItem setView:_barView];
    
    _statusMenu = [[NSMenu alloc] initWithTitle:@"BLENotifier"];
    [_statusMenu setAutoenablesItems:NO];
    [_statusMenu setDelegate:self];
    
    [_statusItem setMenu:_statusMenu];
}

#pragma mark - @Custom
- (void)initDefaults
{
    _ASSERT( !_core );
    _ASSERT( !_statusBar );
    _ASSERT( !_popover );
    _ASSERT( !_popoverContentController );
    
    _core = [NotifierCore instance];
    _statusBar = [[NSStatusBar systemStatusBar] retain];

    _popoverContentController = [[PopoverContentController alloc] init];
    
    _popover = [[NSPopover alloc] init];
    [_popover setAnimates:YES];
    
    [_popover setContentViewController:_popoverContentController];
}

- (void)startBeaconSearching:(id)sender
{
    _ASSERT( _core );
    
    [_core initBeacon];
    [_core startCentralRoleSession];
}

#pragma mark - BarItemViewDelegate
- (void)barItemViewShouldShow:(BarItemView *)barView
{
    _ASSERT( [barView isEqual:_barView] );
    
    
    [_popover showRelativeToRect:[_barView frame] ofView:_barView preferredEdge:NSMinYEdge];
}

- (void)barItemViewShouldHide:(BarItemView *)barView
{
    _ASSERT( [barView isEqual:_barView] );
    _ASSERT( _popover );
    _ASSERT( _popoverContentController );
    
    [_popover setAnimates:YES];
    [_popover close];
}

@end

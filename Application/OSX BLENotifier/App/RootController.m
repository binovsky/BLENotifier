//
//  RootController.m
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "RootController.h"
#import <App/Views/NotifierItem.h>

@interface RootController ()

@end

@implementation RootController

- (id)init
{
    if ( ( self = [super init] ) )
    {
        _core = [NotifierCore instance];
        _statusBar = [[NSStatusBar systemStatusBar] retain];
    }
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE( _core );
    SAFE_RELEASE( _statusBar );
    SAFE_RELEASE( _statusItem );
    SAFE_RELEASE( _statusMenu );
    
    [super dealloc];
}

- (void)loadView
{
    _ASSERT( _core );
    _ASSERT( _statusBar );
    
    _statusItem = [[_statusBar statusItemWithLength:NSVariableStatusItemLength] retain];
    [_statusItem setImage:[NSImage imageNamed:@"ble_icon"]];
    [_statusItem setHighlightMode:YES];
    
    _statusMenu = [[NSMenu alloc] initWithTitle:@"BLENotifier"];
    [_statusItem setMenu:_statusMenu];
    
    NotifierItem *item = [[NotifierItem alloc] init];
    
    
    [_statusMenu addItem:item];
}


- (void)startBeaconSearching:(id)sender
{
    _ASSERT( _core );
    
    [_core initBeacon];
    [_core startCentralRoleSession];

}

@end

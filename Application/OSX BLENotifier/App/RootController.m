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
    SAFE_RELEASE( _statusBar );
    SAFE_RELEASE( _statusItem );
    SAFE_RELEASE( _barView );
    SAFE_RELEASE( _popover );
    SAFE_RELEASE( _popoverContentController );
    SAFE_RELEASE( _secondaryMenu );
    
    [super dealloc];
}


#pragma mark - @Override
- (void)loadView
{
    _ASSERT( _statusBar );
    
    _barView = [[[BarItemView alloc] init] autorelease];
    [_barView setBarViewDelegate:self];
    
    _statusItem = [[_statusBar statusItemWithLength:NSVariableStatusItemLength] retain];
    [_statusItem setView:_barView];
    
    _secondaryMenu = [[NSMenu alloc] initWithTitle:@"SecondaryMenu"];
    [_secondaryMenu setAutoenablesItems:YES];
    [_secondaryMenu setDelegate:self];
    
    NSMenuItem *settingsItem = [[NSMenuItem alloc] initWithTitle:@"Settings ..." action:@selector(settingsItemTapped:) keyEquivalent:@","];
    [settingsItem setTarget:self];
    [settingsItem setAction:@selector(settingsItemTapped:)];
    [settingsItem setKeyEquivalentModifierMask:NSCommandKeyMask];

    NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:@"Quit Notifier" action:@selector(quitItemTapped:) keyEquivalent:@"q"];
    [quitItem setTarget:self];
    [quitItem setAction:@selector(quitItemTapped:)];
    [quitItem setKeyEquivalentModifierMask:NSCommandKeyMask];
    
    [_secondaryMenu addItem:settingsItem];
    [_secondaryMenu addItem:quitItem];
}

#pragma mark - @Custom
- (void)initDefaults
{
    _ASSERT( !_statusBar );
    _ASSERT( !_popover );
    _ASSERT( !_popoverContentController );
    
    _statusBar = [[NSStatusBar systemStatusBar] retain];

    _popoverContentController = [[PopoverContentController alloc] init];
    
    _popover = [[NSPopover alloc] init];
    [_popover setAnimates:YES];
    
    [_popover setContentViewController:_popoverContentController];
}

- (void)settingsItemTapped:(id)sender
{
    DLog( @"%@", NSStringFromSelector( _cmd ) );
}

- (void)quitItemTapped:(id)sender
{
    DLog( @"%@", NSStringFromSelector( _cmd ) );
}

#pragma mark - BarItemViewDelegate
- (void)barItemViewShouldShow:(BarItemView *)barView
{
    _ASSERT( [barView isEqual:_barView] );
    _ASSERT( _popover );
    _ASSERT( _popoverContentController );
    _ASSERT( _statusItem );
    _ASSERT( _secondaryMenu );
    
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

- (void)barItemViewSecondaryShouldShow:(BarItemView *)barView
{
    _ASSERT( [barView isEqual:_barView] );
    _ASSERT( _statusItem );
    _ASSERT( _secondaryMenu );
    

    [_statusItem popUpStatusItemMenu:_secondaryMenu];
}

- (void)barItemViewSecondaryShouldHide:(BarItemView *)barView
{
    _ASSERT( [barView isEqual:_barView] );
    _ASSERT( _statusItem );
    _ASSERT( _secondaryMenu );
    
    [_secondaryMenu cancelTracking];
}

#pragma mark - NSMenuDelegate
- (void)menuDidClose:(NSMenu *)menu
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BarSecondaryMenuDidCloseNotification object:nil];
}

@end

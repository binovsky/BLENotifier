//
//  RootController.h
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <App/Views/BarItemView.h>
#import <App/Popover/PopoverContentController.h>

#pragma mark - @Interface RootController
@interface RootController : NSViewController < NSMenuDelegate, BarItemViewDelegate >
{
    NotifierCore *_core;
    NSStatusBar *_statusBar;
    NSStatusItem * _statusItem;
    BarItemView *_barView;
    NSPopover *_popover;
    PopoverContentController *_popoverContentController;
    NSMenu *_secondaryMenu;
}

@end

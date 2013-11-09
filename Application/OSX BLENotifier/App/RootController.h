//
//  RootController.h
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RootController : NSViewController
{
    NotifierCore *_core;
    NSStatusBar *_statusBar;
    NSStatusItem * _statusItem;
    NSMenu *_statusMenu;
}

@end

//
//  PopoverContentController.h
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol PopoverContentViewDelegate;

@interface PopoverContentController : NSViewController < PopoverContentViewDelegate, NSTableViewDataSource >
{
    NotifierCore *_core;
}

@end

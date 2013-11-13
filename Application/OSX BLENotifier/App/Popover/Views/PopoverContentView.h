//
//  PopoverContentView.h
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ProgressIndicator.h"

@class PopoverContentView;

extern const CGFloat kActivityIndicatorSize;
extern const CGFloat kPeripheralListTableWidth;
extern const CGFloat kPeripheralListTableHeight;
extern const CGFloat kPeripheralListTableRowHeight;

#pragma mark - @Protocol PopoverContentView
@protocol PopoverContentViewDelegate <NSObject>

    @required
    - (void)popoverContentView:(PopoverContentView *)popover startSeekingButtonTapped:(NSButton *)btn;
    - (id<NSTableViewDataSource>)popoverContentViewPeripheralsListDataSource;

@end

#pragma mark - @Interface PopoverContentView
@interface PopoverContentView : NSView < NSTableViewDelegate >
{
    NSButton *_startSeekingBtn;
    ProgressIndicator *_searchingPeripheralsIndicator;
    NSTableView *_peripheralsTable;
}

    #pragma mark - @Properties
    @property ( nonatomic, assign ) id<PopoverContentViewDelegate>      contentViewDelegate;

    #pragma mark - @InstanceMethods
    - (void)startSeekingAppereance;
    - (void)searchingForPeripheralsAppereance;
    - (void)peripheralListAppereance;

@end

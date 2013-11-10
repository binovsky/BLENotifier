//
//  PopoverContentView.h
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PopoverContentView;

#pragma mark - @Protocol PopoverContentView
@protocol PopoverContentViewDelegate <NSObject>

    @required
    - (void)popoverContentView:(PopoverContentView *)popover startSeekingButtonTapped:(NSButton *)btn;

@end

#pragma mark - @Interface PopoverContentView
@interface PopoverContentView : NSView
{
    NSButton    *_startSeekingBtn;
}


    #pragma mark - @Properties
    @property ( nonatomic, assign ) id<PopoverContentViewDelegate>      contentViewDelegate;

@end

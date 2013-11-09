//
//  ContentView.h
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class BarItemView;

#pragma mark - @Protocol BarItemViewDelegate
@protocol BarItemViewDelegate

    @required
    - (void)barItemViewShouldShow:(BarItemView *)barView;
    - (void)barItemViewShouldHide:(BarItemView *)barView;

@end

#pragma mark - @Interface BarItemView
@interface BarItemView : NSView

    #pragma mark - @Properties
    @property ( nonatomic, assign ) id<BarItemViewDelegate>     barViewDelegate;

@end

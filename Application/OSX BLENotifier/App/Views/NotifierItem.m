//
//  NotifierItem.m
//  BLENotifier
//
//  Created by Michal Binovsky on 09/11/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "NotifierItem.h"
#import "ContentView.h"

@interface NotifierItem()
{
    ContentView *_contentView;
}

@end

@implementation NotifierItem


- (id)init
{
    if ( ( self = [super init] ) )
    {
        _contentView = [ContentView new];
        [_contentView setAutoresizingMask:NSViewWidthSizable];
        [_contentView setFrame:NSMakeRect( 0, 0, 200, 100 )];
        [self setView:_contentView];
    }
    
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE( _contentView );
    
    [super dealloc];
}


@end

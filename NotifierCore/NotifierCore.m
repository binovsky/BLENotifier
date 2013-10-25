//
//  NotifierCore.m
//  NotifierCore
//
//  Created by Michal Binovsky on 25/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "NotifierCore.h"

@interface NotifierCore()
{
    CBPeripheralManager     *_peripheralManager;
}

@end

@implementation NotifierCore

- (void)dealloc
{
    SAFE_RELEASE( _peripheralManager );
    
    [super dealloc];
}

- (void)startPeriperalRole
{
    
}

@end

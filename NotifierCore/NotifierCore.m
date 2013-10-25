//
//  NotifierCore.m
//  NotifierCore
//
//  Created by Michal Binovsky on 25/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "NotifierCore.h"

#pragma mark - private @interface NotifierCore
@interface NotifierCore()
{
    CBPeripheralManager     *_peripheralManager;
}

@end

#pragma mark - @implementation NotifierCore
@implementation NotifierCore

#pragma mark - Override
- (void)dealloc
{
    SAFE_RELEASE( _peripheralManager );
    
    [super dealloc];
}

#pragma mark - Custom
- (void)startPeriperalRoleSession
{
    _ASSERT( !_peripheralManager );
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
}

@end

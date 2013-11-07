//
//  CoreOSX.m
//  BLENotifier
//
//  Created by Michal Binovsky on 30/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "CoreOSX.h"

@interface CoreOSX()
{
    CBCentralManager    *_centralManager;
}

@end


@implementation CoreOSX

- (void)dealloc
{
    SAFE_RELEASE( _centralManager );
    [super dealloc];
}

- (void)initBeacon
{
    
}

// UNSUPPORTED ON OS X
- (void)startPeripheralRoleSession
{
    [NSException raise:@"UnsupportedForOS" format:@"Peripheral role is unsupported on OS X"];
}

// UNSUPPORTED ON OS X
- (void)stopPeripheralRoleSession
{
    [NSException raise:@"UnsupportedForOS" format:@"Peripheral role is unsupported on OS X"];
}

- (void)startCentralRoleSession
{
    
}

- (void)stopCentralRoleSession
{
    
}

- (BOOL)isAdvertising
{
    return NO; // UNSUPPORTED ON OS X
}


@end

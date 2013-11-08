//
//  CoreOSX.m
//  BLENotifier
//
//  Created by Michal Binovsky on 30/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "CoreOSX.h"

@class CBCentralManager;

@interface CoreOSX()
{
    CBCentralManager    *_centralManager;
    CBUUID *_serviceUUID;
}

@end


@implementation CoreOSX

- (void)dealloc
{
    SAFE_RELEASE( _centralManager );
    SAFE_RELEASE( _serviceUUID );
    [super dealloc];
}

- (void)initBeacon
{
    _ASSERT( !_serviceUUID );
    
    _serviceUUID = [[CBUUID UUIDWithString:SERVICE_UUID] retain];
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
    _ASSERT( _serviceUUID );
    _ASSERT( !_centralManager );
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (void)stopCentralRoleSession
{
    [_centralManager stopScan];
}

- (BOOL)isAdvertising
{
    return NO; // UNSUPPORTED ON OS X
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    _ASSERT( [central isEqual:_centralManager] );
    
    switch ( [central state] )
    {
        case CBCentralManagerStatePoweredOn:
        {
            [_centralManager scanForPeripheralsWithServices:@[ _serviceUUID ] options:nil];
        }
            break;
            
        default:
        {
            NSAlert *alert = [NSAlert alertWithMessageText:@"Bluetooth Error" defaultButton:@"Cancel" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Some error with your bluetooth anthena occured!"];
            [alert runModal];
        }
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    _ASSERT( [central isEqual:_centralManager] );
    DLog( @"\n\n%@\nDiscovered %@", NSStringFromSelector( _cmd ), [peripheral description] );
    
    [_centralManager connectPeripheral:peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _ASSERT( [central isEqual:_centralManager] );
    DLog( @"\n\n%@\nDiscovered %@", NSStringFromSelector( _cmd ), [peripheral description] );
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _ASSERT( [central isEqual:_centralManager] );
    DLog( @"\n\n%@\nDiscovered %@", NSStringFromSelector( _cmd ), [peripheral description] );
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _ASSERT( [central isEqual:_centralManager] );
    DLog( @"\n\n%@\nDiscovered %@", NSStringFromSelector( _cmd ), [peripheral description] );
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    _ASSERT( [central isEqual:_centralManager] );
    DLog( @"\n\n%@\nDiscovered %@", NSStringFromSelector( _cmd ), peripherals );
}

@end

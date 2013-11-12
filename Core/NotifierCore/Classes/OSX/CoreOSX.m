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
    CBCentralManager *_centralManager;
    CBUUID *_serviceUUID;
    NSMutableArray *_peripherals;
}

@end


@implementation CoreOSX

- (void)dealloc
{
    SAFE_RELEASE( _centralManager );
    SAFE_RELEASE( _serviceUUID );
    SAFE_RELEASE( _peripherals );
    
    [super dealloc];
}

- (void)initBeacon
{
    _ASSERT( !_serviceUUID );
    _ASSERT( !_peripherals );
    
    _serviceUUID = [[CBUUID UUIDWithString:SERVICE_UUID] retain];
    _peripherals = [[NSMutableArray alloc] initWithCapacity:0];
}

#pragma mark - @Custom
// UNSUPPORTED ON OS X
- (void)startPeripheralRoleSession
{
    [NSException raise:@"UnsupportedForOSX" format:@"Peripheral role is unsupported on OS X"];
}

// UNSUPPORTED ON OS X
- (void)stopPeripheralRoleSession
{
    [NSException raise:@"UnsupportedForOSX" format:@"Peripheral role is unsupported on OS X"];
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
    [_centralManager setDelegate:nil];
    SAFE_RELEASE( _centralManager );
}

- (BOOL)isAdvertising
{
    return NO; // UNSUPPORTED ON OS X
}

- (BOOL)isPeripheralAlreadyKnown:(CBPeripheral *)peripheral
{
    for ( CBPeripheral *known in _peripherals )
    {
        if ( [peripheral isEqual:known] )
            return YES;
    }
    
    return NO;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    _ASSERT( [central isEqual:_centralManager] );
    
    switch ( [central state] )
    {
        case CBCentralManagerStatePoweredOn:
        {
            NSDictionary * opts = @{ CBCentralManagerScanOptionAllowDuplicatesKey : @( NO ) };
            [_centralManager scanForPeripheralsWithServices:nil /*@[ _serviceUUID ]*/ options:opts];
            DLog( @"\n\n\n **** CENTRAL MANAGER **** \n\n ----- \n %@\n ---- \n\n", [_centralManager description] );
        }
            break;
            
        default:
        {
            NSAlert *alert = [NSAlert alertWithMessageText:@"Bluetooth Error" defaultButton:@"Cancel" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Some error with your bluetooth anthena occured!"];
            [alert runModal];
            [self stopCentralRoleSession];
        }
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    _ASSERT( [central isEqual:_centralManager] );
    DLog( @"\n\n%@\nDiscovered %@ \n\n advertisedData: %@ \n\n services: %@ \n\n RSSI: %@", NSStringFromSelector( _cmd ), [peripheral description], advertisementData, [peripheral services], [RSSI stringValue] );
    
    if ( ![self isPeripheralAlreadyKnown:peripheral] )
    {
        [_peripherals addObject:peripheral];
        
        NSDictionary *opt = @{ @"CBConnectPeripheralOptionNotifyOnConnectionKey" : @( YES ), @"CBConnectPeripheralOptionNotifyOnDisconnectionKey" : @( YES ) };
        [_centralManager connectPeripheral:peripheral options:opt];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _ASSERT( [central isEqual:_centralManager] );
    DLog( @"\n\n%@\nDiscovered %@", NSStringFromSelector( _cmd ), [peripheral description] );
    
    if ( [self isPeripheralAlreadyKnown:peripheral] )
    {
        [peripheral setDelegate:self];
        [peripheral discoverServices:nil/*@[ _serviceUUID ]*/];
    }
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

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    DLog( @" /\\/\\/\\/\\/\\  %@  /\\/\\/\\/\\/\\", NSStringFromSelector( _cmd ) );
    
    if ( error )
    {
        DLog( @"Error discovering services: %@", [error localizedDescription] );
    }
    
    for ( CBService *service in [peripheral services] )
    {
        DLog( @" <------> SERVICE <------> %@ ", [service description] );
        
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ( error )
    {
        DLog( @"Error discovering service characteristics: %@", [error localizedDescription] );
    }
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        DLog(@"Discovered characteristic %@", characteristic);
    }
}

@end

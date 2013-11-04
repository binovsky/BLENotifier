//
//  CoreIOS.m
//  BLENotifier
//
//  Created by Michal Binovsky on 30/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "CoreIOS.h"

const static NSString*  BEACON_IDENTIFIER       = @"com.binovsky.BLENotifier";

@interface CoreIOS()
{
    BOOL _bInitialized;
    CLBeaconRegion *_beaconRegion;
    NSDictionary *_beaconPeripheralData;
    NSUUID *_proximityUUID;
    CBPeripheralManager *_peripheralManager;
    CBUUID *_serviceUUID;
    CBMutableCharacteristic *_characteristics;
    CBMutableService *_service;
}

@end

@implementation CoreIOS

- ( id )init
{
    self = [super init];
    if ( self )
    {
        _peripheralManager = nil;
        _bInitialized = NO;
    }
    
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE( _beaconRegion );
    SAFE_RELEASE( _beaconPeripheralData );
    SAFE_RELEASE( _proximityUUID );
    [_peripheralManager setDelegate:nil]; SAFE_RELEASE( _peripheralManager );
    SAFE_RELEASE( _serviceUUID );
    SAFE_RELEASE( _characteristics );
    SAFE_RELEASE( _service );
    
    [super dealloc];
}

- (void)initBeacon
{
    _ASSERT( !_serviceUUID );
    _ASSERT( !_proximityUUID );
    _ASSERT( !_beaconRegion );
    _ASSERT( !_characteristics );
    
    _serviceUUID = [CBUUID UUIDWithString:(NSString *)SERVICE_UUID];
    _proximityUUID = [[NSUUID alloc] initWithUUIDString:(NSString *)SERVICE_UUID];
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:_proximityUUID major:1 minor:1 identifier:(NSString *)BEACON_IDENTIFIER];
    _characteristics = [[CBMutableCharacteristic alloc] initWithType:_serviceUUID properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    _bInitialized = YES;
}

- (void)startPeripheralRoleSession
{
    if ( !_bInitialized )
        [NSException raise:@"Initialization failed" format:@"Probably you have forget to call 'initBeacon' before '%@'", NSStringFromSelector( _cmd )];
    
    _ASSERT( _serviceUUID );
    _ASSERT( _proximityUUID );
    _ASSERT( _beaconRegion );
    _ASSERT( _characteristics );
    _ASSERT( !_peripheralManager );
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (void)stopPeripheralRoleSession
{
    [_peripheralManager stopAdvertising];
    [_peripheralManager removeAllServices];
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    _ASSERT( [_peripheralManager isEqual:peripheral] );
    
    switch ( [_peripheralManager state] )
    {
        case CBPeripheralManagerStatePoweredOn:
        {
            _service = [[CBMutableService alloc] initWithType:_serviceUUID primary:YES];
            [_service setCharacteristics:@[_characteristics]];
            
            [_peripheralManager addService:_service];
        }
            break;
            
        case CBPeripheralManagerStatePoweredOff:
        {
            [UIAlertView showSimpleAlertWithTitle:@"Bluetootht antena off" message:@"You have to power on bluetooth antena in your device" andCancelButtonTitle:@"Ok"];
            [self stopPeripheralRoleSession];
        }
            break;
            
        case CBPeripheralManagerStateUnauthorized:
        {
            [UIAlertView showSimpleAlertWithTitle:@"Authorization Failure" message:@"You have to authorize access to bluetooth for this app" andCancelButtonTitle:@"Ok"];
            [self stopPeripheralRoleSession];
        }
            break;
            
        default:
        {
            [UIAlertView showSimpleAlertWithTitle:@"Error" message:@"Your device is unsupported or unknow error occured" andCancelButtonTitle:@"Ok"];
            [self stopPeripheralRoleSession];
        }
            break;
    }
}


- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    _ASSERT( [_peripheralManager isEqual:peripheral] );
    
    if ( error )
    {
        DLog( @"Error publishing service: %@", [error localizedDescription] );
        [_peripheralManager removeService:(CBMutableService *)service];
    }
    
    [_peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[_service.UUID] }];
}


- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    _ASSERT( [_peripheralManager isEqual:peripheral] );
    
    if ( error )
    {
        DLog(@"Error advertising: %@", [error localizedDescription]);
        [_peripheralManager stopAdvertising];
    }   
}

@end

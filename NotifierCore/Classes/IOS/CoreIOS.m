//
//  CoreIOS.m
//  BLENotifier
//
//  Created by Michal Binovsky on 30/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "CoreIOS.h"

@interface CoreIOS()
{
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
    }
    
    return self;
}

- (void)dealloc
{
    [_peripheralManager setDelegate:nil];
    SAFE_RELEASE( _peripheralManager );
    SAFE_RELEASE( _serviceUUID );
    SAFE_RELEASE( _characteristics );
    SAFE_RELEASE( _service );
    
    [super dealloc];
}

- (void)startPeripheralRoleSession
{
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
            _serviceUUID = [CBUUID UUIDWithString:(NSString *)SERVICE_UUID];
            _characteristics = [[CBMutableCharacteristic alloc] initWithType:_serviceUUID properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
            _service = [[CBMutableService alloc] initWithType:_serviceUUID primary:YES];
            [_service setCharacteristics:@[_characteristics]];
            
            [_peripheralManager addService:_service];
        }
            break;
            
        case CBPeripheralManagerStatePoweredOff:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetootht antena off" message:@"You have to power on bluetooth antena in your device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            SAFE_RELEASE( _peripheralManager );
        }
            break;
            
        case CBPeripheralManagerStateUnauthorized:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Failure" message:@"You have to authorize access to bluetooth for this app" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            SAFE_RELEASE( _peripheralManager );
        }
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device is unsupported or unknow error occured" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            SAFE_RELEASE( _peripheralManager );
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

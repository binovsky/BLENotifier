//
//  NotifierCore.h
//  NotifierCore
//
//  **** **** **** ****
//
//    Singleton Class
//
//  **** **** **** ****
//
//  Created by Michal Binovsky on 25/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "NotifierCore.h"

static const NSString*  SERVICE_UUID    = @"BDFDA27E-2B3E-4FAF-A68C-EF04DC79594D";

#pragma mark - private @interface NotifierCore
@interface NotifierCore()
{
    CBPeripheralManager *_peripheralManager;
    CBUUID *_serviceUUID;
    CBMutableCharacteristic *_characteristics;
    CBMutableService *_service;
}

@end

#pragma mark - @implementation NotifierCore
@implementation NotifierCore

static	NotifierCore	*_instance	=	nil;

// singleton instance
+ ( NotifierCore * )instance
{
	@synchronized( [NotifierCore class] )
	{
		if ( !_instance )
			_instance = [[self alloc] init];
        
		return _instance;
	}
    
	return nil;
}

#pragma mark - Override
+ ( id )alloc
{
	@synchronized( [NotifierCore class] )
	{
		NSAssert( _instance == nil, @"Attempted to allocate a second instance of a singleton." );
		_instance = [super alloc];
		return _instance;
	}
    
	return nil;
}

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

#pragma mark - Custom
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

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
    CLLocationManager *_locationManager;
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
    SAFE_RELEASE( _locationManager );
    
    [super dealloc];
}

- (void)initBeacon
{
    _ASSERT( !_serviceUUID );
    _ASSERT( !_proximityUUID );
    _ASSERT( !_beaconRegion );
    _ASSERT( !_characteristics );
    _ASSERT( !_locationManager );
    
    // COMMON
    _serviceUUID = [CBUUID UUIDWithString:(NSString *)SERVICE_UUID];
    _proximityUUID = [[NSUUID alloc] initWithUUIDString:(NSString *)SERVICE_UUID];
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:_proximityUUID major:1 minor:1 identifier:(NSString *)BEACON_IDENTIFIER];
    
    // PERIPHERAL
    _characteristics = [[CBMutableCharacteristic alloc] initWithType:_serviceUUID properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    // CENTRAL
    _locationManager = [[CLLocationManager alloc] init];
    
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

- (void)startCentralRoleSession
{
    if ( !_bInitialized )
        [NSException raise:@"Initialization failed" format:@"Probably you have forget to call 'initBeacon' before '%@'", NSStringFromSelector( _cmd )];
    
    _ASSERT( _proximityUUID );
    _ASSERT( _beaconRegion );
    _ASSERT( _locationManager );
    [_locationManager setDelegate:self];
    [_locationManager startMonitoringForRegion:_beaconRegion];
}

- (void)stopCentralRoleSession
{
    [_locationManager stopMonitoringForRegion:_beaconRegion];
    [_locationManager setDelegate:nil];
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

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    _ASSERT( [manager isEqual:_locationManager] );
    
    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
    DLog( @"Beacon found: YES" );
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    _ASSERT( [manager isEqual:_locationManager] );
    
    [_locationManager stopRangingBeaconsInRegion:_beaconRegion];
    DLog( @"Beacon found: NO" );
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    _ASSERT( [manager isEqual:_locationManager] );
    
    CLBeacon *beacon = nil;
    beacon = [beacons lastObject];
    
    [self logBeacon:beacon];
}

- (void)logBeacon:(CLBeacon *)beacon
{
    _ASSERT( beacon );
    
    NSString *log = @"\n\n\nBEACON: \n\n";
    log = [log stringByAppendingString:@"UUID: "];
    log = [log stringByAppendingString:beacon.proximityUUID.UUIDString];
    log = [log stringByAppendingString:@"\n"];
    log = [log stringByAppendingString:@"BEACON MAJOR: "];
    log = [log stringByAppendingString:[NSString stringWithFormat:@"%@", beacon.major]];
    log = [log stringByAppendingString:@"\n"];
    log = [log stringByAppendingString:@"BEACON MINOR: "];
    log = [log stringByAppendingString:[NSString stringWithFormat:@"%@", beacon.minor]];
    log = [log stringByAppendingString:@"\n"];
    log = [log stringByAppendingString:@"ACCURACY: "];
    log = [log stringByAppendingString:[NSString stringWithFormat:@"%f", beacon.accuracy]];
    log = [log stringByAppendingString:@"\n"];
    
    NSString *strProximity;
    if ( beacon.proximity == CLProximityUnknown )
    {
        strProximity = @"Unknown Proximity";
    }
    else if ( beacon.proximity == CLProximityImmediate )
    {
        strProximity = @"Immediate";
    }
    else if ( beacon.proximity == CLProximityNear )
    {
        strProximity = @"Near";
    }
    else if ( beacon.proximity == CLProximityFar )
    {
        strProximity = @"Far";
    }
    else
    {
        strProximity = @"UIDENTIFIED STATE";
    }
    
    log = [log stringByAppendingString:@"PROXIMITY: "];
    log = [log stringByAppendingString:strProximity];
    log = [log stringByAppendingString:@"\n"];
    log = [log stringByAppendingString:@"RSSI: "];
    log = [log stringByAppendingString:[NSString stringWithFormat:@"%li", (long)beacon.rssi]];
    log = [log stringByAppendingString:@"\n"];
    
    DLog( @"%@", log );
}

@end

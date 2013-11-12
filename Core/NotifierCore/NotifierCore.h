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

extern NSString*  SERVICE_UUID;

// NOTIFICATIONS
extern NSString* PeripheralDidStartAdvertisingNotification;
extern NSString* PeripheralDidStopAdvertisingNotification;
extern NSString* PeripheralDidFaildToStartAdvertisingNotification;

extern NSString* CentralDidDiscoverPeripheral;
extern NSString* CentralDidConnectPeripheral;
extern NSString* CentralDidDisconnectPeripheral;
extern NSString* CentralDidFailConnectPeripheral;
extern NSString* CentralDidFoundPeripheralServices;
extern NSString* CentralDidNotFoundPeripheralServices;
extern NSString* CentralDidFoundPeripheralServiceCharacteristics;
extern NSString* CentralDidNotFoundPeripheralServiceCharacteristics;

#pragma mark - @interface NotifierCore
@interface NotifierCore : NSObject
{
}

    #pragma mark - Class Methods
    + ( NotifierCore * )instance;

    #pragma mark - Instanance Methods
    - (void)initBeacon;
    - (void)startPeripheralRoleSession;
    - (void)stopPeripheralRoleSession;
    - (void)startCentralRoleSession;
    - (void)stopCentralRoleSession;
    - (BOOL)isAdvertising;
    - (BOOL)isScanning;
    - (BOOL)isConnected;
    - (NSArray *)peripherals;

@end

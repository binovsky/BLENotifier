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
extern NSString* DidStartAdvertisingNotification;
extern NSString* DidStopAdvertisingNotification;
extern NSString* DidFaildToStartAdvertisingNotification;

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

@end

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
#import <CoreBluetooth/CBPeripheralManager.h>

#pragma mark - @interface NotifierCore
@interface NotifierCore : NSObject < CBPeripheralManagerDelegate >
{
}

    #pragma mark - Class Methods
    + ( NotifierCore * )instance;

    #pragma mark - Instanance Methods
    - (void)startPeriperalRoleSession;

@end

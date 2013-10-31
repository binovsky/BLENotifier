//
//  CoreIOS.h
//  BLENotifier
//
//  Created by Michal Binovsky on 30/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import <NotifierCore/NotifierCore.h>
@protocol CBPeripheralManagerDelegate;

@interface CoreIOS : NotifierCore < CBPeripheralManagerDelegate >

@end

//
//  CoreOSX.h
//  BLENotifier
//
//  Created by Michal Binovsky on 30/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import <NotifierCore/NotifierCore.h>

@interface CoreOSX : NotifierCore < CBCentralManagerDelegate, CBPeripheralDelegate >

@end

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

#pragma mark - private @interface NotifierCore
@interface NotifierCore()
{
    CBPeripheralManager     *_peripheralManager;
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
    
    [super dealloc];
}

#pragma mark - Custom
- (void)startPeriperalRoleSession
{
    _ASSERT( !_peripheralManager );
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    _ASSERT( [_peripheralManager isEqual:peripheral] );
}

@end

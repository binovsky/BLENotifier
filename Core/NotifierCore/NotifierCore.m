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

#ifdef _IOS
    #import <IOS/CoreIOS.h>
#elif _OSX
    #import <OSX/CoreOSX.h>
#endif


const NSString*  SERVICE_UUID    = @"BDFDA27E-2B3E-4FAF-A68C-EF04DC79594D";

// NOTIFICATIONS
const NSString* DidStartAdvertisingNotification = @"DidStartAdvertisingNotification";
const NSString* DidStopAdvertisingNotification = @"DidStopAdvertisingNotification";

#pragma mark - private @interface NotifierCore
@interface NotifierCore()
{
    
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
        {
#ifdef _IOS
			_instance = [[CoreIOS alloc] init];
#elif _OSX
            _instance = [[CoreOSX alloc] init];
#endif
        }
        
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

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Custom
- (void)startPeripheralRoleSession
{
    [NSException raise:@"VirtualMethodNotOverriden" format:@"'startPeripheralRoleSession' have to be implemented"];
}

- (void)stopPeripheralRoleSession
{
    [NSException raise:@"VirtualMethodNotOverriden" format:@"'stopPeripheralRoleSession' have to be implemented"];
}

@end

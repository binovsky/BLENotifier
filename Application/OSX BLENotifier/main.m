//
//  main.m
//  OSX BLENotifier
//
//  Created by Michal Binovsky on 30/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"


int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        AppDelegate * appDelegate = [[[AppDelegate alloc] init] autorelease];
        
        NSApplication * application = [NSApplication sharedApplication];
        [application setDelegate:appDelegate];
        [application run];
    }
    
    return EXIT_SUCCESS;
}

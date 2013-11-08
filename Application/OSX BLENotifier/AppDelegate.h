//
//  AppDelegate.h
//  OSX BLENotifier
//
//  Created by Michal Binovsky on 30/10/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSStatusBar *_statusBar;
    NSStatusItem * _statusItem;
    NSMenu *_statusMenu;
}

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

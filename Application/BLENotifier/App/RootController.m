//
//  ViewController.m
//  BLENotifier
//
//  Created by Michal Binovsky on 9/26/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "RootController.h"

@interface RootController ()

@end

@implementation RootController

- (void)dealloc
{
    [super dealloc];
}

- (void)loadView
{
    [self setView:[[UIView new] autorelease]];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NotifierCore *core = [NotifierCore instance];
    [core startPeripheralRoleSession];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

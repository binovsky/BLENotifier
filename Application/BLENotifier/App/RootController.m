//
//  ViewController.m
//  BLENotifier
//
//  Created by Michal Binovsky on 9/26/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "RootController.h"

@interface RootController ()
{
    NotifierCore *_core;
    UIButton *_beaconButton;
    UIButton *_listenerButton;
}

@end

@implementation RootController

- (void)dealloc
{
    SAFE_RELEASE( _core );
    SAFE_RELEASE( _beaconButton );
    SAFE_RELEASE( _listenerButton );
    [super dealloc];
}

//- (void)loadView
//{
//    [self setView:[[UIView new] autorelease]];
//    [[self view] setBackgroundColor:[UIColor whiteColor]];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _ASSERT( !_core );
    _core = [NotifierCore instance];
    [_core initBeacon];
    
    _ASSERT( !_beaconButton );
    _beaconButton = [UIButton new];
    [_beaconButton setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_beaconButton setTintColor:[UIColor orangeColor]];
    [[_beaconButton titleLabel] setTextColor:[UIColor orangeColor]];
    [_beaconButton addTarget:self action:@selector( startBeaconRole: ) forControlEvents:UIControlEventTouchUpInside];
    [_beaconButton setTitle:@"Start Beacon" forState:UIControlStateNormal];
    [[self view] addSubview:_beaconButton];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_beaconButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings( _beaconButton )]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_beaconButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings( _beaconButton )]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_beaconButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeHeight multiplier:0.5f constant:0.f]];
    
    _ASSERT( !_listenerButton );
    _listenerButton = [UIButton new];
    [_listenerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_listenerButton setTintColor:[UIColor blueColor]];
    [[_listenerButton titleLabel] setTextColor:[UIColor blueColor]];
    [_listenerButton addTarget:self action:@selector( startListenerRole: ) forControlEvents:UIControlEventTouchUpInside];
    [_listenerButton setTitle:@"Start Listener" forState:UIControlStateNormal];
    [[self view] addSubview:_listenerButton];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_listenerButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings( _listenerButton )]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_listenerButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings( _listenerButton )]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_listenerButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeHeight multiplier:0.5f constant:0.f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom
- (void)startBeaconRole:(UIButton *)sender
{
    _ASSERT( [sender isEqual:_beaconButton] );
    _ASSERT( _core );
    
    [_core startPeripheralRoleSession];
}

- (void)startListenerRole:(UIButton *)sender
{
    _ASSERT( [sender isEqual:_listenerButton] );
    _ASSERT( _core );
    
    [_core startCentralRoleSession];
}

@end

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

@end`

@implementation RootController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SAFE_RELEASE( _core );
    SAFE_RELEASE( _beaconButton );
    SAFE_RELEASE( _listenerButton );
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
    
    _ASSERT( !_core );
    _core = [NotifierCore instance];
    [_core initBeacon];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartAdvertising:) name:PeripheralDidStartAdvertisingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStopAdvertising:) name:PeripheralDidStopAdvertisingNotification object:nil];
    
    _ASSERT( !_beaconButton );
    _beaconButton = [[UIButton buttonWithType:UIButtonTypeSystem] retain];
    [_beaconButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_beaconButton setTintColor:[UIColor orangeColor]];
    [_beaconButton addTarget:self action:@selector( startBeaconRole: ) forControlEvents:UIControlEventTouchUpInside];
    [_beaconButton setTitle:@"Start Beacon" forState:UIControlStateNormal];
    [_beaconButton setTitleColor:[UIColor cyanColor] forState:UIControlStateHighlighted];
    [[_beaconButton titleLabel] setFont:[UIFont systemFontOfSize:50.f]];
    [[self view] addSubview:_beaconButton];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_beaconButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings( _beaconButton )]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_beaconButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings( _beaconButton )]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:_beaconButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeHeight multiplier:0.5f constant:0.f]];
    
    _ASSERT( !_listenerButton );
    _listenerButton = [[UIButton buttonWithType:UIButtonTypeSystem] retain];
    [_listenerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_listenerButton setTintColor:[UIColor blueColor]];
    [_listenerButton addTarget:self action:@selector( startListenerRole: ) forControlEvents:UIControlEventTouchUpInside];
    [_listenerButton setTitle:@"Start Listener" forState:UIControlStateNormal];
    [_listenerButton setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
    [[_listenerButton titleLabel] setFont:[UIFont systemFontOfSize:50.f]];
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
    
    if ( [_core isAdvertising] )
        [_core stopPeripheralRoleSession];
    else
        [_core startPeripheralRoleSession];
}

- (void)startListenerRole:(UIButton *)sender
{
    _ASSERT( [sender isEqual:_listenerButton] );
    _ASSERT( _core );
    
    [_core startCentralRoleSession];
}

- (void)didStartAdvertising:(NSNotification *)aNotification
{
    if ( [_core isAdvertising] )
    {
        [_beaconButton setTitle:@"Stop Beacon" forState:UIControlStateNormal];
    }
    else
    {
        [UIAlertView showSimpleAlertWithTitle:@"Start Advertising Error" message:@"Unable to perform advertising a beacon data" andCancelButtonTitle:@"Ok"];
        
        [_core stopPeripheralRoleSession];
    }
}

- (void)didStopAdvertising:(NSNotification *)aNotification
{
    if ( [_core isAdvertising] )
        [UIAlertView showSimpleAlertWithTitle:@"Stop Advertising Error" message:@"Unable to stop advertising a beacon data" andCancelButtonTitle:@"Ok"];
    else
        [_beaconButton setTitle:@"Start Beacon" forState:UIControlStateNormal];
}

@end

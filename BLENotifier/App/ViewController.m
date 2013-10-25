//
//  ViewController.m
//  BLENotifier
//
//  Created by Michal Binovsky on 9/26/13.
//  Copyright (c) 2013 Michal Binovsky. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView
{
    [self setView:[[UIView new] autorelease]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     
        Hello World!
     
     */
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbl = [UILabel new];
    [lbl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [lbl setText:@"Hello World"];
    [lbl setFont:[UIFont systemFontOfSize:44.f]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [[self view] addSubview:lbl];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lbl(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings( lbl )]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lbl(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings( lbl )]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:[self view] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:lbl attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [[self view] addConstraint:[NSLayoutConstraint constraintWithItem:[self view] attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbl attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
    
    [lbl release];
    
    NotifierCore *core = [NotifierCore new];
    [core startPeriperalRoleSession];
//    SAFE_RELEASE( core );
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

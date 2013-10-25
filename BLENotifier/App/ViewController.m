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
    [lbl setFont:[UIFont systemFontOfSize:20.f]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [[self view] addSubview:lbl];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lbl]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings( lbl )]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(100)-[lbl(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings( lbl )]];
    
    [lbl release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

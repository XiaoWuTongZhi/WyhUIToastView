//
//  WYHViewController.m
//  WyhUIToast
//
//  Created by Michael Wu on 11/11/2019.
//  Copyright (c) 2019 Michael Wu. All rights reserved.
//

#import "WYHViewController.h"
#import <WyhUIToast.h>

@interface WYHViewController ()

@end

@implementation WYHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickAct:(id)sender {
    [WyhUIToast showInfoMessage:@"test asdasdas"];
}



@end

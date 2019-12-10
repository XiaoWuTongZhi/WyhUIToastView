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
- (IBAction)clickShowLoading:(id)sender {
    [WyhUIToast show:(WyhUIToastTypeLoading) message:@"loading text, please wait .."];
}
- (IBAction)clickShowLoadingWithoutUserInteraction:(id)sender {
    [WyhUIToast show:(WyhUIToastTypeLoading) message:@"loading text without interaction, please wait .."];
}

- (IBAction)clickShowInfo:(id)sender {
    [WyhUIToast show:(WyhUIToastTypeInfo) message:@"Show information toast !"];
}
- (IBAction)clickShowWarning:(id)sender {
    [WyhUIToast show:(WyhUIToastTypeWarn) message:@"Show warning toast !"];
    
}
- (IBAction)clickShowSuccess:(id)sender {
    [WyhUIToast show:(WyhUIToastTypeSuccess) message:@"Show success toast !"];
}





@end

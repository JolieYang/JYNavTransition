//
//  ThirdViewController.m
//  JYNavTransition
//
//  Created by Jolie_Yang on 2017/4/27.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import "ThirdViewController.h"
#import "JYNavigationController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    JYNavigationController *nav = (JYNavigationController *)self.navigationController;
    nav.fullScreenPopGestureEnabled = NO;
    
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)popToRootAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)popToFirstVCAction:(id)sender {
    [self.navigationController popToViewController:self.firstVC animated:YES];
}
- (IBAction)popToSecondVCAction:(id)sender {
    [self.navigationController popToViewController:self.secondVC animated:YES];
}

@end

//
//  SecondViewController.m
//  JYNavTransition
//
//  Created by Jolie_Yang on 2017/4/26.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "JYNavigationController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    JYNavigationController *nav = (JYNavigationController *)self.navigationController;
    nav.fullScreenPopGestureEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
}
- (IBAction)pushAction:(id)sender {
    ThirdViewController *vc = [[ThirdViewController alloc] init];
    vc.firstVC = self.firstVC;
    vc.secondVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

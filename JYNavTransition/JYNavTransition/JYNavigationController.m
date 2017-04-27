//
//  JYNavigationController.m
//  JYNavTransition
//
//  Created by Jolie_Yang on 2017/4/26.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import "JYNavigationController.h"
#import "JYNavAnimation.h"
#import "JYNavInteractiveTransition.h"

@interface JYNavigationController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) JYNavInteractiveTransition *navInteractiveTransition;
@property (nonatomic, strong) JYNavAnimation *anmiation;

@property (nonatomic, strong) UIImageView *screenShotImageView;
@property (nonatomic, strong) UIImage *toImage;
@end

@implementation JYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navInteractiveTransition = [JYNavInteractiveTransition new];
    self.anmiation = [JYNavAnimation new];
    self.delegate = self;
    self.interactivePopGestureRecognizer.enabled = NO;
    
    self.screenShots = [NSMutableArray array];
    self.screenShotImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        UIImage *screenShot = [self screenShotInNavigationController:self];
        [self.screenShots addObject:screenShot];
    }
    
    [super pushViewController:viewController animated:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.anmiation.navigationControllerOperation = operation;
    if (operation == UINavigationControllerOperationPush) {
        [self.navInteractiveTransition pushToViewController:toVC];
    } else if (operation == UINavigationControllerOperationPop) {
    }
    return self.anmiation;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.navInteractiveTransition.interacting ? self.navInteractiveTransition:nil;// 当Push时interacting为NO，则使用默认的转场交互
}

#pragma mark -- Tool
- (UIImage *)screenShotInNavigationController:(UINavigationController *)navigationController {
    UIViewController *beyondVC = navigationController.view.window.rootViewController;
    CGSize size = beyondVC.view.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGRect rect = CGRectMake(0, 0, kAppWidth, kAppHeight);
    if (navigationController.tabBarController == beyondVC) {
        [beyondVC.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    } else {
        [navigationController.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    }
    
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShot;
}
@end

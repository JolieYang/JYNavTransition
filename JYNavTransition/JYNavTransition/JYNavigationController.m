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

@end

@implementation JYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navInteractiveTransition = [JYNavInteractiveTransition new];
    self.anmiation = [JYNavAnimation new];
    self.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
    
    _screenShots = [NSMutableArray array];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0 && self.popCount != 1) {
        UIImage *screenShot = [self screenShot];
        [self.screenShots addObject:screenShot];
    }
    _popCount = 0;
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.popCount > 0) {
        [self clearCurrentScreenShot];
    }
    _popCount += 1;
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    for (NSInteger i = self.viewControllers.count - 1; i > 0 ; i--) {
        if (self.viewControllers[i] == viewController) {
            break;
        }
        _popCount++;
    }
    [self popScreenShots];
    
    return [super popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    [self popToRootScreenShot];
    
    return [super popToRootViewControllerAnimated:animated];
}

- (void)setFullScreenPopGestureEnabled:(BOOL)fullScreenPopGestureEnabled {
    self.navInteractiveTransition.fullScreenGesture.enabled = fullScreenPopGestureEnabled;
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
- (UIImage *)screenShot {
    return [self screenShotInNavigationController:self];
}

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

// 删除到只剩一张当前页面的截图
- (void)popToRootScreenShot {
    [_screenShots removeObjectsInRange:NSMakeRange(1, _screenShots.count - 1)];
    _popCount = 1;
}

// 删除到只剩当前页面的截图
- (void)popScreenShots {
    [_screenShots removeObjectsInRange:NSMakeRange(_screenShots.count - self.popCount + 1, self.popCount - 1)];
    _popCount = 1;
}

// 清理pop时还未删除的截图--也就是清除当前页面的截图
- (BOOL)clearCurrentScreenShot {
    if (self.popCount == 1) {
        [_screenShots removeLastObject];
        _popCount = 0;
        return YES;
    }
    return NO;
}

@end

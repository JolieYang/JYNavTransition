//
//  JYNavInteractiveTransition.h
//  JYNavTransition
//
//  Created by Jolie_Yang on 2017/4/26.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAppWidth [[UIScreen mainScreen] bounds].size.width
#define kAppHeight [[UIScreen mainScreen] bounds].size.height

@interface JYNavInteractiveTransition : NSObject<UIViewControllerInteractiveTransitioning>
@property (nonatomic, assign) BOOL interacting;
@property (nonatomic, strong) UIViewController *pushToVC;
- (void)pushToViewController:(UIViewController *)vc;
@end

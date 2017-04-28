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
#define kMaskViewAlpha 0.3 // 遮罩默认alpha值
#define kMaskViewScale 0.7 // pop交互转场时显示上一视图的比例为0.7时将alpha设为0

@interface JYNavInteractiveTransition : NSObject<UIViewControllerInteractiveTransitioning>
@property (nonatomic, assign) BOOL interacting;
- (void)pushToViewController:(UIViewController *)vc;
@end

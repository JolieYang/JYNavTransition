//
//  JYNavigationController.h
//  JYNavTransition
//
//  Created by Jolie_Yang on 2017/4/26.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYNavigationController : UINavigationController
@property (nonatomic, strong, readonly) NSMutableArray *screenShots;
@property (nonatomic, assign, readonly) NSInteger popCount;
@property (nonatomic, assign) BOOL fullScreenPopGestureEnabled;
// 截图
- (UIImage *)screenShot;
// 清除当前页面的截图
- (BOOL)clearCurrentScreenShot;
@end

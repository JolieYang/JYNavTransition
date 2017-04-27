//
//  JYNavigationController.h
//  JYNavTransition
//
//  Created by Jolie_Yang on 2017/4/26.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYNavigationController : UINavigationController
@property (nonatomic, strong) NSMutableArray *screenShots;
- (UIImage *)screenShotInNavigationController:(UINavigationController *)navigationController;
@end

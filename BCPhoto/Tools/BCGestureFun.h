//
//  BCGestureFun.h
//  BCPhoto
//
//  Created by admin on 16/12/6.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BCGestureFun : NSObject

#pragma mark 手势用到的方法

+ (void)panChangedWithGesture:(UIPanGestureRecognizer *)gestureRecognizer;
+ (void)pinchChangedWithGesture:(UIPinchGestureRecognizer *)gestureRecognizer;
+ (void)rotationChangedWithGesture:(UIRotationGestureRecognizer *)gestureRecognizer;


@end

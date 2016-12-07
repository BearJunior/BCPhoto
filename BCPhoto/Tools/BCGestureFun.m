//
//  BCGestureFun.m
//  BCPhoto
//
//  Created by admin on 16/12/6.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "BCGestureFun.h"

@implementation BCGestureFun


+ (void)panChangedWithGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        UIView *gestureView = [gestureRecognizer view];
        
        CGPoint translation = [gestureRecognizer translationInView:gestureView.superview];
        
        float cx = gestureView.center.x + translation.x;
        float cy = gestureView.center.y + translation.y;
        
        //if (isPointInRect(CGPointMake(cx, cy), gestureView.superview.bounds)) {
        
        //        CGPoint toSuperPoint = [gestureView.superview.superview convertPoint:CGPointMake(cx, cy) fromView:gestureView.superview];
        //        CGRect superFrame = gestureView.superview.superview.frame;
        
        //允许移除外面
        //        if (CGRectContainsPoint(superFrame, toSuperPoint) || _enableMoveOutOverHalf) {
        gestureView.center = CGPointMake(cx, cy);
        //        }
        
        [gestureRecognizer setTranslation:CGPointZero inView:gestureView.superview];
    }
}

+ (void)pinchChangedWithGesture:(UIPinchGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        UIView *gestureView = [gestureRecognizer view];
        
        float scale = [gestureRecognizer scale];
        CGAffineTransform transform = gestureView.transform;
        gestureView.transform = CGAffineTransformScale(transform, scale, scale);
        [gestureRecognizer setScale:1];
    }
}

+ (void)rotationChangedWithGesture:(UIRotationGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        UIView *gestureView = [gestureRecognizer view];
        
        float radian = [gestureRecognizer rotation];
        CGAffineTransform transform = gestureView.transform;
        
        gestureView.transform = CGAffineTransformRotate(transform, radian);
        [gestureRecognizer setRotation:0];
    }
}


@end

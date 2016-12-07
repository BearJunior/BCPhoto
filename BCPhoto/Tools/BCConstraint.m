//
//  BCConstraint.m
//  BCPhoto
//
//  Created by admin on 16/12/7.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "BCConstraint.h"
#import "BCFitHeader.h"

@implementation BCConstraint


#pragma - CGSize

/**
 * @return: 返回子视图的大小
 * @subRate: 子视图的比例
 * @superSize: 父视图的大小
 * @type: 限制类型
 */
+ (CGSize)getSubSizeWithSubRate:(CGFloat)subRate superSize:(CGSize)superSize type:(ConstraintType)type
{
    CGSize subSize = CGSizeZero;
    
    if (type == ConstraintTypeSmall) {
        
        if (subRate >= superSize.width / superSize.height) {
            subSize.width = superSize.width;
            subSize.height= subSize.width / subRate;
        }
        else {
            subSize.height = superSize.height;
            subSize.width = subSize.height * subRate;
        }
    }
    else if (type == ConstraintTypeLarge) {
        if (subRate >= superSize.width / superSize.height) {
            subSize.height = superSize.height;
            subSize.width = subSize.height * subRate;
        }
        else {
            
            subSize.width = superSize.height;
            subSize.height = subSize.width / subRate;
        }
    }
    
    return subSize;
}

/**
 * @return: 返回父视图的大小
 * @superRate: 父视图的比例
 * @subSize: 子视图的大小
 * @type: 限制类型
 */
+ (CGSize)getSuperSizeWithSuperRate:(CGFloat)superRate subSize:(CGSize)subSize type:(ConstraintType)type
{
    if (superRate == 0) {
        return subSize;
    }
    
    CGFloat subRate = subSize.width / subSize.height;
    
    CGSize superSize = CGSizeZero;
    
    if (type == ConstraintTypeSmall) {
        if (subRate > superRate) {
            superSize.width = subSize.width;
            superSize.height = superSize.width / superRate;
        }
        else {
            superSize.height = subSize.height;
            superSize.width = superSize.height * superRate;
        }
    }
    else if (type == ConstraintTypeLarge) {
        if (subRate > superRate) {
            superSize.height = subSize.height;
            superSize.width = superSize.height * superRate;
        }
        else {
            superSize.width = subSize.width;
            superSize.height = superSize.width / superRate;
        }
        
    }
    else {
        
    }
    
    return superSize;
}


#pragma mark - CGRect

/**
 * @return: 返回子视图的frame
 * @subSize: 子视图的size
 * @superRect: 父视图的frame
 * @alignment: 对齐
 */
+ (CGRect)getSubRectWithSubSize:(CGSize)subSize superRect:(CGRect)superRect alignment:(ContraintAlignment)alignment
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    if ((alignment & ContraintAlignmentLeft) == ContraintAlignmentLeft) {
        x = CGRectGetMinX(superRect);
    }
    if ((alignment & ContraintAlignmentRight) == ContraintAlignmentRight) {
        x = CGRectGetMaxX(superRect) - subSize.width;
    }
    if ((alignment & ContraintAlignmentCenterX) == ContraintAlignmentCenterX) {
        x = CGRectGetMidX(superRect) - subSize.width/2;
    }
    if ((alignment & ContraintAlignmentTop) == ContraintAlignmentTop) {
        y = CGRectGetMinY(superRect);
    }
    if ((alignment & ContraintAlignmentBottom) == ContraintAlignmentBottom) {
        y = CGRectGetMaxY(superRect) - subSize.height;
    }
    if ((alignment & ContraintAlignmentCenterY) == ContraintAlignmentCenterY) {
        y = CGRectGetMidY(superRect) - subSize.height/2;
    }
    if (alignment == ContraintAlignmentCenter) {
        x = CGRectGetMidX(superRect) - subSize.width/2;
        y = CGRectGetMidY(superRect) - subSize.height/2;
    }
    
    return CGRectMake(x, y, subSize.width, subSize.height);
}

/**
 * @return: 返回子视图的frame
 * @subImage: 子视图的图片
 * @edge: 约束屏幕边缘
 */
+ (CGRect)getSubRectWithSubImage:(UIImage *)subImage edge:(ConstraintEdge)edge alignment:(ContraintAlignment)alignment
{
    CGRect rect = CGRectZero;
    
    if (subImage) {
        rect = [self getSubRectWithSubRate:subImage.size.width/subImage.size.height edge:edge alignment:alignment];
    }
    
    return rect;
}

/**
 * @return: 返回子视图的frame
 * @subImageRate: 子视图的图片的比例
 * @edge: 约束边缘
 */
+ (CGRect)getSubRectWithSubRate:(CGFloat)subRate edge:(ConstraintEdge)edge alignment:(ContraintAlignment)alignment
{
    CGSize superSize = CGSizeMake(SCREEN_WIDTH - edge.left - edge.right,
                                  SCREEN_HEIGHT - edge.top - edge.bottom);
    CGSize subSize = [self getSubSizeWithSubRate:subRate
                                       superSize:superSize
                                            type:ConstraintTypeSmall];
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    if ((alignment & ContraintAlignmentLeft) == ContraintAlignmentLeft) {
        x = edge.left;
    }
    if ((alignment & ContraintAlignmentRight) == ContraintAlignmentRight) {
        x = SCREEN_WIDTH - subSize.width - edge.right;
    }
    if ((alignment & ContraintAlignmentCenterX) == ContraintAlignmentCenterX) {
        x = (SCREEN_WIDTH - edge.left - edge.right - subSize.width)/2 + edge.left;
    }
    if ((alignment & ContraintAlignmentTop) == ContraintAlignmentTop) {
        y = edge.top;
    }
    if ((alignment & ContraintAlignmentBottom) == ContraintAlignmentBottom) {
        y = SCREEN_HEIGHT - subSize.height - edge.bottom;
    }
    if ((alignment & ContraintAlignmentCenterY) == ContraintAlignmentCenterY) {
        y = (SCREEN_HEIGHT - edge.top - edge.bottom - subSize.height)/2 + edge.top;
    }
    if (alignment == ContraintAlignmentCenter) {
        x = (SCREEN_WIDTH - edge.left - edge.right - subSize.width)/2 + edge.left;
        y = (SCREEN_HEIGHT - edge.top - edge.bottom - subSize.height)/2 + edge.top;
    }
    
    CGRect rect = CGRectMake(x, y, subSize.width, subSize.height);
    
    return rect;
}


/*
 
 错误：
 
 平移：
 | 1  0  0 |
 t1 = | 0  1  0 |
 | dx dy 1 |
 
 缩放：
 | sx 0  0|
 t2 = | 0  sy 0|
 | 0  0  1|
 
 旋转：
 |  cos(angle)  sin(angle)  0 |
 t3 = | -sin(angle)  cos(angle)  0 |
 |  0           0           1 |
 
 
 平移、缩放、旋转：
 
 t = t1 * t2 * t3
 
 |  sx * cos(angle)                              sx * sin(angle)                              0 |
 = | -sy * sin(angle)                              sy * cos(angle)                              0 |
 |  sx * dx * cos(angle) - sy * dy * sin(angle)  sx * dx * sin(angle) + sy * dy * cos(angle)  1 |
 
 因为，
 | a  b  0 |
 t = | c  d  0 |
 | tx ty 1 |
 
 所以，
 a = sx * cos(angle)
 b = sx * sin(angle)
 c = -sy * sin(angle)
 d = sy * cos(angle)
 tx = sx * dx * cos(angle) - sy * dy * sin(angle)
 ty = sx * dx * sin(angle) + sy * dy * cos(angle)
 
 */

/*
 
 正确：
 
 缩放：
 | sx 0  0|
 t1 = | 0  sy 0|
 | 0  0  1|
 
 
 旋转：
 |  cos(angle)  sin(angle)  0 |
 t2 = | -sin(angle)  cos(angle)  0 |
 |  0           0           1 |
 
 
 平移：
 | 1  0  0 |
 t3 = | 0  1  0 |
 | dx dy 1 |
 
 
 缩放、旋转、平移：
 
 t = t1 * t2 * t3
 
 |  sx * cos(angle)    sx * sin(angle)     0 |
 = | -sy * sin(angle)    sy * cos(angle)     0 |
 |  dx                 dy                  1 |
 
 因为，
 | a  b  0 |
 t = | c  d  0 |
 | tx ty 1 |
 
 所以，
 a = sx * cos(angle)
 b = sx * sin(angle)
 c = -sy * sin(angle)
 d = sy * cos(angle)
 tx = dx
 ty = dy
 
 */


//返回弧度，范围为[0， 2Pi]
+ (CGFloat)radianWithCGAffineTransform:(CGAffineTransform)t {
    double sx = [self scaleXWithCGAffineTransform:t];
    double cos_radian = t.a / sx;
    double sin_radian = t.b / sx;
    double radian = acos(cos_radian);//[0, PI];
    
    //    NSLog(@"sx =%f", sx);
    //    NSLog(@"cos_randian=%f", cos_radian);
    //    NSLog(@"sin_randian=%f", sin_radian);
    //    NSLog(@"angle=%f", radian * 180 / M_PI);
    //sin(angle) > 0
    if (sin_radian > 0)
    {
        radian = radian;
    }
    //sin(angle) < 0
    else if (sin_radian < 0)
    {
        radian = 2 * M_PI - radian;
    }
    //sin(angle) = 0
    else  {
        //cos(angle) == 1
        if (cos_radian > 0)
        {
            radian = radian;
        }
        //cos(angle) == -1
        else
        {
            radian = 2* M_PI - radian;
        }
    }
    return radian;
}

+ (CGFloat)scaleXWithCGAffineTransform:(CGAffineTransform)t {
    return sqrt(pow(t.a, 2)  + pow(t.b, 2));
}

+ (CGFloat)scaleYWithCGAffineTransform:(CGAffineTransform)t {
    return sqrt(pow(t.c, 2) + pow(t.d, 2));
}

+ (void)translateWithCGAffineTranform:(CGAffineTransform)t tx:(CGFloat *)tx ty:(CGFloat *)ty {
    float dx = t.tx;
    float dy = t.ty;
    
    *tx = dx;
    *ty = dy;
}


/*
 P(x, y) -> P'(x', y')
 
 x' = a * x + c * y + tx
 y' = b * x + d * y + ty
 
 
 S(w, h) -> S'(w', h')
 
 w' = a * w + c * h'
 h' = b * w + d * h'
 
 */


//获取变换后的point: CGPointApplyAffineTransform(CGPoint point, CGAffineTransform t)
//获取变换后的size: CGSizeApplyAffineTransform(CGSize size, CGAffineTransform t)
//获取变换后的rect: CGRectApplyAffineTransform(CGRect rect, CGAffineTransform t)


//以Rect的中心为原点
+ (CGRect)CGRectForCenterWithAffineTransform:(CGAffineTransform)t CGRect:(CGRect)rect {
    float cx = rect.origin.x + rect.size.width / 2;
    float cy = rect.origin.y + rect.size.height / 2;
    
    //将rect的中心设为原点
    CGPoint center = CGPointMake(cx, cy);
    rect.origin.x = rect.origin.x - center.x;
    rect.origin.y = rect.origin.y - center.y;
    
    //恢恢复rect的中心为原来的位置
    CGRect rect_0 = CGRectApplyAffineTransform(rect, t);
    rect_0.origin.x = rect_0.origin.x + center.x;
    rect_0.origin.y = rect_0.origin.y + center.y;
    
    return rect_0;
}



@end

//
//  BCConstraint.h
//  BCPhoto
//
//  Created by admin on 16/12/7.
//  Copyright © 2016年 admin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct _ConstraintEdge {
    CGFloat left;
    CGFloat right;
    CGFloat top;
    CGFloat bottom;
    
} ConstraintEdge;

static ConstraintEdge constraintEdgeZero = {0.0, 0.0 ,0.0 ,0.0};
inline static ConstraintEdge constraintEdgeMake(CGFloat left, CGFloat right, CGFloat top, CGFloat bottom) {
    ConstraintEdge edge = constraintEdgeZero;
    edge.left = left;
    edge.right = right;
    edge.top = top;
    edge.bottom = bottom;
    
    return edge;
}

typedef NS_OPTIONS(NSInteger, ContraintAlignment) {
    ContraintAlignmentCenter    = 0,
    ContraintAlignmentLeft      = 1 << 1,
    ContraintAlignmentRight     = 1 << 2,
    ContraintAlignmentCenterX   = 1 << 3,
    ContraintAlignmentTop       = 1 << 4,
    ContraintAlignmentBottom    = 1 << 5,
    ContraintAlignmentCenterY   = 1 << 6,
};

typedef NS_ENUM(NSInteger, ConstraintType) {
    ConstraintTypeSmall,
    ConstraintTypeLarge
};


@interface BCConstraint : NSObject


#pragma - CGSize

/**
 * @return: 返回子视图的大小
 * @subRate: 子视图的比例
 * @superSize: 父视图的大小
 * @type: 限制类型
 */
+ (CGSize)getSubSizeWithSubRate:(CGFloat)subRate superSize:(CGSize)superSize type:(ConstraintType)type;

/**
 * @return: 返回父视图的大小
 * @superRate: 父视图的比例
 * @subSize: 子视图的大小
 * @type: 限制类型
 */
+ (CGSize)getSuperSizeWithSuperRate:(CGFloat)superRate subSize:(CGSize)subSize type:(ConstraintType)type;



#pragma mark - CGRect

/**
 * @return: 返回子视图的frame
 * @subSize: 子视图的size
 * @superRect: 父视图的frame
 * @alignment: 对齐
 */
+ (CGRect)getSubRectWithSubSize:(CGSize)subSize superRect:(CGRect)superRect alignment:(ContraintAlignment)alignment;


/**
 * @return: 返回子视图的frame
 * @subImage: 子视图的图片
 * @edge: 约束边缘
 */
+ (CGRect)getSubRectWithSubImage:(UIImage *)subImage edge:(ConstraintEdge)edge alignment:(ContraintAlignment)alignment;

/**
 * @return: 返回子视图的frame
 * @subImageRate: 子视图的比例
 * @edge: 约束边缘
 */
+ (CGRect)getSubRectWithSubRate:(CGFloat)subRate edge:(ConstraintEdge)edge alignment:(ContraintAlignment)alignment;

+ (CGFloat)radianWithCGAffineTransform:(CGAffineTransform)t;

+ (CGFloat)scaleXWithCGAffineTransform:(CGAffineTransform)t;

+ (CGFloat)scaleYWithCGAffineTransform:(CGAffineTransform)t;

+ (void)translateWithCGAffineTranform:(CGAffineTransform)t tx:(CGFloat *)tx ty:(CGFloat *)ty;

+ (CGRect)CGRectForCenterWithAffineTransform:(CGAffineTransform)t CGRect:(CGRect)rect;

@end
//
//  BCMaskView.h
//  BCPhoto
//
//  Created by admin on 16/12/6.
//  Copyright © 2016年 admin. All rights reserved.
//


#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ClipType) {
    ClipTypeProportionAtWill,
    ClipTypeProportion_1_1,
    ClipTypeProportion_2_3,
    ClipTypeProportion_3_2,
    ClipTypeProportion_4_3,
    ClipTypeProportion_3_4,
    ClipTypeProportion_16_9,
    ClipTypeProportion_9_16,
};


@class ClipMoveView;
@class ClipMaskView;


@protocol ClipMaskViewDelegate <NSObject>

- (void)willMoveWithMoveView:(ClipMoveView *)moveView inClipMaskView:(ClipMaskView *)clipMaskView;
- (void)isMovingWithMoveView:(ClipMoveView *)moveView inClipMaskView:(ClipMaskView *)clipMaskView;
- (void)hasMovedWithMoveView:(ClipMoveView *)moveView inClipMaskView:(ClipMaskView *)clipMaskView;

@end

@protocol ClipMoveViewDelegate <NSObject>

- (void)willMoveWithMoveView:(ClipMoveView *)moveView;
- (void)isMovingWithMoveView:(ClipMoveView *)moveView;
- (void)hasMovedWithMoveView:(ClipMoveView *)moveView;

@end


@interface ClipMoveView : UIView
@property (nonatomic, weak) id <ClipMoveViewDelegate> delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;

@end



@interface BCMaskView : UIView <ClipMoveViewDelegate>{
    
    CGPoint _touchBeginPoint,_moveViewBeginPoint;
}

@property (nonatomic, weak) id <ClipMaskViewDelegate> delegate;
@property (nonatomic, retain) ClipMoveView *leftUpView;
@property (nonatomic, retain) ClipMoveView *rightUpView;
@property (nonatomic, retain) ClipMoveView *leftDownView;
@property (nonatomic, retain) ClipMoveView *rightDownView;
@property (nonatomic, retain) ClipMoveView *upView;
@property (nonatomic, retain) ClipMoveView *downView;
@property (nonatomic, retain) ClipMoveView *leftView;
@property (nonatomic, retain) ClipMoveView *rightView;
@property (nonatomic, retain) ClipMoveView *currentMoveView;
@property (nonatomic, retain) UIView *insideView;
@property (nonatomic, assign) CGRect insideRect;
@property (nonatomic, assign) CGRect outsideRect;
@property (nonatomic, assign) CGRect limitRect;
@property (nonatomic, assign) CGFloat proportion;
@property (nonatomic, assign) ClipType type;
@property (nonatomic, assign) CGFloat minInsideInterval;
@property (nonatomic, assign, getter=isShowInsideLine) BOOL showInsideLine;
@property (nonatomic, assign, getter=isShowAssistLine) BOOL showAssistLine;


- (void)resetInsideRectWithType:(ClipType)type;

- (ClipType)reversalType;

@end
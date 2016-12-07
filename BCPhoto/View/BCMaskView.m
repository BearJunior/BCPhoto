//
//  BCMaskView.m
//  BCPhoto
//
//  Created by admin on 16/12/6.
//  Copyright © 25.0/216年 admin. All rights reserved.
//


#import "BCMaskView.h"
#import "BCGestureFun.h"
#import "BCConstraint.h"
#import "BCGeometryFun.h"
#import "BCFitHeader.h"


typedef NS_ENUM(NSInteger, ClipCornerType) {
    
    ClipCornerTypeUp,
    ClipCornerTypeLeft,
    ClipCornerTypeDown,
    ClipCornerTypeRight,
    
    ClipCornerTypeLeftUp,
    ClipCornerTypeRightUp,
    ClipCornerTypeLeftDown,
    ClipCornerTypeRightDown
};


@implementation ClipMoveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
        //        [self addGestureRecognizer:pan];
        //        [pan addTarget:self action:@selector(pan:)];
        
        self.imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            [self addSubview:imageView];
            imageView.image = _image;
            imageView;
        });
        
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    super.frame = frame;
    
    self.imageView.frame = self.bounds;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)pan:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        performSelectInDelegateWithSender(self.delegate, @selector(willMoveWithMoveView:), self);
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        [BCGestureFun panChangedWithGesture:sender];
        
        performSelectInDelegateWithSender(self.delegate, @selector(isMovingWithMoveView:), self);
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        performSelectInDelegateWithSender(self.delegate, @selector(hasMovedWithMoveView:), self);
    }
    else if (sender.state == UIGestureRecognizerStateCancelled) {
        
    }
}

@end

@interface BCMaskView ()

{
    UIPanGestureRecognizer *_panGR;
}

@end

@implementation BCMaskView


#pragma mark -
#pragma mark 初始化界面

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.type = ClipTypeProportionAtWill;
        self.showInsideLine = YES;
        self.showAssistLine = YES;
        self.minInsideInterval = 25;
        
        [self initInsideView];   //内部的移动view
        [self initCornerViews];  //添加四个角
    }
    
    return self;
}

- (void)initCornerViews
{
    
    self.leftUpView = [self addCornerViewWithType:ClipCornerTypeLeftUp];
    self.leftDownView = [self addCornerViewWithType:ClipCornerTypeLeftDown];
    self.rightUpView = [self addCornerViewWithType:ClipCornerTypeRightUp];
    self.rightDownView = [self addCornerViewWithType:ClipCornerTypeRightDown];
    
    
    self.upView = [self addCornerViewWithType:ClipCornerTypeUp];
    self.leftView = [self addCornerViewWithType:ClipCornerTypeLeft];
    self.rightView = [self addCornerViewWithType:ClipCornerTypeRight];
    self.downView = [self addCornerViewWithType:ClipCornerTypeDown];
    
    
    [self bringSubviewToFront:self.leftUpView];
    [self bringSubviewToFront:self.leftDownView];
    [self bringSubviewToFront:self.rightUpView];
    [self bringSubviewToFront:self.rightDownView];
    
}

- (void)initInsideView
{
    self.insideView = ({
        UIView *insideView = [[UIView alloc] init];
        [self addSubview:insideView];
        insideView.frame = _insideRect;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInsideView:)];
        [insideView addGestureRecognizer:panGesture];
        _panGR = panGesture;
        insideView;
    });
}

- (ClipMoveView *)addCornerViewWithType:(ClipCornerType)type
{
    ClipMoveView *view = [[ClipMoveView alloc] init];
    [self addSubview:view];
    view.delegate = self;
    
    [self updateCorner:view];
    
    return view;
}


#pragma mark -
#pragma mark 界面调整

- (void)updateAllCorner
{
    [self updateCorner:self.leftUpView];
    [self updateCorner:self.leftDownView];
    [self updateCorner:self.rightUpView];
    [self updateCorner:self.rightDownView];
    
    [self updateCorner:self.upView];
    [self updateCorner:self.downView];
    [self updateCorner:self.rightView];
    [self updateCorner:self.leftView];
    
    
}

- (void)updateOtherCornerWithOneCorner:(ClipMoveView *)oneCorner
{
    //调整位置
    //centerX相同
    void (^xAdjustWithCorner)(ClipMoveView *corner) = ^(ClipMoveView * corner) {
        CGPoint center = corner.center;
        center.x = oneCorner.center.x;
        corner.center = center;
    };
    //centerY相同
    void (^yAdjustWithCorner)(ClipMoveView *corner) = ^(ClipMoveView * corner) {
        CGPoint center = corner.center;
        center.y = oneCorner.center.y;
        corner.center = center;
    };
    
    //和originX相距y
    void (^minXAdjustWithCorner)(ClipMoveView *corner,float y) = ^(ClipMoveView * corner,float y) {
        CGRect frame = corner.frame;
        frame.origin.x = CGRectGetMinX(oneCorner.frame) + y;
        corner.frame = frame;
    };
    //和originY相距y
    void (^minYAdjustWithCorner)(ClipMoveView *corner,float y) = ^(ClipMoveView * corner,float y) {
        
        CGRect frame = corner.frame;
        frame.origin.y = CGRectGetMinY(oneCorner.frame) + y;
        corner.frame = frame;
    };
    
    //和MaxX相距y
    void (^maxXAdjustWithCorner)(ClipMoveView *corner,float y) = ^(ClipMoveView * corner,float y) {
        CGRect frame = corner.frame;
        frame.origin.x = CGRectGetMaxX(oneCorner.frame) + y;
        corner.frame = frame;
    };
    //和MaxY相距y
    void (^maxYAdjustWithCorner)(ClipMoveView *corner,float y) = ^(ClipMoveView * corner,float y) {
        
        CGRect frame = corner.frame;
        frame.origin.y = CGRectGetMaxY(oneCorner.frame) + y;
        corner.frame = frame;
    };
    
    
    
    void(^wAdjustWithCorner)(ClipMoveView *corner) = ^(ClipMoveView *corner) {
        
        CGPoint center = corner.center;
        CGRect frame = corner.frame;
        frame.size.width = CGRectGetMinX(_rightUpView.frame) - CGRectGetMaxX(_leftUpView.frame);
        corner.frame = frame;
        corner.center = center;
    };
    
    void(^hAdjustWithCorner)(ClipMoveView *corner) = ^(ClipMoveView *corner) {
        
        CGPoint center = corner.center;
        CGRect frame = corner.frame;
        frame.size.height = CGRectGetMinY(_rightDownView.frame) - CGRectGetMaxY(_rightUpView.frame);
        corner.frame = frame;
        corner.center = center;
    };
    
    
    //左上
    if (oneCorner == self.leftUpView) {
        
        //左下
        xAdjustWithCorner(self.leftDownView);
        
        //右上
        yAdjustWithCorner(self.rightUpView);
        
        //上
        minYAdjustWithCorner(self.upView,CGRectGetWidth(self.upView.frame)/2);
        wAdjustWithCorner(self.upView);
        
        
        //左
        minXAdjustWithCorner(self.leftView,CGRectGetWidth(self.leftView.frame)/2);
        hAdjustWithCorner(self.leftView);
        
        
        wAdjustWithCorner(self.downView);
        
    }
    //右上
    else if (oneCorner == self.rightUpView) {
        
        //左上
        yAdjustWithCorner(self.leftUpView);
        
        //右下
        xAdjustWithCorner(self.rightDownView);
        
        //上
        minYAdjustWithCorner(self.upView,CGRectGetWidth(self.upView.frame)/2);
        wAdjustWithCorner(self.upView);
        
        
        //右
        maxXAdjustWithCorner(self.rightView,0);
        hAdjustWithCorner(self.rightView);
        
        
        //下
        wAdjustWithCorner(self.downView);
        
    }
    //左下
    else if (oneCorner == self.leftDownView) {
        
        //左上
        xAdjustWithCorner(self.leftUpView);
        
        //右下
        yAdjustWithCorner(self.rightDownView);
        
        //左
        maxXAdjustWithCorner(self.leftView,0);
        hAdjustWithCorner(self.leftView);
        
        
        //下
        maxYAdjustWithCorner(self.downView,0);
        wAdjustWithCorner(self.downView);
        
        
        //上
        wAdjustWithCorner(self.upView);
        
    }
    //右下
    else if (oneCorner == self.rightDownView) {
        
        //左下
        yAdjustWithCorner(self.leftDownView);
        
        //右上
        xAdjustWithCorner(self.rightUpView);
        
        
        //右
        maxXAdjustWithCorner(self.rightView,0);
        hAdjustWithCorner(self.rightView);
        
        
        //下
        maxYAdjustWithCorner(self.downView,0);
        wAdjustWithCorner(self.downView);
        
        
        //上
        wAdjustWithCorner(self.upView);
        
    }
    if (_type != ClipTypeProportionAtWill) {
        //上
        if (oneCorner == self.upView) {
            
            
            maxYAdjustWithCorner(self.rightUpView,-CGRectGetHeight(self.rightUpView.frame)/2);
            maxYAdjustWithCorner(self.leftUpView,-CGRectGetHeight(self.leftUpView.frame)/2);
            maxXAdjustWithCorner(self.rightUpView,0);
            minXAdjustWithCorner(self.leftUpView,-CGRectGetWidth(self.leftUpView.frame));
            
            CGPoint center = self.leftDownView.center;
            self.leftDownView.center = CGPointMake(self.leftUpView.center.x, center.y);
            self.rightDownView.center = CGPointMake(self.rightUpView.center.x, center.y);
            
            hAdjustWithCorner(self.rightView);
            hAdjustWithCorner(self.leftView);
            
        }
        //下
        else if (oneCorner == self.downView) {
            
            minYAdjustWithCorner(self.leftDownView,-CGRectGetHeight(self.leftDownView.frame)/2);
            minYAdjustWithCorner(self.rightDownView,-CGRectGetHeight(self.rightDownView.frame)/2);
            maxXAdjustWithCorner(self.rightDownView,0);
            minXAdjustWithCorner(self.leftDownView,-CGRectGetWidth(self.leftDownView.frame));
            
            CGPoint center = self.leftUpView.center;
            self.leftUpView.center = CGPointMake(self.leftDownView.center.x, center.y);
            self.rightUpView.center = CGPointMake(self.rightDownView.center.x, center.y);
            
            hAdjustWithCorner(self.rightView);
            hAdjustWithCorner(self.leftView);
            
        }
        //右
        else if (oneCorner == self.rightView) {
            
            minXAdjustWithCorner(self.rightUpView,-CGRectGetWidth(self.rightUpView.frame)/2);
            minXAdjustWithCorner(self.rightDownView,-CGRectGetWidth(self.rightDownView.frame)/2);
            minYAdjustWithCorner(self.rightUpView,-25);
            maxYAdjustWithCorner(self.rightDownView,0);
            
            CGPoint center = self.leftDownView.center;
            self.leftUpView.center = CGPointMake(center.x, self.rightUpView.center.y);
            self.leftDownView.center = CGPointMake(center.x, self.rightDownView.center.y);
            
            hAdjustWithCorner(self.downView);
            hAdjustWithCorner(self.upView);
            
        }
        //左
        else if (oneCorner == self.leftView) {
            
            maxXAdjustWithCorner(self.leftUpView,-CGRectGetWidth(self.leftUpView.frame)/2);
            maxXAdjustWithCorner(self.leftDownView,-CGRectGetWidth(self.leftUpView.frame)/2);
            minYAdjustWithCorner(self.leftUpView,-25);
            maxYAdjustWithCorner(self.leftDownView,0);
            
            CGPoint center = self.rightUpView.center;
            self.rightUpView.center = CGPointMake(center.x, self.leftUpView.center.y);
            self.rightDownView.center = CGPointMake(center.x, self.leftDownView.center.y);
            
            hAdjustWithCorner(self.downView);
            hAdjustWithCorner(self.upView);
            
        }
        else {
            
        }
    }else
    {
        //上
        if (oneCorner == self.upView) {
            
            maxYAdjustWithCorner(self.rightUpView,-CGRectGetHeight(self.rightUpView.frame)/2);
            maxYAdjustWithCorner(self.leftUpView,-CGRectGetHeight(self.leftUpView.frame)/2);
            
            
            
            hAdjustWithCorner(self.rightView);
            hAdjustWithCorner(self.leftView);
            
            
        }
        //下
        else if (oneCorner == self.downView) {
            
            minYAdjustWithCorner(self.leftDownView,-CGRectGetHeight(self.leftDownView.frame)/2);
            minYAdjustWithCorner(self.rightDownView,-CGRectGetHeight(self.rightDownView.frame)/2);
            
            hAdjustWithCorner(self.rightView);
            hAdjustWithCorner(self.leftView);
            
        }
        //右
        else if (oneCorner == self.rightView) {
            
            minXAdjustWithCorner(self.rightUpView,-CGRectGetWidth(self.rightUpView.frame)/2);
            minXAdjustWithCorner(self.rightDownView,-CGRectGetWidth(self.rightDownView.frame)/2);
            
            hAdjustWithCorner(self.downView);
            hAdjustWithCorner(self.upView);
            
        }
        //左
        else if (oneCorner == self.leftView) {
            
            maxXAdjustWithCorner(self.leftUpView,-CGRectGetWidth(self.leftUpView.frame)/2);
            maxXAdjustWithCorner(self.leftDownView,-CGRectGetWidth(self.leftUpView.frame)/2);
            
            hAdjustWithCorner(self.downView);
            hAdjustWithCorner(self.upView);
            
        }
        else {
            
        }
    }
    
}

- (void)updateInsideRect
{
    CGFloat x = viewMinX(self.leftUpView);
    CGFloat y = viewMinY(self.leftUpView);
    CGFloat w = viewMaxX(self.rightDownView) - x;
    CGFloat h = viewMaxY(self.rightDownView) - y;
    
    self.insideRect = CGRectMake(x, y, w, h);
}

- (void)updateByInsideView
{
    self.insideRect = _insideView.frame;
    
    [self updateAllCorner];
}

- (void)updateCorner:(ClipMoveView *)corner
{
    UIImage *cornerImage = [UIImage imageNamed:@"操控点"];
    cornerImage = [UIImage imageWithCGImage:cornerImage.CGImage scale:2 orientation:UIImageOrientationUp];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = imageWidth(cornerImage);
    CGFloat height = imageHeight(cornerImage);
    
    if (corner == self.leftUpView) {
        cornerImage = [UIImage imageWithCGImage:cornerImage.CGImage scale:2 orientation:UIImageOrientationRightMirrored];
        
        x = rectMinX(_insideRect);
        y = rectMinY(_insideRect);
    }
    else if (corner == self.leftDownView) {
        
        cornerImage = [UIImage imageWithCGImage:cornerImage.CGImage scale:2 orientation:UIImageOrientationUpMirrored];
        x = rectMinX(_insideRect);
        y = rectMaxY(_insideRect) - width;
    }
    else if (corner == self.rightUpView) {
        
        cornerImage = [UIImage imageWithCGImage:cornerImage.CGImage scale:2 orientation:UIImageOrientationLeft];
        x = rectMaxX(_insideRect) - width;
        y = rectMinY(_insideRect);
    }
    else if (corner == self.rightDownView) {
        
        cornerImage = [UIImage imageWithCGImage:cornerImage.CGImage scale:2 orientation:UIImageOrientationUp];
        x = rectMaxX(_insideRect) - width;
        y = rectMaxY(_insideRect) - width;
    }
    else if (corner == self.upView) {
        
        
        x = rectMinX(_insideRect) + width;
        y = rectMinY(_insideRect) - height/2;
        
        width = rectMaxX(_insideRect) - rectMinX(_insideRect) - width * 2;
        
        cornerImage  = nil;
        
    }
    else if (corner == self.downView) {
        
        x = rectMinX(_insideRect) + width;
        y = rectMaxY(_insideRect) - height/2;
        
        width = rectMaxX(_insideRect) - rectMinX(_insideRect) - width * 2;
        
        cornerImage  = nil;
        
    }else if (corner == self.leftView) {
        
        
        x = rectMinX(_insideRect) - width/2;
        y = rectMinY(_insideRect) + height;
        
        height = rectMaxY(_insideRect) - rectMinY(_insideRect) - height * 2;
        cornerImage  = nil;
    }
    
    else if (corner == self.rightView) {
        
        x = rectMaxX(_insideRect) - width/2;
        y = rectMinY(_insideRect) + height;
        
        height = rectMaxY(_insideRect) - rectMinY(_insideRect) - height * 2 ;

        cornerImage  = nil;
        ;
    }
    else {
        
    }
    
    
    corner.image = cornerImage;
    corner.frame = CGRectMake(x, y, width, height);
}

- (void)limitInsideIntervalWithCorner:(ClipMoveView *)corner
{
    void (^minX)() = ^{
        if (viewMinX(corner) > viewMaxX(self.rightUpView) - _minInsideInterval) {
            CGRect frame = corner.frame;
            frame.origin.x = viewMaxX(self.rightUpView) - _minInsideInterval;
            corner.frame = frame;
        }
    };
    
    void (^maxX)() = ^{
        if (viewMinX(corner) < viewMinX(self.leftUpView) + _minInsideInterval - viewWidth(corner)) {
            CGRect frame = corner.frame;
            frame.origin.x = viewMinX(self.leftUpView) + _minInsideInterval - viewWidth(corner);
            corner.frame = frame;
        }
    };
    
    void (^minY)() = ^{
        if (viewMinY(corner) > viewMaxY(self.leftDownView) - _minInsideInterval) {
            CGRect frame = corner.frame;
            frame.origin.y = viewMaxY(self.leftDownView) - _minInsideInterval;
            corner.frame = frame;
        }
    };
    
    void (^maxY)() = ^{
        if (viewMinY(corner) < viewMinY(self.leftUpView) + _minInsideInterval - viewHeight(corner)) {
            CGRect frame = corner.frame;
            frame.origin.y = viewMinY(self.leftUpView) + _minInsideInterval - viewHeight(corner);
            corner.frame = frame;
        }
    };
    
    if (corner == self.leftUpView) {
        minX();
        minY();
    }
    else if (corner == self.rightUpView) {
        maxX();
        minY();
    }
    else if (corner == self.leftDownView) {
        minX();
        maxY();
    }
    else if (corner == self.rightDownView) {
        maxX();
        maxY();
        
    }
    
    else {
        
    }
}


#pragma mark -
#pragma mark Accessor

- (void)setType:(ClipType)type
{
    _type = type;
    switch (type) {
        case ClipTypeProportion_16_9:
            self.proportion = 16.0/9.0;
            break;
            
        case ClipTypeProportion_9_16:
            self.proportion = 9.0/16.0;
            break;
            
        case ClipTypeProportion_1_1:
            self.proportion = 1.0;
            break;
            
        case ClipTypeProportion_2_3:
            self.proportion = 2.0/3.0;
            break;
            
        case ClipTypeProportion_3_2:
            self.proportion = 3.0/2.0;
            break;
            
        case ClipTypeProportion_3_4:
            self.proportion = 3.0/4.0;
            break;
            
        case ClipTypeProportion_4_3:
            self.proportion = 4.0/3.0;
            break;
            
        case ClipTypeProportionAtWill:
            self.proportion = rectWidth(_limitRect)/rectHeight(_limitRect);
            break;
            
        default:
            self.proportion = rectWidth(_limitRect)/rectHeight(_limitRect);
            break;
    }
    
    BOOL userInteractionEnabled = type == ClipTypeProportionAtWill;
    _upView.userInteractionEnabled = userInteractionEnabled;
    _downView.userInteractionEnabled = userInteractionEnabled;
    _leftView.userInteractionEnabled = userInteractionEnabled;
    _rightView.userInteractionEnabled = userInteractionEnabled;
    
}


- (ClipType )reversalType{
    
    ClipType type = _type;
    
    
    switch (type) {
        case ClipTypeProportion_9_16:
            self.proportion = 16.0/9.0;
            type = ClipTypeProportion_16_9;
            break;
            
        case ClipTypeProportion_16_9:
            self.proportion = 9.0/16.0;
            type = ClipTypeProportion_9_16;
            break;
            
        case ClipTypeProportion_1_1:
            self.proportion = 1.0;
            type = ClipTypeProportion_1_1;
            break;
            
        case ClipTypeProportion_3_2:
            self.proportion = 2.0/3.0;
            type = ClipTypeProportion_2_3;
            break;
            
        case ClipTypeProportion_2_3:
            self.proportion = 3.0/2.0;
            type = ClipTypeProportion_3_2;
            break;
            
        case ClipTypeProportion_4_3:
            self.proportion = 3.0/4.0;
            type = ClipTypeProportion_3_4;
            break;
            
        case ClipTypeProportion_3_4:
            self.proportion = 4.0/3.0;
            type = ClipTypeProportion_4_3;
            break;
            
        case ClipTypeProportionAtWill:
            self.proportion = rectWidth(_limitRect)/rectHeight(_limitRect);
            
            break;
            
        default:
            self.proportion = rectWidth(_limitRect)/rectHeight(_limitRect);
            break;
    }
    
    _type = type;
    
    return type;
}

- (void)setOutsideRect:(CGRect)outsideRect
{
    _outsideRect = outsideRect;
    
    [self setNeedsDisplay];
    
    [self updateAllCorner];
}

- (void)setInsideRect:(CGRect)insideRect
{
    _insideRect = insideRect;
    _insideView.frame = insideRect;
    
    [self setNeedsDisplay];
    
    [self updateAllCorner];
    
}

- (void)resetInsideRectWithType:(ClipType)type
{
    self.type = type;
    
    CGSize size = [BCConstraint getSubSizeWithSubRate:_proportion superSize:_limitRect.size type:ConstraintTypeSmall];
    
    CGRect insideRect = [BCConstraint getSubRectWithSubSize:size superRect:_limitRect alignment:ContraintAlignmentCenter];
    
    self.insideRect = insideRect;
}


#pragma mark -
#pragma mark draw

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置填充颜色
    CGContextAddRect(context, _limitRect);
    UIColor *color = [UIColor colorWithWhite:0 alpha:0.6];
    [color setFill];
    CGContextFillPath(context);
    
    [[UIColor clearColor] setFill];
    
    //路径
    CGMutablePathRef outPath = CGPathCreateMutable();
    CGPathAddRect(outPath, NULL, _outsideRect);
    CGContextAddPath(context, outPath);
    
    //填充路径
    CGContextDrawPath(context, kCGPathFill);
    CGContextClearRect(context, _insideRect);
    
    CFRelease(outPath);
    
    //line
    if (_showInsideLine) {
        
        [[UIColor whiteColor] setStroke];
        
        //横线
        CGFloat x0 = rectMinX(_insideRect);
        CGFloat x1 = rectMaxX(_insideRect);
        
        int numberOfLine = 4;
//        
//        if(_showAssistLine){
//            
//            numberOfLine = 7;
//        }
//        
        
        for (int i = 0; i < numberOfLine; i++) {
            if (i %2 == 0) {
                CGContextSetLineWidth(context, 1);
            }
            else {
                CGContextSetLineWidth(context, 0.5);
            }
            
            CGFloat y = rectMinY(_insideRect) + rectHeight(_insideRect)/(numberOfLine -1) * i;
            
            CGMutablePathRef path = CGPathCreateMutable();
            
            CGPathMoveToPoint(path, NULL, x0, y);
            CGPathAddLineToPoint(path, NULL, x1, y);
            CGContextAddPath(context, path);
            CGContextStrokePath(context);
            CGContextDrawPath(context, kCGPathStroke);
            CGPathRelease(path);
        }
        
        //竖线
        CGFloat y0 = rectMinY(_insideRect);
        CGFloat y1 = rectMaxY(_insideRect);
        
        for (int i = 0; i < numberOfLine; i++) {
            
            if (i %2 == 0) {
                CGContextSetLineWidth(context, 1);
            }
            else {
                CGContextSetLineWidth(context, 0.5);
            }
            
            CGFloat x = rectMinX(_insideRect) + rectWidth(_insideRect)/(numberOfLine-1) * i;
            
            CGMutablePathRef path = CGPathCreateMutable();
            
            CGPathMoveToPoint(path, NULL, x, y0);
            CGPathAddLineToPoint(path, NULL, x, y1);
            
            CGContextAddPath(context, path);
            CGContextStrokePath(context);
            CGContextDrawPath(context, kCGPathStroke);
            
            CGPathRelease(path);
        }
    }
}


#pragma mark -
#pragma mark 手势

- (void)panInsideView:(UIPanGestureRecognizer *)gesture
{
    [BCGestureFun panChangedWithGesture:gesture];
    
    CGFloat x = viewMinX(_insideView);
    CGFloat y = viewMinY(_insideView);
    CGFloat w = viewWidth(_insideView);
    CGFloat h = viewHeight(_insideView);
    
    if (x < rectMinX(_limitRect)) {
        x = rectMinX(_limitRect);
    }
    if (y < rectMinY(_limitRect)) {
        y = rectMinY(_limitRect);
    }
    if (x > rectMaxX(_limitRect) - w) {
        x = rectMaxX(_limitRect) - w;
    }
    if (y > rectMaxY(_limitRect) - h) {
        y = rectMaxY(_limitRect) - h;
    }
    
    _insideView.frame = CGRectMake(x, y, w, h);
    
    [self updateByInsideView];
}


#pragma mark -
#pragma mark ClipMoveViewDelegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    [self setCurrentMoveViewWithTouch:touch];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //没有touchBegan
    if(self.currentMoveView == nil){
        UITouch *touch = [touches anyObject];
        [self setCurrentMoveViewWithTouch:touch];
        //return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint beforePoint = [touch previousLocationInView:self];
    
    float offsetX = touchPoint.x - _touchBeginPoint.x;
    float offsetY = touchPoint.y - _touchBeginPoint.y;
    
    
    if (self.currentMoveView == _leftView || self.currentMoveView == _rightView) {
        offsetY = 0;
    }else if (self.currentMoveView == _upView || self.currentMoveView == _downView){
        offsetX = 0;
    }else{
        
    }
    //上下左右
    if (_type != ClipTypeProportionAtWill && (self.currentMoveView == _upView || self.currentMoveView == _downView || self.currentMoveView == _leftView || self.currentMoveView == _rightView)) {
        
        [self isMovingWithMoveViewSize:self.currentMoveView AndChangePoint:CGPointMake(touchPoint.x - beforePoint.x, touchPoint.y - beforePoint.y)];
    }else
    {
        //四周角落
        //self.currentMoveView.center = CGPointMake(_moveViewBeginPoint.x + offsetX, _moveViewBeginPoint.y + offsetY);
        [self isMovingWithMoveView:self.currentMoveView AndChangePoint:CGPointMake(touchPoint.x - beforePoint.x, touchPoint.y - beforePoint.y)];
        
    }
    
    [self updateCornerAndInside:self.currentMoveView];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    if(self.currentMoveView == nil){
        return;
    }
    
    [self hasMovedWithMoveView:self.currentMoveView];
    self.currentMoveView = nil;
    
    //为防止手势冲突
    if (self.insideView.gestureRecognizers.count == 0) {
        [self.insideView addGestureRecognizer:_panGR];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    if(self.currentMoveView == nil){
        return;
    }
    
    [self hasMovedWithMoveView:self.currentMoveView];

    self.currentMoveView = nil;
}




- (void)willMoveWithMoveView:(ClipMoveView *)moveView
{
    performSelectInDelegateWithSender2(self.delegate, @selector(willMoveWithMoveView:inClipMaskView:), moveView, self);
}

- (void)setCurrentMoveViewWithTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self];
    
    
    CGRect rightUp = _rightUpView.frame;
    CGRect rightDown = _rightDownView.frame;
    CGRect leftUp = _leftUpView.frame;
    CGRect leftDown = _leftDownView.frame;
    
    CGRect rightUpFrame = CGRectMake(CGRectGetMinX(rightUp) , CGRectGetMinY(rightUp) - 25.0/2, CGRectGetWidth(rightUp) + 25.0/2, CGRectGetHeight(rightUp) + 25.0/2);
    CGRect rightDownFrame = CGRectMake(CGRectGetMinX(rightDown) , CGRectGetMinY(rightDown), CGRectGetWidth(rightDown) + 25.0/2, CGRectGetHeight(rightDown) + 25.0/2);
    CGRect leftUpFrame = CGRectMake(CGRectGetMinX(leftUp) - 25.0/2, CGRectGetMinY(leftUp) - 25.0/2, CGRectGetWidth(leftUp) + 25.0/2, CGRectGetHeight(leftUp) + 25.0/2);
    CGRect leftDownFrame = CGRectMake(CGRectGetMinX(leftDown) - 25.0/2, CGRectGetMinY(leftDown) , CGRectGetWidth(leftDown) + 25.0/2, CGRectGetHeight(leftDown) + 25.0/2);
    
    CGRect upFrame = _upView.frame;
    CGRect downFrame = _downView.frame;
    CGRect leftFrame = _leftView.frame;
    CGRect rightFrame = _rightView.frame;
    
    
    _touchBeginPoint = touchPoint;
    
    self.currentMoveView = nil;
    
    if(CGRectContainsPoint(rightUpFrame, touchPoint)){
        self.currentMoveView = _rightUpView;
        
    }else if(CGRectContainsPoint(rightDownFrame, touchPoint)){
        self.currentMoveView = _rightDownView;
        
    }else if(CGRectContainsPoint(leftUpFrame, touchPoint)){
        self.currentMoveView = _leftUpView;
        
    }else if(CGRectContainsPoint(leftDownFrame, touchPoint)){
        self.currentMoveView = _leftDownView;
    }
    
    // else if(_type == ClipTypeProportionAtWill){
    
    else  if(CGRectContainsPoint(upFrame, touchPoint)){
        [self.insideView removeGestureRecognizer:_panGR];
        self.currentMoveView = _upView;
        
    }else if(CGRectContainsPoint(downFrame, touchPoint)){
        [self.insideView removeGestureRecognizer:_panGR];
        self.currentMoveView = _downView;
        
    }else if(CGRectContainsPoint(leftFrame, touchPoint)){
        [self.insideView removeGestureRecognizer:_panGR];
        self.currentMoveView = _leftView;
        
    }else if(CGRectContainsPoint(rightFrame, touchPoint)){
        [self.insideView removeGestureRecognizer:_panGR];
        self.currentMoveView = _rightView;
    }
    
    
    
    // }
    
    if(self.currentMoveView != nil){
        // NSLog(@"moveView:%@",self.currentMoveView);
        _moveViewBeginPoint = self.currentMoveView.center;
        [self willMoveWithMoveView:self.currentMoveView];
    }
}



#pragma mark - 改变moveView的size
- (void)isMovingWithMoveViewSize:(ClipMoveView *)moveView AndChangePoint:(CGPoint)newPoint
{
    //计算改变之后的宽高
    float offsetX = newPoint.x;
    float offsetY = newPoint.y;
    float proportion = self.proportion;
    float width = self.currentMoveView.frame.size.width;
    float height = self.currentMoveView.frame.size.height;
    float distance = 0.0f;//增加的宽/高
    if (self.currentMoveView == _upView) {
        if (offsetY >= 0) {
            width -= fabsf(offsetY) * proportion;
        }else
        {
            width += fabsf(offsetY) * proportion;
        }
    }
    else if (self.currentMoveView == _downView) {
        if (offsetY < 0) {
            width -= fabsf(offsetY) * proportion;
        }else
        {
            width += fabsf(offsetY) * proportion;
        }
    }
    else if (self.currentMoveView == _leftView) {
        if (offsetX >= 0) {
            height -= fabsf(offsetX) / proportion;
        }else
        {
            height += fabsf(offsetX) / proportion;
        }
    }
    else if (self.currentMoveView == _rightView) {
        if (offsetX < 0) {
            height -= fabsf(offsetX) / proportion;
        }else
        {
            height += fabsf(offsetX) / proportion;
        }
    }
    
    if (width != self.currentMoveView.frame.size.width) {
        distance = width - self.currentMoveView.frame.size.width;
    }
    if (height != self.currentMoveView.frame.size.height) {
        distance = height - self.currentMoveView.frame.size.height;
    }
    
    CGFloat x = viewMinX(moveView) + newPoint.x;
    CGFloat y = viewMinY(moveView) + newPoint.y;
    CGFloat w = width;
    CGFloat h = height;
    
    CGFloat minX = rectMinX(_limitRect);
    CGFloat minY = rectMinY(_limitRect);
    CGFloat maxX = rectMaxX(_limitRect);
    CGFloat maxY = rectMaxY(_limitRect);
    
    if(moveView == _downView){
        minX = minX + 25;
        maxX = maxX - 25 - viewWidth(moveView);
        maxY = maxY - viewHeight(moveView)/2;
        x = x - newPoint.x - distance/2;
    }
    
    if (moveView == _upView) {
        minY = minY - viewHeight(moveView)/2;
        minX = minX + 25;
        maxX = maxX - 25 - viewWidth(moveView);
        x = x - newPoint.x - distance/2;
    }
    
    if (moveView == _leftView) {
        minX = minX - viewWidth(moveView)/2;
        minY = minY + 25;
        maxY = maxY - 25 - viewHeight(moveView);
        y = y - newPoint.y - distance/2;
    }
    
    if (moveView == _rightView) {
        minY = minY + 25;
        maxY = maxY - 25 - viewHeight(moveView);
        maxX = maxX - viewWidth(moveView)/2;
        y = y - newPoint.y - distance/2;
    }
    
    //   计算frame
    //拖动moveView到达边界值
    if (moveView == _rightView) {
        if (x > maxX) {
            //x = x + distance/2;
            x = maxX;
            y = viewMinY(moveView);
            w = viewWidth(moveView);
            h = viewHeight(moveView);
        }
    }
    else//拖动moveView使临边的moveView达到边界值
    {
        if (x + w + 25 > rectMaxX(_limitRect)) {
            x = rectMaxX(_limitRect) - 25 - w;
            
        }
    }
    
    if (moveView == _downView) {
        if (y > maxY) {
            y = maxY;
            x = viewMinX(moveView);
            w = viewWidth(moveView);
            h = viewHeight(moveView);
        }
    }
    else
    {
        if (y + h + 25 > rectMaxY(_limitRect)) {
            y = rectMaxY(_limitRect) - 25 - h;
            
        }
    }
    
    if (x < minX) {
        x = minX;
        //        w = viewWidth(moveView);
        if (moveView == _leftView || moveView == _rightDownView) {
            h = viewHeight(moveView);
            y = viewMinY(moveView);
        }
    }
    
    if (y < minY) {
        y = minY;
        if (moveView == _upView) {
            x = viewMinX(moveView);
        }
        w = viewWidth(moveView);
    }
    
    //限制大小
    float widthMin = 0.0f;
    float heightMin = 0.0f;
    if (self.proportion >= 1) {
        widthMin = 70.0;
        heightMin = (widthMin + 50)/self.proportion - 50;
    }else
    {
        heightMin = 70.0;
        widthMin = (heightMin + 50) * self.proportion - 50;
    }
    
    
    if (moveView == _rightView || moveView == _leftView) {
        if (h < heightMin) {
            x = viewMinX(moveView);
            y = viewMinY(moveView);
            w = viewWidth(moveView);
            h = viewHeight(moveView);
        }
    }else
    {
        if (w < widthMin) {
            x = viewMinX(moveView);
            y = viewMinY(moveView);
            w = viewWidth(moveView);
            h = viewHeight(moveView);
        }
    }
    
    
    //限制边界
    if (moveView == _upView ||moveView == _downView) {
        if (w > rectWidth(_limitRect) - 50) {
            w = rectWidth(_limitRect) - 50;
            x = rectMinX(_limitRect) + 25;
            h = viewHeight(moveView);
            //计算y
            CGFloat shouldHeight = (w + 50)/self.proportion;
            if (moveView == _downView) {
                y = viewMinY(self.insideView) + shouldHeight - 25.0/2;
            }else
            {
                y = viewMinY(self.insideView) - 25 + 25.0/2;
            }
        }
    }else
    {
        if (h > rectHeight(_limitRect) - 50) {
            h = rectHeight(_limitRect) - 50;
            y = rectMinY(_limitRect) + 25;
            w = viewWidth(moveView);
            //计算x
            CGFloat shouldWidth = self.proportion * (h + 50);
            if (moveView == _rightView) {
                x = viewMinX(self.insideView) + shouldWidth - 25.0/2;
            }else
            {
                x = viewMinX(self.insideView) - 25.0/2;
            }
        }
    }
    self.currentMoveView.frame = CGRectMake(x, y, w, h);
}

- (void)isMovingWithMoveView:(ClipMoveView *)moveView AndChangePoint:(CGPoint)newPoint
{
    CGFloat x = viewMinX(moveView) + newPoint.x;
    CGFloat y = viewMinY(moveView) + newPoint.y;
    CGFloat w = viewWidth(moveView);
    CGFloat h = viewHeight(moveView);
    
    CGFloat minX = rectMinX(_limitRect);
    CGFloat minY = rectMinY(_limitRect);
    CGFloat maxX = rectMaxX(_limitRect) - w;
    CGFloat maxY = rectMaxY(_limitRect) - h;
    
    //限制最小范围和边界
    if(moveView == _upView){
        
        minY = minY - h/2;
        if (y > viewMaxY(_insideView) - 50 - h) {
            y = viewMaxY(_insideView) - 50 - h;
        }
    }
    
    if(moveView == _downView){
        
        maxY = rectMaxY(_limitRect) - CGRectGetHeight(self.downView.frame)/2;
        if (viewMinY(_insideView) + 50 > y) {
            y = viewMinY(_insideView) + 50;
        }
    }
    
    if(moveView == _leftView){
        
        minX = minX - w/2;
        if (x > viewMaxX(_insideView) - 50 - w) {
            x = viewMaxX(_insideView) - 50 - w;
        }
    }
    
    if(moveView == _rightView){
        
        maxX = maxX + w/2;
        if (viewMinX(_insideView) + 50 > x) {
            x = viewMinX(_insideView) + 50;
        }
        
    }
    
    if (x < minX) {
        x = minX;
    }
    
    if (y < minY) {
        y = minY;
    }
    
    if (x > maxX) {
        x = maxX;
    }
    if (y > maxY) {
        y = maxY;
    }
    //限制大小
    
    ClipMoveView *diagonalView;
    if (moveView == _leftUpView) {
        diagonalView = _rightDownView;
    }
    if (moveView == _rightUpView) {
        diagonalView = _leftDownView;
    }
    if (moveView == _leftDownView) {
        diagonalView = _rightUpView;
    }
    if (moveView == _rightDownView) {
        diagonalView = _leftUpView;
    }
    
    if (_type != ClipTypeProportionAtWill) {
        if (fabs(x - viewMinX(diagonalView)) < 60 && fabs(y - viewMinY(diagonalView)) > 60 ) {
            x = viewMinX(moveView);
            y = viewMinY(moveView);
        }
        
        if (fabs(y - viewMinY(diagonalView)) < 60 && fabs(x - viewMinX(diagonalView)) > 60) {
            x = viewMinX(moveView);
            y = viewMinY(moveView);
        }
    }
    
    moveView.frame = CGRectMake(x, y, w, h);
    if (_type != ClipTypeProportionAtWill) {
        [self updateMoveView:moveView];
    }
}

- (void)updateCornerAndInside:(ClipMoveView *)moveView
{
    
    [self limitInsideIntervalWithCorner:moveView];
    [self updateOtherCornerWithOneCorner:moveView];
    [self updateInsideRect];
    
    performSelectInDelegateWithSender2(self.delegate, @selector(isMovingWithMoveView:inClipMaskView:), moveView, self);
}

- (void)updateMoveView:(ClipMoveView *)moveView
{
    CGPoint movePoint = CGPointZero;
    CGPoint diagonalPoint = CGPointZero;
    CGPoint realPoint = CGPointZero;
    
    /*****  计算按比例变化 ******/
    
    if (moveView == _leftUpView) {
        movePoint = rectLeftUpPoint(_insideRect);
        diagonalPoint = rectRightDownPoint(_insideRect);
        
        CGPoint thumbPoint = viewLeftUpPoint(moveView);
        realPoint = projectionCoordinateInLine2(thumbPoint, movePoint, diagonalPoint);
    }
    else if (moveView == _leftDownView) {
        movePoint = rectLeftDownPoint(_insideRect);
        diagonalPoint = rectRightUpPoint(_insideRect);
        
        CGPoint thumbPoint = viewLeftDownPoint(moveView);
        realPoint = projectionCoordinateInLine2(thumbPoint, movePoint, diagonalPoint);
        
    }
    else if (moveView == _rightUpView) {
        movePoint = rectRightUpPoint(_insideRect);
        diagonalPoint = rectLeftDownPoint(_insideRect);
        
        CGPoint thumbPoint = viewRightUpPoint(moveView);
        realPoint = projectionCoordinateInLine2(thumbPoint, movePoint, diagonalPoint);
    }
    else if (moveView == _rightDownView) {
        movePoint = rectRightDownPoint(_insideRect);
        diagonalPoint = rectLeftUpPoint(_insideRect);
        
        CGPoint thumbPoint = viewRightDownPoint(moveView);
        realPoint = projectionCoordinateInLine2(thumbPoint, movePoint, diagonalPoint);
    }
    
    else {
        
    }
    
    
    /**** 处理超出边缘的情况 *****/
    
    CGFloat x = realPoint.x;
    CGFloat y = realPoint.y;
    
    if (realPoint.x < rectMinX(_limitRect)) {
        x = rectMinX(_limitRect);
        y = getPointYWithPointXAndLine(x, realPoint, diagonalPoint);
    }
    if (realPoint.y < rectMinY(_limitRect)) {
        y = rectMinY(_limitRect);
        x = getPointXWithPointYAndLine(y, realPoint, diagonalPoint);
    }
    if (realPoint.x > rectMaxX(_limitRect)) {
        x = rectMaxX(_limitRect);
        y = getPointYWithPointXAndLine(x, realPoint, diagonalPoint);
    }
    if (realPoint.y > rectMaxY(_limitRect)) {
        y = rectMaxY(_limitRect);
        x = getPointXWithPointYAndLine(y, realPoint, diagonalPoint);
    }
    
    /****** 设置角的位置 *****/
    
    realPoint = CGPointMake(x, y);
    if (moveView == _leftUpView) {
        realPoint = realPoint;
    }
    else if (moveView == _leftDownView) {
        realPoint.y -= viewHeight(moveView);
    }
    else if (moveView == _rightUpView) {
        realPoint.x -= viewWidth(moveView);
    }
    else if (moveView == _rightDownView) {
        realPoint.x -= viewWidth(moveView);
        realPoint.y -= viewHeight(moveView);
    }
    else {
        
    }
    
    CGRect frame = moveView.frame;
    frame.origin = realPoint;
    moveView.frame = frame;
}


- (CGRect)clipMoveContentFrame:(ClipMoveView*)moveView{
    
    float length = CGRectGetWidth(moveView.frame);
    CGRect frame = moveView.frame;
    
    
    
    if(moveView == _leftUpView){
        
        frame.origin.x -= length;
        frame.origin.y -= length;
        
    }else if(moveView == _rightUpView){
        
        frame.origin.y -= length;
        
        
    }else if(moveView == _leftDownView){
        
        frame.origin.x -= length;
        
    }
    
    else if(moveView == _upView || moveView == _leftView || moveView == _rightView || moveView == _downView){
        return frame;
        
    }
    
    frame.size.width += length;
    frame.size.height += length;
    
    return frame;
}


- (BOOL)noFreeClipMoveView:(ClipMoveView*)moveView containsPoint:(CGPoint)point{
    
    float length = CGRectGetWidth(moveView.frame);
    CGRect wframe = moveView.frame;
    CGRect hframe = moveView.frame;
    
    BOOL isContains = NO;
    
    if(_type == ClipTypeProportionAtWill){
        
        return  NO;
    }
    
    if(moveView == _leftUpView){
        
        wframe.origin.x -= length;
        wframe.origin.y -= length;
        wframe.size.width = length + CGRectGetWidth(_insideRect)/2;
        
        hframe.origin.y -= length;
        hframe.origin.x -= length;
        hframe.size.height = length + CGRectGetHeight(_insideRect)/2;
        
        
        
    }else if(moveView == _rightUpView){
        
        wframe.origin.y -= length;
        wframe.origin.x = CGRectGetWidth(_insideRect)/2;
        wframe.size.width = CGRectGetWidth(_insideRect)/2;
        
        hframe.origin.x += length;
        hframe.size.height = CGRectGetHeight(_insideRect)/2;
        
        
    }else if(moveView == _leftDownView){
        
        wframe.origin.y += length;
        wframe.size.width = CGRectGetWidth(_insideRect)/2;
        
        hframe.origin.x -= length;
        hframe.origin.y = CGRectGetHeight(_insideRect)/2;
        hframe.size.height = CGRectGetHeight(_insideRect)/2;
        
        
        
    }else if(moveView == _rightDownView){
        
        wframe.origin.y += length;
        wframe.origin.x = CGRectGetWidth(_insideRect)/2;
        wframe.size.width = CGRectGetWidth(_insideRect)/2;
        
        hframe.origin.x += length;
        hframe.origin.y = CGRectGetHeight(_insideRect)/2;
        hframe.size.height = CGRectGetHeight(_insideRect)/2;
        
    }
    
    if(CGRectContainsPoint(wframe, point) || CGRectContainsPoint(hframe, point)){
        
        isContains = YES;
    }
    
    
    
    return isContains;
}


- (void)hasMovedWithMoveView:(ClipMoveView *)moveView
{
    performSelectInDelegateWithSender2(self.delegate, @selector(hasMovedWithMoveView:inClipMaskView:), moveView, self);
}



@end
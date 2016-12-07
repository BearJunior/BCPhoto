//
//  BCFitHeader.h
//  BCPhoto
//
//  Created by admin on 16/12/7.
//  Copyright © 2016年 admin. All rights reserved.
//

#ifndef BCFitHeader_h
#define BCFitHeader_h


//屏幕的参数
#define SCREEN_SCALE        ([[UIScreen mainScreen] scale])
#define SCREEN_BOUNDS       ([[UIScreen mainScreen] bounds])
#define SCREEN_FRAME        ([[UIScreen mainScreen] applicationFrame])
#define SCREEN_SIZE         ([[UIScreen mainScreen] bounds].size)
#define SCREEN_SIZE_F       ([[UIScreen mainScreen] applicationFrame].size)
#define SCREEN_WIDTH        ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT       ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT_F     ([[UIScreen mainScreen] applicationFrame].size.height)

#define WIDTH_320_RATE      ([[UIScreen mainScreen] bounds].size.width / 320.0)
#define HIGHT_480_RATE      ([[UIScreen mainScreen] bounds].size.height / 480.0)
#define WIDTH_375_RATE      ([[UIScreen mainScreen] bounds].size.width / 375.0)

//适配ipad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kiPadScale (isPad ? 1.5 : 1.0)
#define UIScale (isPad ? 1 : 0.5)

#define kScrollHeight 80
#define kEditViewHtight  40
#define kSpaceX 29
#define kSpaceY 30
#define kControlCornerWidth 25;

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
static inline void performSelectInDelegateWithSender0(id delegate, SEL sel) {
    if (delegate != nil && [delegate respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning([delegate performSelector:sel]);
    }
}

static inline void performSelectInDelegateWithSender(id delegate, SEL sel, id sender) {
    if (delegate != nil && [delegate respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning([delegate performSelector:sel withObject:sender]);
    }
}

static inline void performSelectInDelegateWithSender2(id delegate, SEL sel, id object1, id object2) {
    if (delegate != nil && [delegate respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning([delegate performSelector:sel withObject:object1 withObject:object2]);
    }
}



//获取UIView的参数
//view.frame

inline static CGFloat viewHeight(UIView *view) {
    return CGRectGetHeight(view.frame);
}

inline static CGFloat viewWidth(UIView *view) {
    return CGRectGetWidth(view.frame);
}

inline static CGFloat viewMinX(UIView *view) {
    return CGRectGetMinX(view.frame);
}

inline static CGFloat viewMaxX(UIView *view) {
    return CGRectGetMaxX(view.frame);
}

inline static CGFloat viewMidX(UIView *view) {
    return CGRectGetMidX(view.frame);
}

inline static CGFloat viewMinY(UIView *view) {
    return CGRectGetMinY(view.frame);
}

inline static CGFloat viewMaxY(UIView *view) {
    return CGRectGetMaxY(view.frame);
}

inline static CGFloat viewMidY(UIView *view) {
    return CGRectGetMinY(view.frame);
}

inline static CGPoint viewLeftUpPoint(UIView *view) {
    return view.frame.origin;
}

inline static CGPoint viewLeftDownPoint(UIView *view) {
    return CGPointMake(CGRectGetMinX(view.frame), CGRectGetMaxY(view.frame));
}

inline static CGPoint viewRightUpPoint(UIView *view) {
    return CGPointMake(CGRectGetMaxX(view.frame), CGRectGetMinY(view.frame));
}

inline static CGPoint viewRightDownPoint(UIView *view) {
    return CGPointMake(CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame));
}

inline static CGPoint viewCenterPoint(UIView *view) {
    return view.center;
}


//view.bounds
inline static CGFloat viewBoundsHeigth(UIView *view) {
    return CGRectGetHeight(view.bounds);
}

inline static CGFloat viewBoundsWidth(UIView *view) {
    return  CGRectGetHeight(view.bounds);
}

//frame
inline static CGFloat rectHeight(CGRect rect) {
    return CGRectGetHeight(rect);
}

inline static CGFloat rectWidth(CGRect rect) {
    return CGRectGetWidth(rect);
}

inline static CGFloat rectMinX(CGRect rect) {
    return CGRectGetMinX(rect);
}

inline static CGFloat rectMaxX(CGRect rect) {
    return CGRectGetMaxX(rect);
}

inline static CGFloat rectMidX(CGRect rect) {
    return CGRectGetMidX(rect);
}

inline static CGFloat rectMinY(CGRect rect) {
    return CGRectGetMinY(rect);
}

inline static CGFloat rectMaxY(CGRect rect) {
    return CGRectGetMaxY(rect);
}

inline static CGFloat rectMidY(CGRect rect) {
    return CGRectGetMidY(rect);
}

inline static CGPoint rectLeftUpPoint(CGRect rect) {
    return rect.origin;
}

inline static CGPoint rectLeftDownPoint(CGRect rect) {
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
}

inline static CGPoint rectRightUpPoint(CGRect rect) {
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
}

inline static CGPoint rectRightDownPoint(CGRect rect) {
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

//image

inline static CGFloat imageWidth(UIImage *image) {
    return image.size.width;
}

inline static CGFloat imageHeight(UIImage *image) {
    return image.size.height;
}

inline static CGFloat imageWidth_2(UIImage *image) {
    return image.size.width/2;
}

inline static CGFloat imageHeight_2(UIImage *image) {
    return image.size.height/2;
}

inline static CGFloat image_2_width(UIImage *image) {
    return image.size.width * 2;
}

inline static CGFloat image_2_height(UIImage *image) {
    return image.size.height * 2;
}

inline static CGFloat imageFitWidth(UIImage *image) {
    return image.size.width/2 * kiPadScale;
}

inline static CGFloat imageFitHeight(UIImage *image) {
    return image.size.height/2 * kiPadScale;
}

inline static CGRect imageBounds(UIImage *image) {
    return CGRectMake(0, 0, image.size.width, image.size.height);
}


#endif /* BCFitHeader_h */

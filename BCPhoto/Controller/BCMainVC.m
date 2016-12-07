//
//  BCMainVC.m
//  BCPhoto
//
//  Created by admin on 16/12/5.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "BCMainVC.h"
#import "BCFitHeader.h"
#import "BCConstraint.h"
#import "BCMaskView.h"


@interface BCMainVC ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) BCMaskView *maskView;

@property (nonatomic, assign) float myImgWidth;

@end

@implementation BCMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self addImageView];
    [self addEditView];
    [self addScrollView];
    _myImgWidth = CGRectGetWidth(self.myImageView.frame);

}

- (void)initUI
{
    self.view.backgroundColor = [UIColor colorWithRed:218.0/255 green:217.0/255 blue:223.0/255 alpha:1];
    self.titles = @[@"重置",@"旋转",@"镜像",@"Free",@"1:1",@"4:3",@"3:4",@"16:9",@"9:16"];
    self.imgs = @[[UIImage imageNamed:@"重置未激活"],
                  [UIImage imageNamed:@"旋转"],
                  [UIImage imageNamed:@"镜像"],
                  [UIImage imageNamed:@"free"],
                  [UIImage imageNamed:@"1：1"],
                  [UIImage imageNamed:@"4：3"],
                  [UIImage imageNamed:@"3：4"],
                  [UIImage imageNamed:@"16：9"],
                  [UIImage imageNamed:@"9：16"],];
}

#pragma mark - 添加图片
- (void)addImageView
{
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    self.originImg = image;
    self.myImageView.image = image;
    self.myImageView.frame = [self myImgViewFrame];
    [self maskView];
}

- (void)addEditView
{
    UIView *editView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 2 * kSpaceY - kScrollHeight - kEditViewHtight, SCREEN_WIDTH, kEditViewHtight)];
    editView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:editView];
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kEditViewHtight, kEditViewHtight)];
    [editView addSubview:cancleBtn];
    [cancleBtn setImage:[UIImage imageNamed:@"关闭"] forState:0];
    [cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(kEditViewHtight, 0, SCREEN_WIDTH - 2 * kEditViewHtight, kEditViewHtight)];
    [editBtn setImage:[UIImage imageNamed:@"编辑icon"] forState:0];
    [editBtn setTitle:@"编辑" forState:0];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [editBtn setTitleColor:[UIColor colorWithRed:231.0/255 green:89.0/255 blue:136.0/255 alpha:1] forState:0];
    [editView addSubview:editBtn];
    editBtn.userInteractionEnabled = NO;
    
    UIButton *clipBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(editBtn.frame), 0, kEditViewHtight, kEditViewHtight)];
    [editView addSubview:clipBtn];
    [clipBtn addTarget:self action:@selector(clipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [clipBtn setImage:[UIImage imageNamed:@"确认"] forState:0];
}

- (void)addScrollView
{
    self.myScrollView.frame = CGRectMake(0, SCREEN_HEIGHT - kScrollHeight - kSpaceY, SCREEN_WIDTH, kScrollHeight);
    for (int i = 0; i < self.titles.count; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kScrollHeight * i, 0, kScrollHeight, kScrollHeight)];
        [self.myScrollView addSubview:button];
        [button setImage:self.imgs[i] forState:0];
        [button setTitle:self.titles[i] forState:0];
        [button setTitleColor:[UIColor blackColor] forState:0];
        button.titleLabel.alpha = 0.7;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.tag = 500 + i;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.frame.size.height+15 ,-button.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(-20, 0.0,0.0, -button.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
        if (i == 0) {
            button.titleLabel.alpha = 0.15;
            button.enabled = NO;
        }
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    float contentWidth = kScrollHeight * self.titles.count;
    self.myScrollView.contentSize = CGSizeMake(contentWidth, kScrollHeight);
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.bounces = NO;
}


#pragma mark - 懒加载
- (UIImageView *)myImageView
{
    if (!_myImageView) {
        _myImageView = ({
            UIImageView *imgView = [[UIImageView alloc] init];
            [self.view addSubview:imgView];
            imgView;
        });
    }
    
    return _myImageView;
}

- (UIScrollView *)myScrollView
{
    if (!_myScrollView) {
        _myScrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]init];
            [self.view addSubview:scrollView];
            scrollView;
        });
    }
    return _myScrollView;
}

- (BCMaskView *)maskView
{
    if (!_maskView) {
        _maskView = ({
            BCMaskView *maskView = [[BCMaskView alloc] init];
            [self.view addSubview:maskView];
            maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            maskView.limitRect = self.myImageView.frame;
            maskView.insideRect = maskView.limitRect;
            maskView.outsideRect = maskView.bounds;
            maskView.type = ClipTypeProportionAtWill;
            maskView;
            
            //maskView;
        });
        
    }
    
    return _maskView;
}

#pragma mark - 关闭点击事件
- (void)cancleAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 裁剪点击事件
- (void)clipBtnAction:(UIButton *)sender
{
    self.maskView.alpha = 0;
    [self resetBtnStatus:YES];
    UIImage *newImage = [self proportionCutImg];
    self.myImageView.image = newImage;
    self.myImageView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.myImageView setFrame:[self myImgViewFrame]];
    } completion:nil];

    
}

#pragma mark - 按钮点击事件
- (void)buttonPressed:(UIButton *)sender
{
    if (sender.tag == 500) {
        [self resetBtnStatus:NO];
        [self resetAction];
    }else
    {
        [self resetBtnStatus:YES];
    }
    
    switch (sender.tag) {
        case 501:
        {
            [self rotationImgView];
        }
            break;
        case 502:
        {
            self.myImageView.image = [self flipImg];
        }
            break;
        case 503:
        {
            [self.maskView resetInsideRectWithType:ClipTypeProportionAtWill];
        }
            break;
        case 504:
        {
            [self.maskView resetInsideRectWithType:ClipTypeProportion_1_1];
        }
            break;
        case 505:
        {
            [self.maskView resetInsideRectWithType:ClipTypeProportion_4_3];
        }
            break;
        case 506:
        {
            [self.maskView resetInsideRectWithType:ClipTypeProportion_3_4];
        }
            break;
        case 507:
        {
            [self.maskView resetInsideRectWithType:ClipTypeProportion_16_9];
        }
            break;
        case 508:
        {
            [self.maskView resetInsideRectWithType:ClipTypeProportion_9_16];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 重置
- (void)resetAction
{
    _maskView.alpha = 0;
    self.myImageView.image = self.originImg;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        self.myImageView.frame = [self myImgViewFrame];
        self.myImageView.transform = transform;
    } completion:^(BOOL finished) {
        self.maskView.limitRect = self.myImageView.frame;
        _maskView.alpha = 1;
        self.view.userInteractionEnabled = YES;
        [self.maskView resetInsideRectWithType:ClipTypeProportionAtWill];
    }];
    
}

#pragma mark - 旋转
- (void)rotationImgView
{

    float insidePro = [self updateLimitRect];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self adjustRectangularScale:insidePro];
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _maskView.alpha = 1;
        }];
//
        
        self.view.userInteractionEnabled = YES;
    }];

    
}

#pragma mark - 镜像
- (UIImage *)flipImg
{
    CGFloat width = self.myImageView.image.size.width;
    CGFloat height = self.myImageView.image.size.height;
    //开始绘制图片
    UIGraphicsBeginImageContext(self.myImageView.image.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //坐标系转换
    CGContextSetInterpolationQuality(gc, kCGInterpolationNone);
    CGContextTranslateCTM(gc, width, height);
    CGContextScaleCTM(gc, -1, -1);
    
    CGContextDrawImage(gc, CGRectMake(0, 0, width, height), [self.myImageView.image CGImage]);
    //结束绘画
    UIImage *destImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return destImg;
//    self.myImageView.image = destImg;
    
}


#pragma mark - 返回imageView的frame
- (CGRect)myImgViewFrame
{
    CGFloat radian = [BCConstraint radianWithCGAffineTransform:self.myImageView.transform];
    CGFloat pro = 0.0;;
    pro = self.myImageView.image.size.width / self.myImageView.image.size.height;
    if (fabs(radian) < 0.01 || fabs(radian - M_PI) < 0.01 || fabs(radian - 2 * M_PI) < 0.01) {
        pro = self.myImageView.image.size.width / self.myImageView.image.size.height;
    }
    else {
        pro = self.myImageView.image.size.height / self.myImageView.image.size.width;
        
    }
    
    ConstraintEdge edge = constraintEdgeMake(0, 0, kSpaceY, kSpaceY * 3 + kScrollHeight + kEditViewHtight);
    
    return [BCConstraint getSubRectWithSubRate:pro edge:edge alignment:ContraintAlignmentCenter];
}

#pragma mark - 调整角度
- (void)adjustRectangularScale:(float)scale{
    
    CGPoint center = self.myImageView.center;
    
    self.myImageView.transform = CGAffineTransformRotate(self.myImageView.transform, M_PI_2);
    self.myImageView.transform = CGAffineTransformScale(self.myImageView.transform,scale,scale);
    self.myImageView.center = center;
    
}

#pragma mark - 重置按钮激活状态
- (void)resetBtnStatus:(BOOL)status
{
    UIButton *button = [self.myScrollView viewWithTag:500];
    if (YES == status) {
        button.enabled = YES;
        [button setImage:[UIImage imageNamed:@"重置icon"] forState:0];
        button.titleLabel.alpha = 0.75;
    }else
    {
        button.enabled = NO;
        [button setImage:[UIImage imageNamed:@"重置未激活"] forState:0];
        button.titleLabel.alpha = 0.15;
    }
}

#pragma mark - 更新maskView的limitRect,返回insidePro
- (float)updateLimitRect
{
    self.view.userInteractionEnabled = NO;
    _maskView.alpha = 0;
    
    
    float pro = 0;
    
    ConstraintEdge edge = constraintEdgeMake(0, 0, kSpaceY, kSpaceY * 3 + kScrollHeight + kEditViewHtight);
    
    pro = self.maskView.limitRect.size.height / self.maskView.limitRect.size.width;
    
    CGRect myImgFrame = [BCConstraint getSubRectWithSubRate:pro edge:edge alignment:ContraintAlignmentCenter];
    CGRect limitiFrame = myImgFrame;
    
    CGFloat insideWidth = CGRectGetWidth(_maskView.insideRect);
    CGFloat insideHeight = CGRectGetHeight(_maskView.insideRect) ;
    
    
    float insidePro = CGRectGetWidth(limitiFrame) / CGRectGetHeight(_maskView.limitRect);
    float insideDw =  (CGRectGetMinX(_maskView.insideRect) - CGRectGetMinX(_maskView.limitRect)) * insidePro + CGRectGetMinY(limitiFrame);
    float insideDh =  CGRectGetMaxX(limitiFrame) - (CGRectGetMaxY(_maskView.insideRect) - CGRectGetMinY(_maskView.limitRect)) * insidePro ;
    
    insideWidth = insideWidth * insidePro;
    insideHeight = insideHeight * insidePro;
    
    _maskView.insideRect = CGRectMake(insideDh, insideDw , insideHeight, insideWidth);
    _maskView.limitRect = limitiFrame;
    
    return insidePro;
}

#pragma mark - 返回截图
- (UIImage *)proportionCutImg
{
    UIImage *rotateImage = self.myImageView.image;
    CGSize size = _maskView.insideRect.size;
    CGSize originSize = self.originImg.size;
    UIImageOrientation orientation = UIImageOrientationLeft;
    
    float angle = [BCConstraint radianWithCGAffineTransform:self.myImageView.transform];
    float imgScale = [BCConstraint scaleXWithCGAffineTransform:self.myImageView.transform];
    
    if(angle != 0){
            imgScale = imgScale * _myImgWidth / CGRectGetHeight(_maskView.limitRect);
            float originWidth = originSize.width;
            originSize.width = originSize.height;
            originSize.height = originWidth;

        rotateImage = [self rotateImage:rotateImage scale:imgScale orientation:orientation angle:angle];
        
    }
    
    float scale = originSize.width / (CGRectGetWidth(_maskView.limitRect));
    float ptx = (_maskView.limitRect.origin.x - self.maskView.insideRect.origin.x) * scale;
    float pty = (_maskView.limitRect.origin.y  - self.maskView.insideRect.origin.y) * scale;
    
    NSInteger changedWidth = (size.width * scale);
    NSInteger changedHeight = (size.height * scale);
    
    CGSize scaleSize = CGSizeMake(changedWidth, changedHeight);
    
    UIGraphicsBeginImageContext(scaleSize);
    
    
    [rotateImage drawInRect:CGRectMake((int)ptx , (int)pty, originSize.width, originSize.height)];
    
    
    rotateImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return rotateImage;

    
}

#pragma mark - 根据旋转角度获取图片
- (UIImage *)rotateImage:(UIImage *)originImage scale:(float)imgScale orientation:(UIImageOrientation)orientation angle:(float)angle{
    
    
    float imgWidth = originImage.size.width ;
    float imgheight = originImage.size.height;
    CGSize contextSize = CGSizeMake(imgWidth/imgScale, imgheight /imgScale);
    
    if(orientation == UIImageOrientationLeft || orientation == UIImageOrientationRight){
        
        contextSize = CGSizeMake(imgheight/imgScale, imgWidth/imgScale);
        
    }
    
    CGContextRef rotateContext = CGBitmapContextCreate(NULL,
                                                       contextSize.width,
                                                       contextSize.height,
                                                       8,
                                                       0,
                                                       CGImageGetColorSpace(originImage.CGImage),
                                                       (CGBitmapInfo)kCGImageAlphaNoneSkipFirst
                                                       );
    
    CGContextSetInterpolationQuality(rotateContext, kCGInterpolationHigh);
    CGContextTranslateCTM(rotateContext,  contextSize.width/2,  contextSize.height/2);
    CGContextRotateCTM(rotateContext,-angle);
    CGContextDrawImage(rotateContext, CGRectMake(-imgWidth /2 ,
                                                 -imgheight /2,
                                                 imgWidth ,
                                                 imgheight ),originImage.CGImage);
    
    
    CGImageRef resultRef = CGBitmapContextCreateImage(rotateContext);
    UIImage * rotateImage = [UIImage imageWithCGImage:resultRef];
    CGContextRelease(rotateContext);
    CGImageRelease(resultRef);
    
    return rotateImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

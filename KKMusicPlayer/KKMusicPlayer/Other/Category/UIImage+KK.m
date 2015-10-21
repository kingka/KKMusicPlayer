//
//  UIImage+KK.m
//  KKMusicPlayer
//
//  Created by Imanol on 15/10/21.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import "UIImage+KK.h"

@implementation UIImage (KK)

+(instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    
    //1加载原图
    UIImage *oldImage = [UIImage imageNamed:name];
    
    //2开启上下文
    CGFloat imageW = oldImage.size.width + 2 *borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    //3取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //4画边框（大圆）
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5 ;//大圆半径
    CGFloat centerX = bigRadius;//圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); //画圆
    
    //5小圆
    CGFloat smallRadius = bigRadius - borderWidth;//小圆半径
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    //裁剪（后面画的东西才会受裁剪的影响）
    CGContextClip(ctx);
    
    //6 画圆
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    //7取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //8结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
@end

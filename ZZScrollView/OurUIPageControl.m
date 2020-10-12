//
//  OurUIPageControl.m
//  MenuKingHD
//
//  Created by Zorro on 16-10-11.
//  Copyright (c) 2016年 carrybean.com. All rights reserved.
//

#import "OurUIPageControl.h"
#import <QuartzCore/QuartzCore.h>

@implementation OurUIPageControl

- (void)updateDotsWithImage
{
    // liujian, no use.
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView *dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage)
        {
            dot.image = _activeImage;
        }
        else
        {
            dot.image = _inactiveImage;
        }
    }
}

- (void)updateDotsWithColor
{
    // liujian, no use.
    /*
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView *dot = [self.subviews objectAtIndex:i];
        dot.image = nil;
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius = dot.frame.size.width / 2.5f;

        if (i == self.currentPage)
        {
            dot.backgroundColor = _activeColor;
        }
        else
        {
            dot.backgroundColor = _inactiveColor;
        }
    }
     */
}

- (void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    switch (_initType)
    {
        case OurUIPageControlInitType_Image:
        {
            [self updateDotsWithImage];
            break;
        }
        case OurUIPageControlInitType_Color:
        {
            [self updateDotsWithColor];
            break;
        }
        default:
            break;
    }
}

- (id)initWithFrame:(CGRect)frame activeImage:(UIImage *)activeImage inactiveImage:(UIImage *)inactiveImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _initType = OurUIPageControlInitType_Image;
        _activeImage = activeImage;
        _inactiveImage = inactiveImage;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame activeColor:(UIColor *)activeColor inactiveColor:(UIColor *)inactiveColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _initType = OurUIPageControlInitType_Color;
    }
    
    return self;
}

@end

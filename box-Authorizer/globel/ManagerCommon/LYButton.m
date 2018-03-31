//
//  LYButton.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/15.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "LYButton.h"

@implementation LYButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    //self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.imageView.frame;
    frame.origin.x = 0;
    frame.origin.y = (self.frame.size.height - frame.size.height)/2;
    //frame.size.height = self.frame.size.height;
    self.imageView.frame = frame;
    
    
    CGRect lableFrame = self.titleLabel.frame;
    lableFrame.origin.x = frame.size.width + 5;
    lableFrame.origin.y = 0;
    lableFrame.size.width = self.frame.size.width - frame.size.width;
    lableFrame.size.height =self.frame.size.height;
    self.titleLabel.frame = lableFrame;
}

@end

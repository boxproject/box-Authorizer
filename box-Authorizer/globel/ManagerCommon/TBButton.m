//
//  TBButton.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/15.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TBButton.h"

@implementation TBButton

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
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGRect frame = self.imageView.frame;
//    frame.origin.x = (self.frame.size.width - frame.size.width)/2;
//    frame.origin.y = 10;
//    //frame.size.width = self.frame.size.width;
//    self.imageView.frame = frame;
//
//
//    CGRect lableFrame = self.titleLabel.frame;
//    lableFrame.origin.x = (self.frame.size.width - lableFrame.size.width)/2;
//    lableFrame.origin.y = frame.size.height + 5;
//    lableFrame.size.width = self.frame.size.width;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    lableFrame.size.height = self.frame.size.height - self.imageView.frame.size.height - 10;
//    self.titleLabel.frame = lableFrame;
    
    CGRect frame = self.imageView.frame;
    frame.origin.x = (self.frame.size.width - frame.size.width)/2;
    frame.origin.y = 0;
    //frame.size.width = self.frame.size.width;
    self.imageView.frame = frame;
    
    
    CGRect lableFrame = self.titleLabel.frame;
    lableFrame.origin.x = 0;
    lableFrame.origin.y = frame.size.height + 5;
    lableFrame.size.width = self.frame.size.width;
    lableFrame.size.height = self.frame.size.height - frame.size.height - 5;
    self.titleLabel.frame = lableFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


@end

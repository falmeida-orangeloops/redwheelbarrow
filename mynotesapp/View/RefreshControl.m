//
//  RefreshControl.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/23/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import "RefreshControl.h"

@implementation RefreshControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGFloat)height {
    return self.label.frame.size.height + 20;
}

- (NSTimeInterval)animationDuration {
    return 1;
}

- (void)setup {
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    _label.text = @"Release to load";
    _label.textColor = [UIColor grayColor];
    _label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_label];
}

- (void)handleScrollingOnAnimationView:(UIView *)animationView withPullDistance:(CGFloat)pullDistance pullRatio:(CGFloat)pullRatio pullVelocity:(CGFloat)pullVelocity {
}

- (void)setupRefreshControlForAnimationView:(UIView *)animationView {
    
}

- (void)animationCycleForAnimationView:(UIView *)animationView {
    
}

@end

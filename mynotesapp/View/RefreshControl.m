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
    return self.imageView.frame.size.height + 20;
}

- (NSTimeInterval)animationDuration {
    return 1;
}

- (void)setup {
    NSMutableArray<UIImage*> *framesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <= 12; i++) {
        [framesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loadingAnimation/frame%d.png", i]]];
    }
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, framesArray[0].size.width, framesArray[0].size.height)];
    _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _imageView.animationDuration = 1.0f;
    _imageView.animationImages = framesArray;
    [_imageView startAnimating];
    [self addSubview:_imageView];
}

- (void)handleScrollingOnAnimationView:(UIView *)animationView withPullDistance:(CGFloat)pullDistance pullRatio:(CGFloat)pullRatio pullVelocity:(CGFloat)pullVelocity {
}

- (void)setupRefreshControlForAnimationView:(UIView *)animationView {
    
}

- (void)animationCycleForAnimationView:(UIView *)animationView {
    
}

@end

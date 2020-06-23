//
//  RefreshControl.h
//  mynotesapp
//
//  Created by Facundo Almeida on 6/23/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import <JHPullToRefreshKit/JHPullToRefreshKit.h>
#import <JHPullToRefreshKit/JHRefreshControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefreshControl : JHRefreshControl

@property (readonly, nonnull, strong, nonatomic) UILabel *label;

@end

NS_ASSUME_NONNULL_END

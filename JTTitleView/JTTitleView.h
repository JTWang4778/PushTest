//
//  JTTitleView.h
//  JTTitleView
//
//  Created by 王锦涛 on 2017/3/13.
//  Copyright © 2017年 JTWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTTitleViewDelegate <NSObject>

- (void)didClickTitleLabelWithTag:(NSInteger)tag;

@end
@interface JTTitleView : UIView

@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,weak)id <JTTitleViewDelegate>delegate;

- (void)setBottomLineXWithScale:(CGFloat)scale;

@end

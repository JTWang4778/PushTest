//
//  JTTitleView.m
//  JTTitleView
//
//  Created by 王锦涛 on 2017/3/13.
//  Copyright © 2017年 JTWang. All rights reserved.
//

#import "JTTitleView.h"
#define TITLE_FONT_SIZE 18
#define TITLE_WIDTH 60

@interface JTTitleView()

@property (nonatomic,weak)UIScrollView *scrollView;
@property (nonatomic,weak)UIView *bottomLine;

@end
@implementation JTTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor orangeColor];
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
//        scrollView.pagingEnabled = YES;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return self;
}


- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    for (int i = 0; i< titles.count; i++) {
        UILabel *la = [UILabel new];
        la.tag = i;
        la.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
        la.textAlignment = NSTextAlignmentCenter;
        la.text = titles[i];
        la.textColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTitle:)];
        [la addGestureRecognizer:tap];
        la.userInteractionEnabled = YES;
        la.frame = CGRectMake(i*TITLE_WIDTH, 0, TITLE_WIDTH, self.frame.size.height);
        [self.scrollView addSubview:la];
    }
    
    UIView *bottom = [UIView new];
    bottom.backgroundColor = [UIColor whiteColor];
    bottom.frame = CGRectMake(1, 40, TITLE_WIDTH - 2, 3);
    bottom.layer.cornerRadius = 1.5;
    bottom.layer.masksToBounds = YES;
    [self.scrollView addSubview:bottom];
    self.bottomLine = bottom;
    
    self.scrollView.contentSize = CGSizeMake(TITLE_WIDTH * titles.count, self.frame.size.height);    
}

- (void)didClickTitle:(UITapGestureRecognizer *)rec
{
    UILabel *clickLabel = (UILabel *)rec.view;
    [self.delegate didClickTitleLabelWithTag:clickLabel.tag];
    [self didClickTitleWithLable:clickLabel];
    
}

- (void)didClickTitleWithLable:(UILabel *)clickLabel
{
    CGFloat centerX = clickLabel.frame.origin.x + 0.5*clickLabel.frame.size.width;

    if (centerX > self.scrollView.frame.size.width * 0.5) {
        
        if (self.scrollView.contentSize.width - centerX < self.scrollView.frame.size.width * 0.5) {
            
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(centerX - self.scrollView.frame.size.width * 0.5, 0);
            }];
        }
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomLine.frame = CGRectMake(1+clickLabel.frame.origin.x, 40, TITLE_WIDTH -2 , 3);
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    for (id childView in self.scrollView.subviews) {
        if ([childView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)childView;
            if (label.tag == selectedIndex) {
                [self didClickTitleWithLable:label];
                break;
            }
            
        }
    }
}

- (void)setBottomLineXWithScale:(CGFloat)scale
{
    CGFloat x = scale * (self.scrollView.contentSize.width - TITLE_WIDTH);
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomLine.frame = CGRectMake(x+1, 40, TITLE_WIDTH, 3);
    }];
    
}

@end

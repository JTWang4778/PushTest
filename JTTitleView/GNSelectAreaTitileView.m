//
//  GNSelectAreaTitileView.m
//  JTTitleView
//
//  Created by 王锦涛 on 2017/3/18.
//  Copyright © 2017年 JTWang. All rights reserved.
//

#define TITLE_FONT_SIZE 14
#define LEFT_MARGIN 15
#define MARGIN 30
#import "GNSelectAreaTitileView.h"
#import "UIColor+Random.h"
#import "GNSelectAreaDataManager.h"


@interface GNSelectAreaTitileView()

@property (nonatomic,weak)UIScrollView *scrollView;
@property (nonatomic,weak)UIView *backLineView;
@property (nonatomic,weak)UIView *bottomLineView;
@property (nonatomic,weak)UILabel *selectLabel;
@property (nonatomic,assign)NSInteger currentTag;


@end
@implementation GNSelectAreaTitileView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    [self addSubview:scroll];
    _scrollView = scroll;
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"请选择";
    label.tag = 100;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTitle:)];
    [label addGestureRecognizer:tap];
    self.currentTag = label.tag;
    label.frame = CGRectMake(0, 0, [self textWidthWithContent:label.text] + MARGIN,self.frame.size.height);
    [_scrollView addSubview:label];
    _selectLabel = label;
    
    
    UIView *backLine = [UIView new];
    backLine.backgroundColor = [UIColor lightGrayColor];
    backLine.frame = CGRectMake(0, self.frame.size.height -2, self.frame.size.width, 2);
    backLine.alpha = 0.6;
    [_scrollView addSubview:backLine];
    _backLineView = backLine;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor orangeColor];
    lineView.frame = CGRectMake(1, backLine.frame.origin.y, label.frame.size.width-2, 2);
    [_scrollView addSubview:lineView];
    _bottomLineView = lineView;
    
    
    _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(_selectLabel.frame), self.frame.size.height);
}
- (void)didClickTitle:(UITapGestureRecognizer *)tap
{
    UILabel *clickLabel = (UILabel *)tap.view;
    [self scrollBottomLineViewToTag:clickLabel.tag];
    [self.delegate didClickTitleWithIndex:(clickLabel.tag - 100)];
}

- (CGFloat )textWidthWithContent:(NSString *)text
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
    label.text = text;
    [label sizeToFit];
    return label.frame.size.width;
}
- (UILabel *)creatTitleLabelWithTitle:(NSString *)title
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
//    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTitle:)];
    [label addGestureRecognizer:tap];
    return label;
}

- (void)addTitle:(NSString *)title WithTableViewTag:(NSInteger)tag
{
    /*
        1， 获取  选择label  x值
        2，创建新的label  计算大小
        3，添加到scrollView上
        4，重新计算 选择label  x值 以动画的方式 后移
     
     */
    
    if (tag < _currentTag) {
        NSLog(@"已经加上了");
        return;
    }else{
        // 正常按顺序选择
        CGFloat oldX = self.selectLabel.frame.origin.x;
        UILabel *titleLabel = [self creatTitleLabelWithTitle:title];
        titleLabel.tag = self.currentTag;
        self.currentTag += 1;
        self.selectLabel.tag = self.currentTag;
        titleLabel.frame = CGRectMake(oldX, 0, [self textWidthWithContent:titleLabel.text] + MARGIN, self.frame.size.height);
        titleLabel.alpha = 0;
        [self.scrollView addSubview:titleLabel];
        [self.scrollView bringSubviewToFront:self.selectLabel];
        
        CGFloat newX = CGRectGetMaxX(titleLabel.frame);
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect old = self.selectLabel.frame;
            self.selectLabel.frame = CGRectMake(newX, 0, old.size.width, old.size.height);
            titleLabel.alpha = 1.0;
        }];
        
        [self scrollBottomLineViewToTag:_currentTag];
        [self.delegate successAddTitle:title CurrentTag:_currentTag];
    }
    
    
    CGFloat width = CGRectGetMaxX(_selectLabel.frame);
    _scrollView.contentSize = CGSizeMake(width, self.frame.size.height);
    if (width > _scrollView.frame.size.width) {
        _backLineView.frame = CGRectMake(_backLineView.frame.origin.x, _backLineView.frame.origin.y, width, _backLineView.frame.size.height);
    }
    
    
    /*
        1,根据新添加的title  请求数据
        2，滚动scrollView到对应的位置
        3，刷新tableView
     */
}

- (void)setScrollToIndex:(NSInteger)scrollToIndex
{
    _scrollToIndex = scrollToIndex;
    /*
        1,根据tag值 拿到对应的label
        2，根据label的frame  计算新的bottomLine的frame
        3，以动画的方式移动
     */
    
    [self scrollBottomLineViewToTag:scrollToIndex + 100];

}

- (void)scrollBottomLineViewToTag:(NSInteger)tag
{
    UILabel *label = (UILabel *)[self.scrollView viewWithTag:tag];
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomLineView.frame = CGRectMake(label.frame.origin.x + 1, CGRectGetMaxY(label.frame)-2 , label.frame.size.width-2, 2);
    }];
}

@end

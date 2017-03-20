//
//  GNSelectAreaController.m
//  JTTitleView
//
//  Created by 王锦涛 on 2017/3/18.
//  Copyright © 2017年 JTWang. All rights reserved.
//

#import "GNSelectAreaController.h"
#import "UIColor+Random.h"
#import "GNSelectAreaTitileView.h"
#import "GNSelectAreaDataManager.h"

@interface GNSelectAreaController ()<UITableViewDelegate,UITableViewDataSource,GNSelectAreaTitileViewDelegate,UIScrollViewDelegate>
{
    NSInteger currentTableTag;
}
@property (nonatomic,strong)NSArray *provinces;
@property (nonatomic,strong)NSArray *citys;
@property (nonatomic,strong)NSArray *areas;
@property (nonatomic,weak)GNSelectAreaTitileView *titleView;
@property (nonatomic,strong)GNSelectAreaDataManager *dataManager;
@property (nonatomic,weak)UIScrollView *scrollView;
@property (nonatomic,copy)NSString *currentProvince;
@property (nonatomic,copy)NSString *currentCity;
@property (nonatomic,copy)NSString *currentArea;

@end

@implementation GNSelectAreaController
static NSString *reuseID = @"sdf";
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self loadData];
    [self setupViews];
    
}
- (void)loadData
{
    self.dataManager = [[GNSelectAreaDataManager alloc] init];
    self.provinces = [self.dataManager provinceArray];
}

- (void)setupViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    GNSelectAreaTitileView *titleView = [[GNSelectAreaTitileView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    titleView.delegate = self;
    [self.view addSubview:titleView];
    _titleView = titleView;
    
    CGFloat y = CGRectGetMaxY(titleView.frame);
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y)];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.bounces = NO;
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    _scrollView = scroll;
    
    // 起始tag
    currentTableTag = 100;
    for (int i= 0; i<5; i++) {
        [self creatNewTableView];
    }
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (currentTableTag - 100), self.scrollView.frame.size.height);
}
- (void)creatNewTableView
{
    CGFloat width = _scrollView.frame.size.width;
    CGFloat x = (currentTableTag -100) * width;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, 0, width, _scrollView.frame.size.height)];
    tableView.tag = currentTableTag;
    currentTableTag++;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.pagingEnabled = YES;
    tableView.backgroundColor = [UIColor RandomColor];
    [self.scrollView addSubview:tableView];
}

#pragma mark - tableView 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case 100:
            return self.provinces.count;
            break;
        case 101:
            return self.citys.count;
            break;
        case 102:
            return self.areas.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *content;
    switch (tableView.tag) {
        case 100:
            content = self.provinces[indexPath.row];
            break;
        case 101:
            content = self.citys[indexPath.row];
            break;
        case 102:
            content = self.areas[indexPath.row];
            break;
        default:
            content = @"没有内容";
            break;
    }
    
    cell.textLabel.text = content;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
        1,拿到点击的省份  然后在titleView中添加该省份
        2，根据省份 加载城市数据
        3，创建tableView  加到scrollView中 更新contentSize
        4，以动画的方式 滚动到相应的位置
     */
    switch (tableView.tag) {
        case 100:
        {
            NSString *province = self.provinces[indexPath.row];
            if (province) {
                [self.titleView addTitle:province WithTableViewTag:tableView.tag];
            }
        }
            break;
        case 101:
        {
            NSString *city = self.citys[indexPath.row];
            if (city) {
                [self.titleView addTitle:city WithTableViewTag:tableView.tag];
            }
        }
            break;
        case 102:
        {
            NSString *area = self.areas[indexPath.row];
            if (area) {
                [self.titleView addTitle:area WithTableViewTag:tableView.tag];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - titleView 代理方法
- (void)successAddTitle:(NSString *)title CurrentTag:(NSInteger)tag
{
    switch (tag) {
        case 101:
        {
            self.currentProvince = title;
            self.citys = [self.dataManager cityArrayWithProvinceName:title];
            
        }
            break;
        case 102:
        {
            self.currentCity = title;
            self.areas = [self.dataManager areaArrayWithProvinceName:self.currentProvince CityName:self.currentCity];
        }
            break;
        case 103:
        {
            self.currentArea = title;
        }
            break;
            
        default:
            break;
    }
    UITableView *tableView = [self.scrollView viewWithTag:tag];
    [tableView reloadData];
    CGFloat width = self.scrollView.frame.size.width;
    self.scrollView.contentSize = CGSizeMake((tag - 99) *width, self.scrollView.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake((tag -100) *width, 0);
    }];
}
- (void)didClickTitleWithIndex:(NSInteger)index
{
    CGFloat width = self.scrollView.frame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(index*width, 0);
    }];
}
#pragma mark - UIScrollView 代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.titleView setScrollToIndex:index];
}
@end

//
//  HistyViewController.m
//  MP4TOMP3
//
//  Created by mc309 on 2019/4/11.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import "HistyViewController.h"
#import "SaveTools.h"
#import "HistyTableViewCell.h"
#import "NSString+timeStringWithStamp.h"
#import "UIViewController+Share.h"

@interface HistyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation HistyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[SaveTools new]getAllSaveImageArrays];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - kTopHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"HistyTableViewCell" bundle:nil] forCellReuseIdentifier:@"HistyTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90.f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistyTableViewCell"];
    NSString *keyStr = self.dataArray[indexPath.row];
    cell.titleLabel.text = [NSString timeStringWithTimeStamp:keyStr andFormater:@"yyyy/MM/dd HH:mm"];
    cell.iconImg.image = [[SaveTools new] imageWithImageName:keyStr];
    __weak typeof(self)weakSelf = self;
    cell.shareblock = ^(UITableViewCell *shareCell) {
        HistyTableViewCell *cell = (HistyTableViewCell *)shareCell;
        [weakSelf shareWithImg:cell.iconImg.image];
    };
    return cell;
}
@end

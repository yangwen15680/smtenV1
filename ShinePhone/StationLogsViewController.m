//
//  StationLogsViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/25.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "StationLogsViewController.h"
#import "StationLogsCell.h"
#import <MJRefresh/MJRefresh.h>

@interface StationLogsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *arrayData;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic)int page;
@end

@implementation StationLogsViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.navigationController.navigationBarHidden = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回_03.png") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    backButton.imageInsets=UIEdgeInsetsMake(10, 5, 10, 5);
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.title = root_Event_List;
    _label=[[UILabel alloc]initWithFrame:CGRectMake(0, 64+50*NOW_SIZE, SCREEN_Width, 40*NOW_SIZE)];
    _label.text=NSLocalizedString(@"No Event List", @"No Event List");
    _label.textColor=[UIColor whiteColor];
    _label.font=[UIFont systemFontOfSize:20*NOW_SIZE];
    _label.textAlignment=NSTextAlignmentCenter;
    _label.hidden=YES;
    [self.view addSubview:_label];
    [self requestData];
}

- (void)back {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
    self.tabBarController.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    _arrayData=[NSMutableArray new];
}

#pragma mark - RequestData

-(void)requestData{
    NSString *page=[NSString stringWithFormat:@"%d",_page];
    NSLog(@"TEST:%@",[self getSystemData]);
    [self showProgressView];
    [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"plantId":_stationId, @"startDate":@"1980-01-01",@"endDate":[self getSystemData],@"toPageNum":page} paramarsSite:@"/DeviceEventAPI.do?op=getNotices" sucessBlock:^(id content) {
        [self hideProgressView];
//        NSLog(@"%@,",content);
        [_arrayData addObjectsFromArray:content[@"data"]];
        NSLog(@"TEST:_arrayData: %@",_arrayData);
        if (_tableView) {
            [_tableView reloadData];
        }else{
            [self initUI];
        }
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
}


-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (_arrayData.count==0) {
        _label.hidden=NO;
    }else{
        _label.hidden=YES;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_Width, SCREEN_Height - 114) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        if (_arrayData.count>1) {
            __unsafe_unretained StationLogsViewController *myself = self;
            [_tableView addLegendFooterWithRefreshingBlock:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    myself->_page++;
                    [myself requestData];
                    [myself->_tableView.footer endRefreshing];
                });
            }];
        }
    }
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arrayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"stationcellidentifier";
    StationLogsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[StationLogsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setData:_arrayData[indexPath.section]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25*NOW_SIZE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10*NOW_SIZE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260*NOW_SIZE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Tools Methods

-(NSString *)getSystemData{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    return currentTime;
}

@end

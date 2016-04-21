//
//  StationCellectViewController.m
//  ShinePhone
//
//  Created by ZML on 15/5/26.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "StationCellectViewController.h"
#import "EditCellectView.h"
#import "AddCellectViewController.h"
#import "StationCellectTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "ChangeCellectViewController.h"
#import "deviceRootViewController.h"
#import "MainViewController.h"
#import "DeviceManageViewController.h"

@interface StationCellectViewController ()<EditCellectViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)EditCellectView *editCellect;
@property(nonatomic,strong)NSMutableArray *arrayData;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic)int page;
@end

@implementation StationCellectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationItem.title = root_Datalog;
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:root_Add style:UIBarButtonItemStylePlain target:self action:@selector(buttonPressed)];
    rightItem.tag=10;
    self.navigationItem.rightBarButtonItem=rightItem;
    _arrayData=[NSMutableArray new];
    _page=1;
    [self requestData];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem=nil;
}

-(void)requestData{
    [self showProgressView];
    NSString *page=[NSString stringWithFormat:@"%d",_page];
    [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"id":_stationId, @"currentPage":page} paramarsSite:@"/datalogA.do?op=list" sucessBlock:^(id content) {
        [self hideProgressView];
        [_arrayData addObjectsFromArray:content];
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_Width, SCREEN_Height - 114) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    if (_arrayData.count>1) {
        __unsafe_unretained StationCellectViewController *myself = self;
        [_tableView addLegendFooterWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                myself->_page++;
                [myself requestData];
                [myself->_tableView.footer endRefreshing];
            });
        }];
    }
}



#pragma mark - EditCellectViewDelegate
- (void)menuDidSelectAtRow:(NSInteger)row {
    if (row==0) {
        //取消菜单
        [_editCellect removeFromSuperview];
        return;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDemo"] isEqualToString:@"isDemo"]) {
        [_editCellect removeFromSuperview];
        [self showAlertViewWithTitle:nil message:NSLocalizedString(@"Browse user prohibited operation", @"Browse user prohibited operation") cancelButtonTitle:root_Yes];
        return;
    }
    if (row==1) {
        [_editCellect removeFromSuperview];
        AddCellectViewController *addCellect=[[AddCellectViewController alloc]init];
        addCellect.stationId=_stationId;
        [self.navigationController pushViewController:addCellect animated:YES];
    }
    if (row==2) {
        [_editCellect removeFromSuperview];
        ChangeCellectViewController *change=[[ChangeCellectViewController alloc]init];
        change.datalogSN=_arrayData[_indexPath.row][@"datalog_sn"];
        change.alias=_arrayData[_indexPath.row][@"alias"];
        change.unitId=_arrayData[_indexPath.row][@"unit_id"];
        [self.navigationController pushViewController:change animated:YES];
    }
    if (row==3) {
        [_editCellect removeFromSuperview];
        [self showProgressView];
        [BaseRequest requestWithMethodResponseStringResult:HEAD_URL paramars:@{@"datalogSN":_arrayData[_indexPath.row][@"datalog_sn"]} paramarsSite:@"/datalogA.do?op=del" sucessBlock:^(id content) {
            [self hideProgressView];
            id jsonObj = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingAllowFragments error:nil];
            if ([[jsonObj objectForKey:@"success"] integerValue] ==0) {
                [self showAlertViewWithTitle:nil message:root_Delete_failed cancelButtonTitle:root_Yes];
            }else{
                [self showAlertViewWithTitle:nil message:root_Successfully_modified cancelButtonTitle:root_Yes];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            [self hideProgressView];
            [self showToastViewWithTitle:root_Networking];
        }];
    }
    if (row==4) {
        [_editCellect removeFromSuperview];
        
        
        
        NSString *IdString1= _arrayData[_indexPath.row][@"datalog_sn"];
        NSString *IdString=[IdString1 substringWithRange:NSMakeRange(0, 2)];
        
        NSLog(@"datalog_sn=%@",IdString);
        NSString *demoId=[NSString stringWithFormat:@"4K"];
        if ([IdString isEqualToString:demoId]) {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DeviceManageViewController *rootView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DeviceManager"];
            [self.navigationController pushViewController:rootView animated:YES];
        }else
        {
            
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainViewController *rootView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self.navigationController pushViewController:rootView animated:YES];
            
        }
        
       // UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     //    deviceRootViewController *rootView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DeviceRootview"];
        
        //AddCellectViewController *addCellect=[[AddCellectViewController alloc]init];
      //  addCellect.stationId=_stationId;
       // [self.navigationController pushViewController:rootView animated:YES];
    }
    
    
}




#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"stationcellidentifier";
    StationCellectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[StationCellectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidLongPressed:)];
    longPressGesture.minimumPressDuration = 1.0f;
    [cell addGestureRecognizer:longPressGesture];
    
    [cell setData:_arrayData[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25*NOW_SIZE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1*NOW_SIZE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220*NOW_SIZE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)buttonPressed{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDemo"] isEqualToString:@"isDemo"]) {
        [self showAlertViewWithTitle:nil message:NSLocalizedString(@"Browse user prohibited operation", @"Browse user prohibited operation") cancelButtonTitle:root_Yes];
    }else{
        AddCellectViewController *addCellect=[[AddCellectViewController alloc]init];
        addCellect.stationId=_stationId;
        [self.navigationController pushViewController:addCellect animated:YES];
    }
}

- (void)cellDidLongPressed:(UIGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [recognizer locationInView:self.tableView];
        self.indexPath = [self.tableView indexPathForRowAtPoint:point];
        if(_indexPath == nil) return ;
        _editCellect = [[EditCellectView alloc] initWithFrame:self.view.bounds];
        _editCellect.delegate = self;
        _editCellect.tintColor = [UIColor blackColor];
        _editCellect.dynamic = NO;
        _editCellect.blurRadius = 10.0f;
        [[UIApplication sharedApplication].keyWindow addSubview:_editCellect];
    }
}

@end

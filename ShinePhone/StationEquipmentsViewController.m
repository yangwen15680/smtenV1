//
//  StationEquipmentsViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/25.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "StationEquipmentsViewController.h"
#import "EquipmentCell.h"
#import "MoreEquipView.h"
#import "EquipGraphViewController.h"
#import "DayEquipGraphViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface StationEquipmentsViewController () <UITableViewDataSource, UITableViewDelegate,MoreEquipViewDelegate>

@property (nonatomic, assign) NSInteger type; //1: 逆变器  2:环境监测仪 ...

@property (nonatomic, strong) UIButton *invsButton;     //逆变器
@property (nonatomic, strong) UIButton *diseButton;     //环境监测仪
@property (nonatomic, strong) UIButton *otherButton;    //其他

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *invsDataArr;
@property (nonatomic, strong) NSMutableArray *diseDataArr;
@property (nonatomic, strong) NSMutableArray *ZNDBDataArr;
@property (nonatomic, strong) NSMutableArray *HLXDataArr;
@property (nonatomic, strong) NSMutableArray *CNJDataArr;

@property (nonatomic,strong)MoreEquipView *moreEquip;
@property(nonatomic)int page1;
@property(nonatomic)int page2;
@property(nonatomic)int page3;
@property(nonatomic)int page4;
@property(nonatomic)int page5;

@end

@implementation StationEquipmentsViewController

- (void)back {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
    self.tabBarController.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBarController.navigationController.navigationBarHidden = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回_03.png") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    backButton.imageInsets=UIEdgeInsetsMake(10, 5, 10, 5);
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.title = root_Device_List;
    _invsDataArr=[NSMutableArray new];
    _diseDataArr=[NSMutableArray new];
    _ZNDBDataArr=[NSMutableArray new];
    _HLXDataArr=[NSMutableArray new];
    _CNJDataArr=[NSMutableArray new];
    _page1=1;
    _page2=1;
    _page3=1;
    _page4=1;
    _page5=1;
    
    [self initUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.invsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.invsButton.frame = CGRectMake(0 * SCREEN_Width/3, 64, SCREEN_Width/3, 40*NOW_SIZE);
    [self.invsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.invsButton setBackgroundImage:[self createImageWithColor:COLOR(45, 182, 165, 1) rect:CGRectMake(0, 0, SCREEN_Width/3, 40*NOW_SIZE)] forState:UIControlStateNormal];
    [self.invsButton setBackgroundImage:[self createImageWithColor:COLOR(64, 221, 204, 1) rect:CGRectMake(0, 0, SCREEN_Width/3, 40*NOW_SIZE)] forState:UIControlStateHighlighted];
    [self.invsButton setBackgroundImage:[self createImageWithColor:COLOR(64, 221, 204, 1) rect:CGRectMake(0, 0, SCREEN_Width/3, 40*NOW_SIZE)] forState:UIControlStateSelected];
    self.invsButton.tag = 1000;
    [self.invsButton setTitle:root_Inverter forState:UIControlStateNormal];
    self.invsButton.selected = YES;
    [self.invsButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.invsButton];
    
    self.diseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.diseButton.frame = CGRectMake(1 * SCREEN_Width/3, 64, SCREEN_Width/3, 40*NOW_SIZE);
    [self.diseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.diseButton setBackgroundImage:[self createImageWithColor:COLOR(45, 182, 165, 1) rect:CGRectMake(0, 0, SCREEN_Width/3, 40*NOW_SIZE)] forState:UIControlStateNormal];
    [self.diseButton setBackgroundImage:[self createImageWithColor:COLOR(64, 221, 204, 1) rect:CGRectMake(0, 0, SCREEN_Width/3, 40*NOW_SIZE)] forState:UIControlStateHighlighted];
    [self.diseButton setBackgroundImage:[self createImageWithColor:COLOR(64, 221, 204, 1) rect:CGRectMake(0, 0, SCREEN_Width/3, 40*NOW_SIZE)] forState:UIControlStateSelected];
    self.diseButton.tag = 1001;
    [self.diseButton setTitle:root_Storage forState:UIControlStateNormal];
    [self.diseButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.diseButton];
    
    self.otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.otherButton.frame = CGRectMake(2 * SCREEN_Width/3, 64, SCREEN_Width/3, 40*NOW_SIZE);
    [self.otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.otherButton setBackgroundImage:[self createImageWithColor:COLOR(45, 182, 165, 1) rect:CGRectMake(0, 0, SCREEN_Width/3, 40*NOW_SIZE)] forState:UIControlStateNormal];
    [self.otherButton setBackgroundImage:[self createImageWithColor:COLOR(64, 221, 204, 1) rect:CGRectMake(0, 0, SCREEN_Width/3, 40*NOW_SIZE)] forState:UIControlStateHighlighted];
    [self.otherButton setBackgroundImage:[self createImageWithColor:COLOR(64, 221, 204, 1) rect:CGRectMake(0, 0, SCREEN_Width/3, 40*NOW_SIZE)] forState:UIControlStateSelected];
    self.otherButton.tag = 1002;
    [self.otherButton setTitle:root_Other forState:UIControlStateNormal];
    [self.otherButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.otherButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 40*NOW_SIZE, SCREEN_Width, SCREEN_Height - 64 - 49 - 40*NOW_SIZE) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)initData {
    self.type = 1;
    UIButton *button=[[UIButton alloc]init];
    button.tag=1000;
    [self buttonDidClicked:button];
}


-(void)addRefresh{
    __unsafe_unretained StationEquipmentsViewController *myself = self;
    [_tableView addLegendFooterWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_type==1) {
                myself->_page1++;
                [myself requestInvsData];
            }else if (_type==2){
                myself->_page2++;
                [myself requestCNJData];
            }else if (_type==3){
                myself->_page3++;
                [myself requestZNDBData];
            }else if (_type==4){
                myself->_page4++;
                [myself requestHLXData];
            }else if (_type==5){
                myself->_page5++;
                [myself requestDiseData];
            }
            [myself->_tableView.footer endRefreshing];
        });
    }];
}

- (void)requestInvsData {
    NSString *page=[NSString stringWithFormat:@"%d",_page1];
    [self showProgressView];
    [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"id":[NSNumber numberWithInteger:[_stationId integerValue]], @"currentPage":page, @"pageSize":[NSNumber numberWithInteger:10]} paramarsSite:@"/deviceA.do?op=getInvs" sucessBlock:^(id content) {
        NSLog(@"requestInvsDatacontent: %@", content);
        [self hideProgressView];
        NSArray *arr = [NSArray arrayWithArray:content];
        if (arr.count > 0) {
            [self.invsDataArr addObjectsFromArray:arr];
            [self.tableView reloadData];
        } else {
            [self showToastViewWithTitle:NSLocalizedString(@"No data", @"No data")];
        }
        [self comfirmWheterAddRefresh:_invsDataArr];
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
}

- (void)requestCNJData {
    NSString *page=[NSString stringWithFormat:@"%d",_page2];
    [self showProgressView];
    [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"id":[NSNumber numberWithInteger:[_stationId integerValue]], @"currentPage":page, @"pageSize":[NSNumber numberWithInteger:10]} paramarsSite:@"/deviceA.do?op=getDlss" sucessBlock:^(id content) {
        NSLog(@"requestCNJData: %@", content);
        [self hideProgressView];
        NSArray *arr = [NSArray arrayWithArray:content];
        if (arr.count > 0) {
            [self.CNJDataArr addObjectsFromArray:arr];
            [self.tableView reloadData];
        } else {
            [self showToastViewWithTitle:NSLocalizedString(@"No data", @"No data")];
        }
        [self comfirmWheterAddRefresh:_CNJDataArr];
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
}

- (void)requestZNDBData {
    //NSString *page=[NSString stringWithFormat:@"%d",_page3];
    [self showProgressView];
    [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"id":[NSNumber numberWithInteger:[_stationId integerValue]]} paramarsSite:@"/deviceA.do?op=getOtherDevices" sucessBlock:^(id content) {
        NSLog(@"requestZNDBData: %@", content);
        [self hideProgressView];
        NSMutableArray *arr=[NSMutableArray new];
        [arr addObjectsFromArray:content[@"ammeters"]];
        [arr addObjectsFromArray:content[@"boxs"]];
        [arr addObjectsFromArray:content[@"envs"]];
        if (arr.count > 0) {
            [self.ZNDBDataArr addObjectsFromArray:arr];
            [self.tableView reloadData];
        } else {
            [self showToastViewWithTitle:NSLocalizedString(@"No data", @"No data")];
        }
        [self comfirmWheterAddRefresh:_ZNDBDataArr];
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
}

- (void)requestHLXData {
    NSString *page=[NSString stringWithFormat:@"%d",_page4];
    [self showProgressView];
    [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"id":[NSNumber numberWithInteger:[_stationId integerValue]], @"currentPage":page, @"pageSize":[NSNumber numberWithInteger:10]} paramarsSite:@"/deviceA.do?op=getDlsb" sucessBlock:^(id content) {
        NSLog(@"requestHLXData: %@", content);
        [self hideProgressView];
        NSArray *arr = [NSArray arrayWithArray:content];
        if (arr.count > 0) {
            [self.HLXDataArr addObjectsFromArray:arr];
            [self.tableView reloadData];
        } else {
            [self showToastViewWithTitle:NSLocalizedString(@"No data", @"No data")];
        }
        [self comfirmWheterAddRefresh:_HLXDataArr];
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
}


- (void)requestDiseData {
    NSString *page=[NSString stringWithFormat:@"%d",_page5];
    [self showProgressView];
    [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"id":[NSNumber numberWithInteger:[_stationId integerValue]], @"currentPage":page, @"pageSize":[NSNumber numberWithInteger:10]} paramarsSite:@"/deviceA.do?op=getDlse" sucessBlock:^(id content) {
        NSLog(@"requestDiseDatacontent: %@", content);
        [self hideProgressView];
        NSArray *arr = [NSArray arrayWithArray:content];
        if (arr.count > 0) {
            [self.diseDataArr addObjectsFromArray:arr];
            [self.tableView reloadData];
        } else {
            [self showToastViewWithTitle:NSLocalizedString(@"No data", @"No data")];
        }
        [self comfirmWheterAddRefresh:_diseDataArr];
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
}


- (void)buttonDidClicked:(UIButton *)sender {
    if (sender.tag == 1000) {
        _type = 1;
        _invsButton.selected = YES;
        _diseButton.selected = NO;
        _otherButton.selected = NO;
        
        if (!_invsDataArr.count) {
            [self requestInvsData];
        }else{
            [self comfirmWheterAddRefresh:_invsDataArr];
        }
    }
    if (sender.tag == 1001) {
        _type = 2;
        
        _invsButton.selected = NO;
        _diseButton.selected = YES;
        _otherButton.selected = NO;
        
        if (!_CNJDataArr.count) {
            [self requestCNJData];
        }else{
            [self comfirmWheterAddRefresh:_CNJDataArr];
        }
    }
    
    if (sender.tag == 1002) {
        _type = 3;
        
        _invsButton.selected = NO;
        _diseButton.selected = NO;
        _otherButton.selected = YES;
        
        if (!_ZNDBDataArr.count) {
            [self requestZNDBData];
        }else{
            [self comfirmWheterAddRefresh:_ZNDBDataArr];
        }
//        _moreEquip = [[MoreEquipView alloc] initWithFrame:self.view.bounds];
//        _moreEquip.delegate = self;
//        _moreEquip.tintColor = [UIColor blackColor];
//        _moreEquip.dynamic = NO;
//        _moreEquip.blurRadius = 10.0f;
//        [[UIApplication sharedApplication].keyWindow addSubview:_moreEquip];
    }
    [_tableView reloadData];
}


-(void)comfirmWheterAddRefresh:(NSMutableArray *)array{
    if (array.count>5) {
        [self addRefresh];
    }else{
        [_tableView removeFooter];
    }
}

#pragma mark - EditCellectViewDelegate
- (void)menuDidSelectAtRow:(NSInteger)row {
    if (row==0) {
        //取消菜单
        [_moreEquip removeFromSuperview];
    }
    if (row==1) {
        [_moreEquip removeFromSuperview];
        _type = 3;
        if (!_ZNDBDataArr.count) {
            [self requestZNDBData];
        }else{
            [self comfirmWheterAddRefresh:_ZNDBDataArr];
        }
    }
    
    if (row==2) {
        [_moreEquip removeFromSuperview];
        _type = 4;
        if (!_HLXDataArr.count) {
            [self requestHLXData];
        }else{
            [self comfirmWheterAddRefresh:_HLXDataArr];
        }
    }
    
    if (row==3) {
        [_moreEquip removeFromSuperview];
        _type = 5;
        if (!_diseDataArr.count) {
            [self requestDiseData];
        }else{
            [self comfirmWheterAddRefresh:_diseDataArr];
        }
    }
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == 1) {
        return _invsDataArr.count;
    } else if (_type == 2) {
        return _CNJDataArr.count;
    } else if (_type == 3) {
        return _ZNDBDataArr.count;
    }else if (_type == 4) {
        return _HLXDataArr.count;
    }else if (_type == 5) {
        return _diseDataArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"stationcellidentifier";
    EquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EquipmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (_type == 1) {
        cell.type = _type;
        [cell setData:_invsDataArr[indexPath.row]];
    } else if (_type == 2) {
        cell.type = _type;
        [cell setData:_CNJDataArr[indexPath.row]];
    } else if (_type == 3) {
        cell.type = _type;
        [cell setData:_ZNDBDataArr[indexPath.row]];
    }else if (_type == 4) {
        cell.type = _type;
        [cell setData:_HLXDataArr[indexPath.row]];
    }else if (_type == 5) {
        cell.type = _type;
        [cell setData:_diseDataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5*NOW_SIZE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155*NOW_SIZE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_type==1) {
        EquipGraphViewController *equipGraph=[[EquipGraphViewController alloc]init];
        equipGraph.dictInfo=@{@"equipId":_invsDataArr[indexPath.row][@"alias"],
                              @"daySite":@"/inverterA.do?op=getDps",
                              @"monthSite":@"/inverterA.do?op=getMps",
                              @"yearSite":@"/inverterA.do?op=getYps",
                              @"allSite":@"/inverterA.do?op=getTps"};
        equipGraph.dict=@{@"1":root_PV_POWER, @"2":root_PV1_VOLTAGE, @"3":root_PV1_ELEC_CURRENT, @"4":root_PV2_VOLTAGE, @"5":root_PV2_ELEC_CURRENT, @"6":root_R_PHASE_POWER, @"7":root_S_PHASE_POWER, @"8":root_T_PHASE_POWER};
        [self.navigationController pushViewController:equipGraph animated:YES];
    }
    
    if (_type==2) {
        EquipGraphViewController *equipGraph=[[EquipGraphViewController alloc]init];
        equipGraph.dictInfo=@{@"equipId":_CNJDataArr[indexPath.row][@"alias"],
                              @"daySite":@"/storageA.do?op=getDls",
                              @"monthSite":@"/storageA.do?op=getMls",
                              @"yearSite":@"/storageA.do?op=getYls",
                              @"allSite":@"/storageA.do?op=getTls"};
        equipGraph.dict=@{@"1":root_CHARGING_POWER, @"2":root_DISCHARGING_POWER, @"3":root_INPUT_VOLTAGE, @"4":root_INPUT_CURRENT, @"5":root_USER_SIDE_POWER, @"6":root_GRID_SIDE_POWER};
        equipGraph.dictMonth=@{@"1":root_MONTH_BATTERY_CHARGE, @"2":root_MONTHLY_CHARGED, @"3":root_MONTHLY_DISCHARGED};
        equipGraph.dictYear=@{@"1":root_YEAR_BATTERY_CHARGE, @"2":root_YEAR_CHARGED, @"3":root_YEAR_DISCHARGED};
        equipGraph.dictAll=@{@"1":root_TOTAL_BATTERY_CHARGE, @"2":root_TOTAL_CHARGED, @"3":root_TOTAL_DISCHARGED};
        [self.navigationController pushViewController:equipGraph animated:YES];
    }
    
    if (_type==3) {
        NSString *ammeter=[NSString stringWithFormat:@"%@",_ZNDBDataArr[indexPath.row][@"ammeterData"]];
        NSString *box=[NSString stringWithFormat:@"%@",_ZNDBDataArr[indexPath.row][@"boxData"]];
        NSString *env=[NSString stringWithFormat:@"%@",_ZNDBDataArr[indexPath.row][@"envData"]];
        NSString *ammeterData=@"";
        NSString *boxData=@"";
        NSString *envData=@"";
        if (![ammeter isEqual:@"<null>"]) {
            ammeterData=[NSString stringWithFormat:@"%@",_ZNDBDataArr[indexPath.row][@"ammeterData"][@"calendar"]];
        }
        if (![box isEqual:@"<null>"]) {
            boxData=[NSString stringWithFormat:@"%@",_ZNDBDataArr[indexPath.row][@"boxData"][@"calendar"]];
        }
        if (![env isEqual:@"<null>"]) {
            envData=[NSString stringWithFormat:@"%@",_ZNDBDataArr[indexPath.row][@"envData"][@"calendar"]];
        }
        if (![ammeterData isEqual:@"<null>"]) {
            DayEquipGraphViewController *equipGraph=[[DayEquipGraphViewController alloc]initWithName:_ZNDBDataArr[indexPath.row][@"deviceName"]];
            equipGraph.equipId=_ZNDBDataArr[indexPath.row][@"dataLogSn"];
            equipGraph.address=_ZNDBDataArr[indexPath.row][@"address"];
            equipGraph.site=@"/ammeterA.do?op=getDls";
            equipGraph.stationId=_stationId;
            equipGraph.dict=[NSDictionary new];
            equipGraph.dict=@{@"1":@[@"3",root_Active_Power], @"2":@[@"4",root_REACTIVE_POWER], @"3":@[@"5",root_APPARENT_POWER], @"4":@[@"1",root_ACTIVE_ENERGY], @"5":@[@"2",root_REACTIVE_ENERGY], @"6":@[@"6",root_POWER_FACTOR]};
            [self.navigationController pushViewController:equipGraph animated:YES];

        }else if(![box isEqual:@"<null>"]){
            DayEquipGraphViewController *equipGraph=[[DayEquipGraphViewController alloc]initWithName:_ZNDBDataArr[indexPath.row][@"deviceName"]];
            equipGraph.equipId=_ZNDBDataArr[indexPath.row][@"dataLogSn"];
            equipGraph.address=_ZNDBDataArr[indexPath.row][@"address"];
            equipGraph.site=@"/boxA.do?op=getDls";
            equipGraph.stationId=_stationId;
            equipGraph.dict=[NSDictionary new];
            equipGraph.dict=@{@"1":@[@"1",root_FIRST_CURRENT],@"2":@[@"2",root_SENCOND_CURRENT],@"3":@[@"3",root_THIRD_CURRENT],@"4":@[@"4",root_FOUR_CURRENT],@"5":@[@"5",root_FIVE_CURRENT], @"6":@[@"6",root_SIX_CURRENT]};
            [self.navigationController pushViewController:equipGraph animated:YES];

        }else if(![envData isEqual:@"<null>"]){
            DayEquipGraphViewController *equipGraph=[[DayEquipGraphViewController alloc]initWithName:_ZNDBDataArr[indexPath.row][@"deviceName"]];
            equipGraph.equipId=_ZNDBDataArr[indexPath.row][@"dataLogSn"];
            equipGraph.address=_ZNDBDataArr[indexPath.row][@"address"];
            equipGraph.site=@"/evnMonitorA.do?op=getDls";
            equipGraph.stationId=_stationId;
            equipGraph.dict=[NSDictionary new];
            equipGraph.dict=@{@"1":@[@"1",root_WIND_SPEED],@"2":@[@"2",root_WIND_ANGLE],@"3":@[@"3",root_ENVIRONMENT_TEMPERATURE],@"5":@[@"4",root_PANEL_TEMPERATURE],@"4":@[@"5",root_RADIANT]};
            [self.navigationController pushViewController:equipGraph animated:YES];
        }
        
    }
    
    if (_type==4) {
        
    }
    
    if (_type==5) {
        
    }
}

@end

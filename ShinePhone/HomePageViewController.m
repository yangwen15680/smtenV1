//
//  HomePageViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/19.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "HomePageViewController.h"
#import "LoginViewController.h"
#import "AddStationViewController.h"
#import "StationListViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface HomePageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *homePageView;
@property (nonatomic, strong) UIView *listPageView;

@property (nonatomic, strong) UIImageView *guideImageView;
@property (nonatomic, strong) UIImageView *menuImageView;

@property (nonatomic, strong) StationListViewController *listViewController;

@property (nonatomic, strong) UILabel *todayEnergyLabel;
@property (nonatomic, strong) UILabel *totalEnergyLabel;
@property (nonatomic, strong) UILabel *currentPowerLabel;
@property (nonatomic, strong) UILabel *co2Label;
@property (nonatomic, strong) UILabel *totalMoneyLabel;
@property (nonatomic, strong) UILabel *totalMoneyTitleLabel;
@property (nonatomic, strong) UILabel *todayEnergy;
@property (nonatomic, strong) UILabel *totalEnergy;
@property (nonatomic, strong) UILabel *currentPower;
@property (nonatomic, strong) UILabel *co2;

@property (nonatomic, strong) UILabel *inStorageLabel;
@property (nonatomic, strong) UILabel *outStorageLabel;
@property (nonatomic, strong) UILabel *outStorage;

@property (nonatomic, strong) NSDictionary *dataSource;


@property (nonatomic, strong) UIBarButtonItem *homeViewLeftItem;

@property (nonatomic, strong) UIBarButtonItem *listViewLeftItem;
@property (nonatomic, strong) UIBarButtonItem *listViewRightItem;

@end

@implementation HomePageViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    //4.根据是否为浏览用户(登录接口返回参数判断)，屏蔽添加电站、添加采集器、修改电站信息功能，给予提示(浏览用户禁止操作)。
    if (_example) {
        [self initDemoData];
        [[NSUserDefaults standardUserDefaults] setObject:@"isDemo" forKey:@"isDemo"];
    }else{
        [self initData];
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTIFICATION_ADD_STATION_SUCCESSFUL object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)initUI {
    self.title = root_Plant_Overview;
    
    self.navigationItem.leftBarButtonItem = self.homeViewLeftItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Height)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_Width, SCREEN_Height * 2);
    self.scrollView.scrollEnabled = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    
    //1.电站概览：上拉刷新。

    __unsafe_unretained HomePageViewController *myself = self;
    [_scrollView addLegendHeaderWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [myself->_scrollView.header endRefreshing];
        });
        if (myself->_example) {
            [myself initDemoData];
        }else{
            [myself initData];
        }
        myself->_scrollView.contentOffset=CGPointMake(0, 0);
    }];
    
    //首页
    self.homePageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Height)];
    self.homePageView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.homePageView];
    
    self.menuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27.5*NOW_SIZE, 140*NOW_SIZE, 265*NOW_SIZE, 265*NOW_SIZE)];
    [self.homePageView addSubview:self.menuImageView];
    
    //日发电量
    self.todayEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(22*NOW_SIZE, 15*NOW_SIZE, 120*NOW_SIZE, 30*NOW_SIZE)];
//    self.todayEnergyLabel.textAlignment = NSTextAlignmentCenter;
    self.todayEnergyLabel.textColor = COLOR(33, 203, 144, 1);
    self.todayEnergyLabel.font = [UIFont systemFontOfSize:17*NOW_SIZE];
    [self.menuImageView addSubview:_todayEnergyLabel];
    
    
    _todayEnergy=[[UILabel alloc]initWithFrame:CGRectMake(22*NOW_SIZE, 50*NOW_SIZE, 120*NOW_SIZE, 20*NOW_SIZE)];
    _todayEnergy.textColor = COLOR(33, 203, 144, 1);
//    _todayEnergy.textAlignment = NSTextAlignmentCenter;
    _todayEnergy.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [self.menuImageView addSubview:_todayEnergy];
    
    //总发电量
    self.totalEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(158*NOW_SIZE, 15*NOW_SIZE, 120*NOW_SIZE, 30*NOW_SIZE)];
//    self.totalEnergyLabel.textAlignment = NSTextAlignmentCenter;
    self.totalEnergyLabel.textColor = COLOR(79, 178, 245, 1);
    self.totalEnergyLabel.font = [UIFont systemFontOfSize:17*NOW_SIZE];
    [self.menuImageView addSubview:_totalEnergyLabel];
    
    _totalEnergy=[[UILabel alloc]initWithFrame:CGRectMake(158*NOW_SIZE, 52*NOW_SIZE, 120*NOW_SIZE, 20*NOW_SIZE)];
    _totalEnergy.textColor = COLOR(79, 178, 245, 1);
//    _totalEnergy.textAlignment = NSTextAlignmentCenter;
    _totalEnergy.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [self.menuImageView addSubview:_totalEnergy];
    
    //总功率
    self.currentPowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(22*NOW_SIZE, 180*NOW_SIZE, 120*NOW_SIZE, 30*NOW_SIZE)];
//    self.currentPowerLabel.textAlignment = NSTextAlignmentCenter;
    self.currentPowerLabel.textColor = COLOR(79, 178, 245, 1);
    self.currentPowerLabel.font = [UIFont systemFontOfSize:17*NOW_SIZE];
    [self.menuImageView addSubview:_currentPowerLabel];
    
    _currentPower=[[UILabel alloc]initWithFrame:CGRectMake(22*NOW_SIZE, 220*NOW_SIZE, 120*NOW_SIZE, 20*NOW_SIZE)];
    _currentPower.textColor = COLOR(79, 178, 245, 1);
//    _currentPower.textAlignment = NSTextAlignmentCenter;
    _currentPower.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [self.menuImageView addSubview:_currentPower];
    
    //CO2排放量
    self.co2Label = [[UILabel alloc] initWithFrame:CGRectMake(158*NOW_SIZE, 180*NOW_SIZE, 120*NOW_SIZE, 30*NOW_SIZE)];
//    self.co2Label.textAlignment = NSTextAlignmentCenter;
    self.co2Label.textColor = COLOR(237, 165, 71, 1);
    self.co2Label.font = [UIFont systemFontOfSize:17*NOW_SIZE];
    [self.menuImageView addSubview:_co2Label];
    
    _co2=[[UILabel alloc]initWithFrame:CGRectMake(158*NOW_SIZE, 220*NOW_SIZE, 120*NOW_SIZE, 20*NOW_SIZE)];
    _co2.textColor = COLOR(237, 165, 71, 1);
//    _co2.textAlignment = NSTextAlignmentCenter;
    _co2.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [self.menuImageView addSubview:_co2];
    
    //充电功率
    self.inStorageLabel = [[UILabel alloc] initWithFrame:CGRectMake(175*NOW_SIZE, 160*NOW_SIZE, 85*NOW_SIZE, 30*NOW_SIZE)];
    self.inStorageLabel.textAlignment = NSTextAlignmentCenter;
    self.inStorageLabel.textColor = COLOR(237, 165, 71, 1);
    self.inStorageLabel.font = [UIFont systemFontOfSize:15*NOW_SIZE];

    [self.menuImageView addSubview:_inStorageLabel];
    
    //放电功率－》改为电网功率
    self.outStorageLabel = [[UILabel alloc] initWithFrame:CGRectMake(158*NOW_SIZE, 180*NOW_SIZE, 120*NOW_SIZE, 30*NOW_SIZE)];

//    self.outStorageLabel.textAlignment = NSTextAlignmentCenter;
    self.outStorageLabel.textColor = COLOR(237, 165, 71, 1);
    self.outStorageLabel.font = [UIFont systemFontOfSize:17*NOW_SIZE];
    [self.menuImageView addSubview:_outStorageLabel];
    
    
    _outStorage=[[UILabel alloc]initWithFrame:CGRectMake(158*NOW_SIZE, 220*NOW_SIZE, 120*NOW_SIZE, 20*NOW_SIZE)];
    _outStorage.textColor = COLOR(237, 165, 71, 1);
//    _outStorage.textAlignment = NSTextAlignmentCenter;
//    _outStorage.backgroundColor = [UIColor redColor];
    _outStorage.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [self.menuImageView addSubview:_outStorage];

    
    //总收益
    self.totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(87*NOW_SIZE, 108*NOW_SIZE, 90*NOW_SIZE, 30*NOW_SIZE)];
    self.totalMoneyLabel.textAlignment = NSTextAlignmentCenter;
    self.totalMoneyLabel.font = [UIFont systemFontOfSize:18*NOW_SIZE];
    self.totalMoneyLabel.textColor = COLOR(81, 82, 83, 1);
    [self.menuImageView addSubview:_totalMoneyLabel];
    
    //总收益title
    self.totalMoneyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(87*NOW_SIZE, 135*NOW_SIZE, 90*NOW_SIZE, 15*NOW_SIZE)];
    self.totalMoneyTitleLabel.font = [UIFont systemFontOfSize:9*NOW_SIZE];
    self.totalMoneyTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.totalMoneyTitleLabel.textColor = COLOR(81, 82, 83, 1);
//    [self.totalMoneyTitleLabel setNumberOfLines:0];
//    [self.totalMoneyTitleLabel sizeToFit];
    [self.menuImageView addSubview:self.totalMoneyTitleLabel];
}

- (void)showGuideView {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //第一次启动
        
        //引导操作动画
        self.guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_Width - 100*NOW_SIZE)/2, SCREEN_Height - 120*NOW_SIZE, 100*NOW_SIZE, 100*NOW_SIZE)];
        NSMutableArray *guideImages = [NSMutableArray array];
        for (int i = 1; i <= 13; i++) {
            NSString *imageStr = [NSString stringWithFormat:@"huadong%d.png", i];
            [guideImages addObject:IMAGE(imageStr)];
        }
        
        [self.guideImageView setAnimationImages:guideImages];
        [self.guideImageView setAnimationDuration:self.guideImageView.animationImages.count * 0.1];
        [self.guideImageView setAnimationRepeatCount:0];
        [self.guideImageView startAnimating];
        [_homePageView addSubview:self.guideImageView];
    }
}


- (void)hideGuideView {
    [self.guideImageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.guideImageView.animationDuration];
}

-(NSString *)changeStoragePacToUser:(NSString *)string{
    NSRange among=[string rangeOfString:@" "];
    NSRange unitStringRange=NSMakeRange(among.location+1, string.length-among.location-1);
    NSRange numberStringRange=NSMakeRange(0, among.location+1);
    NSString *unit=[string substringWithRange:unitStringRange];
    NSString *number=[string substringWithRange:numberStringRange];
    NSString *newNumber=[NSString stringWithFormat:@"%1.2f",[number floatValue]];
    NSString *newString=[NSString stringWithFormat:@"%@ %@",newNumber,unit];
    return newString;
}

- (void)initDemoData {
    [self showProgressView];
    [BaseRequest requestWithMethod:HEAD_URL paramars:nil paramarsSite:@"/demoLoginAPI.do" sucessBlock:^(id content) {
        [BaseRequest requestWithMethodByGet:HEAD_URL paramars:nil paramarsSite:@"/PlantListAPI.do" sucessBlock:^(id content) {
            [self hideProgressView];
            if ([content[@"success"] integerValue] != 0) {
                self.dataSource = [NSDictionary dictionaryWithDictionary:content];
                //NSLog(@"%@",self.dataSource);
                if ([_dataSource[@"totalData"][@"isHaveStorage"] boolValue]) {
                    self.menuImageView.image = IMAGE(@"bg_main_menu_3.png");
                    self.totalMoneyTitleLabel.text = root_Battery_Percentage;
                    _todayEnergy.text=root_Today_Energy;
                    _totalEnergy.text=root_Total_Energy;
                    _currentPower.text=root_Current_Power;
                    _outStorage.text=root_Grid_Power;

                    
                    self.todayEnergyLabel.text = _dataSource[@"totalData"][@"todayEnergySum"];
                    self.totalEnergyLabel.text = _dataSource[@"totalData"][@"totalEnergySum"];
                    self.currentPowerLabel.text = _dataSource[@"totalData"][@"currentPowerSum"];
                    self.totalMoneyLabel.text = _dataSource[@"totalData"][@"storageCapacity"];
                    //self.inStorageLabel.text = _dataSource[@"totalData"][@"storagePCharge"];
                    self.outStorageLabel.text = [self changeStoragePacToUser:_dataSource[@"totalData"][@"storagePacToUser"]];
                    
                } else {
                    self.menuImageView.image = IMAGE(@"bg_main_menu.png");
                    _todayEnergy.text=root_Today_Energy;
                    _totalEnergy.text=root_Total_Energy;
                    _currentPower.text=root_Current_Power;
                    _co2.text=root_CO2_reduced;
                    self.totalMoneyTitleLabel.text = root_Capital_Income;
                    self.todayEnergyLabel.text = _dataSource[@"totalData"][@"todayEnergySum"];
                    self.totalEnergyLabel.text = _dataSource[@"totalData"][@"totalEnergySum"];
                    self.currentPowerLabel.text = _dataSource[@"totalData"][@"currentPowerSum"];
                    self.co2Label.text = _dataSource[@"totalData"][@"CO2Sum"];
                    self.totalMoneyLabel.text = _dataSource[@"totalData"][@"eTotalMoneyText"];
                }
                
                self.scrollView.scrollEnabled = YES;
                [self performSelector:@selector(showGuideView) withObject:nil afterDelay:0.5];
            }
            
        } failure:^(NSError *error) {
            [self hideProgressView];
            [self showToastViewWithTitle:root_Networking];
        }];
    } failure:^(NSError *error) {
        [self hideProgressView];
    }];
}

- (void)initData {
    //自动登陆
    if ([UserInfo defaultUserInfo].isAutoLogin) {
        [self showProgressView];
        [BaseRequest requestWithMethod:HEAD_URL paramars:@{@"userName":[UserInfo defaultUserInfo].userName, @"password":[self MD5:[UserInfo defaultUserInfo].userPassword]} paramarsSite:@"/LoginAPI.do" sucessBlock:^(id content) {
            [self hideProgressView];
            if (content) {
                if ([content[@"success"] integerValue] == 0) {
                    //登陆失败
                    if ([content[@"errCode"] integerValue] == 101) {
                        [self showAlertViewWithTitle:nil message:NSLocalizedString(@"User name or password is blank", @"User name or password is blank") cancelButtonTitle:root_Yes];
                    }
                    if ([content[@"errCode"] integerValue] == 102) {
                        [self showAlertViewWithTitle:nil message:root_username_password_error cancelButtonTitle:root_Yes];
                    }
                } else {
                    //登陆成功
                    [[UserInfo defaultUserInfo] setUserId:content[@"userId"]];
                    [BaseRequest requestWithMethodByGet:HEAD_URL paramars:nil paramarsSite:@"/PlantListAPI.do" sucessBlock:^(id content) {
                        if ([content[@"success"] integerValue] != 0) {
                            self.dataSource = [NSDictionary dictionaryWithDictionary:content];
                            
                            if ([_dataSource[@"totalData"][@"isHaveStorage"] boolValue]) {
                                self.menuImageView.image = IMAGE(@"bg_main_menu_3.png");
                                self.totalMoneyTitleLabel.text = root_Battery_Percentage;
                                _todayEnergy.text=root_Today_Energy;
                                _totalEnergy.text=root_Total_Energy;
                                _currentPower.text=root_Current_Power;
                                _outStorage.text=root_Grid_Power;
                                self.todayEnergyLabel.text = _dataSource[@"totalData"][@"todayEnergySum"];
                                self.totalEnergyLabel.text = _dataSource[@"totalData"][@"totalEnergySum"];
                                self.currentPowerLabel.text = _dataSource[@"totalData"][@"currentPowerSum"];
                                self.totalMoneyLabel.text = _dataSource[@"totalData"][@"storageCapacity"];
                                //self.inStorageLabel.text = _dataSource[@"totalData"][@"storagePCharge"];
                                self.outStorageLabel.text =[self changeStoragePacToUser: _dataSource[@"totalData"][@"storagePacToUser"]];
                            } else {
                                self.menuImageView.image = IMAGE(@"bg_main_menu.png");
                                _todayEnergy.text=root_Today_Energy;
                                _totalEnergy.text=root_Total_Energy;
                                _currentPower.text=root_Current_Power;
                                _co2.text=root_CO2_reduced;
                                self.totalMoneyTitleLabel.text = root_Capital_Income;
                                self.todayEnergyLabel.text = _dataSource[@"totalData"][@"todayEnergySum"];
                                self.totalEnergyLabel.text = _dataSource[@"totalData"][@"totalEnergySum"];
                                self.currentPowerLabel.text = _dataSource[@"totalData"][@"currentPowerSum"];
                                self.co2Label.text = _dataSource[@"totalData"][@"CO2Sum"];
                                self.totalMoneyLabel.text = _dataSource[@"totalData"][@"eTotalMoneyText"];
                            }
                            
                            self.scrollView.scrollEnabled = YES;
                            [self performSelector:@selector(showGuideView) withObject:nil afterDelay:0.5];
                        }
                    } failure:^(NSError *error) {
                        [self showToastViewWithTitle:root_Networking];
                    }];
                }
            }
            
        } failure:^(NSError *error) {
            [self hideProgressView];
            [self showToastViewWithTitle:root_Networking];
        }];
    } else {
        //非自动登陆
        [self showProgressView];
        [BaseRequest requestWithMethodByGet:HEAD_URL paramars:nil paramarsSite:@"/PlantListAPI.do" sucessBlock:^(id content) {
            [self hideProgressView];
            if ([content[@"success"] integerValue] != 0) {
                self.dataSource = [NSDictionary dictionaryWithDictionary:content];
                
                if ([_dataSource[@"totalData"][@"isHaveStorage"] boolValue]) {
                    self.menuImageView.image = IMAGE(@"bg_main_menu_3.png");
                    self.totalMoneyTitleLabel.text = root_Battery_Percentage;
                    _todayEnergy.text=root_Today_Energy;
                    _totalEnergy.text=root_Total_Energy;
                    _currentPower.text=root_Current_Power;
                    _outStorage.text=root_Grid_Power;
                    self.todayEnergyLabel.text = _dataSource[@"totalData"][@"todayEnergySum"];
                    self.totalEnergyLabel.text = _dataSource[@"totalData"][@"totalEnergySum"];
                    self.currentPowerLabel.text = _dataSource[@"totalData"][@"currentPowerSum"];
                    self.totalMoneyLabel.text = _dataSource[@"totalData"][@"storageCapacity"];
                    //self.inStorageLabel.text = _dataSource[@"totalData"][@"storagePCharge"];
                    self.outStorageLabel.text =[self changeStoragePacToUser: _dataSource[@"totalData"][@"storagePacToUser"]];
                } else {
                    self.menuImageView.image = IMAGE(@"bg_main_menu.png");
                    _todayEnergy.text=root_Today_Energy;
                    _totalEnergy.text=root_Total_Energy;
                    _currentPower.text=root_Current_Power;
                    _co2.text=root_CO2_reduced;
                    self.totalMoneyTitleLabel.text = root_Capital_Income;
                    self.todayEnergyLabel.text = _dataSource[@"totalData"][@"todayEnergySum"];
                    self.totalEnergyLabel.text = _dataSource[@"totalData"][@"totalEnergySum"];
                    self.currentPowerLabel.text = _dataSource[@"totalData"][@"currentPowerSum"];
                    self.co2Label.text = _dataSource[@"totalData"][@"CO2Sum"];
                    self.totalMoneyLabel.text = _dataSource[@"totalData"][@"eTotalMoneyText"];
                }
                
                self.scrollView.scrollEnabled = YES;
                [self performSelector:@selector(showGuideView) withObject:nil afterDelay:0.5];
            }
        } failure:^(NSError *error) {
            [self hideProgressView];
            [self showToastViewWithTitle:root_Networking];
        }];
    }
}


//- (void)refreshData {
//    [self showProgressView];
//    [BaseRequest requestWithMethodByGet:HEAD_URL paramars:nil paramarsSite:@"/PlantListAPI.do" sucessBlock:^(id content) {
//        [self hideProgressView];
//        if ([content[@"success"] integerValue] != 0) {
//            self.dataSource = nil;
//            self.dataSource = [NSDictionary dictionaryWithDictionary:content];
//            
//            self.todayEnergyLabel.text = _dataSource[@"totalData"][@"todayEnergySum"];
//            self.totalEnergyLabel.text = _dataSource[@"totalData"][@"totalEnergySum"];
//            self.currentPowerLabel.text = _dataSource[@"totalData"][@"currentPowerSum"];
//            self.co2Label.text = _dataSource[@"totalData"][@"CO2Sum"];
//            self.totalMoneyLabel.text = _dataSource[@"totalData"][@"eTotalMoneyText"];
//            
//            self.scrollView.scrollEnabled = YES;
//        }
//    } failure:^(NSError *error) {
//        [self hideProgressView];
//        [self showToastViewWithTitle:root_Networking];
//    }];
//}

- (void)itemDidClicked:(UIBarButtonItem *)sender {
    if (sender.tag == 101) {
        //注销按钮
        if ([UserInfo defaultUserInfo].isAutoLogin) {
            
            LoginViewController *lvc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:lvc animated:YES];
            
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if (sender.tag == 102) {
        self.title = root_Plant_Overview;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = self.homeViewLeftItem;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    if (sender.tag == 103) {
        //添加电站
        
        //4.根据是否为浏览用户(登录接口返回参数判断)，屏蔽添加电站、添加采集器、修改电站信息功能，给予提示(浏览用户禁止操作)。

        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isDemo"] isEqual:@"isDemo"]) {
            [self showAlertViewWithTitle:nil message:NSLocalizedString(@"Browse user prohibited operation", @"Browse user prohibited operation") cancelButtonTitle:root_Yes];
        }else{
            AddStationViewController *asvc = [[AddStationViewController alloc] init];
            [self.navigationController pushViewController:asvc animated:YES];
        }
    }
}

#pragma mark - properties
- (UIBarButtonItem *)homeViewLeftItem {
    if (!_homeViewLeftItem) {
        _homeViewLeftItem = [[UIBarButtonItem alloc] initWithTitle:BTN_LOGOUT style:UIBarButtonItemStylePlain target:self action:@selector(itemDidClicked:)];
        _homeViewLeftItem.tag = 101;
    }
    return _homeViewLeftItem;
}

- (UIBarButtonItem *)listViewLeftItem {
    if (!_listViewLeftItem) {
        _listViewLeftItem = [[UIBarButtonItem alloc] initWithTitle:root_Plant_Overview style:UIBarButtonItemStylePlain target:self action:@selector(itemDidClicked:)];
        _listViewLeftItem.tag = 102;
    }
    return _listViewLeftItem;
}

- (UIBarButtonItem *)listViewRightItem {
    if (!_listViewRightItem) {
        _listViewRightItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"item_add.png") style:UIBarButtonItemStylePlain target:self action:@selector(itemDidClicked:)];
        _listViewRightItem.imageInsets = UIEdgeInsetsMake(5, 6, 5, 6);
        _listViewRightItem.tag = 103;
    }
    return _listViewRightItem;
}

//懒加载listPageView
- (UIView *)listPageView {
    if (!_listPageView) {
        _listPageView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_Height, SCREEN_Width, SCREEN_Height)];
        _listPageView.backgroundColor = [UIColor clearColor];
        _listPageView.userInteractionEnabled = YES;
        
        [self addChildViewController:self.listViewController];
        [self.listPageView addSubview:self.listViewController.view];
    }
    return _listPageView;
}



- (StationListViewController *)listViewController {
    if (!_listViewController) {
        _listViewController = [[StationListViewController alloc] initWithStationList:_dataSource[@"data"]];
    }
    return _listViewController;
}


#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.y / SCREEN_Height;
    if (page == 0) {
        self.title = root_Plant_Overview;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = self.homeViewLeftItem;
    }
    
    if (page == 1) {
        self.title = root_Plant_List;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = self.listViewLeftItem;
        self.navigationItem.rightBarButtonItem = self.listViewRightItem;
        
        [self hideGuideView];
        
        //电站列表
        [_scrollView addSubview:self.listPageView];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint listPageOffset = CGPointMake(0, SCREEN_Height);
//    if (scrollView.contentOffset.y > listPageOffset.y) {
//        scrollView.scrollEnabled = NO;
//        scrollView.userInteractionEnabled = NO;
//    } else {
//        scrollView.scrollEnabled = YES;
//        scrollView.userInteractionEnabled = YES;
//    }
//}




@end

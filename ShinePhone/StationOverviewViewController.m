//
//  StationOverviewViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/25.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "StationOverviewViewController.h"
#import "StationCellectViewController.h"
#import "StationSafeViewController.h"
#import "StationLocationViewController.h"
#import "StationEarningsViewController.h"
#import "StationAppearanceViewController.h"

@interface StationOverviewViewController ()
@property(nonatomic,strong)UIView *allButtonView;
@property(nonatomic,strong)NSDictionary *dictData;
@end

@implementation StationOverviewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.navigationController.navigationBarHidden = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回_03.png") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    backButton.imageInsets=UIEdgeInsetsMake(10, 5, 10, 5);
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.title = root_Plant_Overview;
}

- (void)back {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
    self.tabBarController.navigationController.navigationBarHidden = NO;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem=nil;
}

//请求数据
-(void)requestData{
    [BaseRequest requestWithMethodByGet:HEAD_URL paramars:@{@"plantId":_stationId} paramarsSite:@"/PlantAPI.do" sucessBlock:^(id content) {
        _dictData=[NSDictionary new];
        _dictData=content[@"data"];
        NSLog(@"_dictData: %@", _dictData);
    } failure:^(NSError *error) {
        
    }];
}

//设置画面
-(void)initUI{
    
    _allButtonView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, 320*NOW_SIZE, 480*NOW_SIZE)];
    [self.view addSubview:_allButtonView];
    NSArray *buttonTitle=[NSArray arrayWithObjects:root_Installation_Information, root_Location_Information, root_Capital_Income, root_Plant_image, root_Datalog, nil];
    for (int i=0; i<5; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(40*NOW_SIZE, (30+i*60)*NOW_SIZE, 240*NOW_SIZE, 45*NOW_SIZE)];
        [button setBackgroundImage:IMAGE(@"about_btn_bg.png") forState:UIControlStateNormal];
        [button setTitle:buttonTitle[i] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:16*NOW_SIZE];
        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets=UIEdgeInsetsMake(0, 20*NOW_SIZE, 0, 0);
        button.tag=i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_allButtonView addSubview:button];
    }
}

//按钮动作
-(void)buttonPressed:(UIButton *)sender{
    
    //    NSDictionary *dict=@{@"stationId":_stationId,
    //                         @"plantName":_dictData[@"plantName"],
    //                         @"createData":_dictData[@"createData"],
    //                         @"designCompany":_dictData[@"designCompany"],
    //                         @"normalPower":_dictData[@"normalPower"],
    //                         @"country":_dictData[@"country"],
    //                         @"city":_dictData[@"city"],
    //                         @"timeZone":_dictData[@"timeZone"],
    //                         @"plant_lat":_dictData[@"plant_lat"],
    //                         @"plant_lng":_dictData[@"plant_lng"],
    //                         @"formulaMoney":_dictData[@"formulaMoney"],
    //                         @"formulaMoneyUnit":_dictData[@"formulaMoneyUnit"],
    //                         @"formulaCoal":_dictData[@"formulaCoal"],
    //                         @"formulaCo2":_dictData[@"formulaCo2"],
    //                         @"formulaSo2":_dictData[@"formulaSo2"],};
    if (sender.tag==0) {
        StationSafeViewController *safe=[[StationSafeViewController alloc]init];
        safe.stationId=_stationId;
        [self.navigationController pushViewController:safe animated:YES];
    }
    
    if (sender.tag==1) {
        StationLocationViewController *location=[[StationLocationViewController alloc]init];
        location.stationId=_stationId;
        [self.navigationController pushViewController:location animated:YES];
    }
    
    if (sender.tag==2) {
        StationEarningsViewController *earnings=[[StationEarningsViewController alloc]init];
        earnings.stationId=_stationId;
        [self.navigationController pushViewController:earnings animated:YES];
    }
    
    if (sender.tag==3) {
        StationAppearanceViewController *appearance=[[StationAppearanceViewController alloc]init];
        appearance.stationId=_stationId;
        [self.navigationController pushViewController:appearance animated:YES];
    }
    
    if (sender.tag==4) {
        StationCellectViewController *cellect=[[StationCellectViewController alloc]init];
        cellect.stationId=_stationId;
        [self.navigationController pushViewController:cellect animated:YES];
    }
}


@end

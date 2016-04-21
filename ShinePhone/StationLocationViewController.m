//
//  StationLocationViewController.m
//  ShinePhone
//
//  Created by ZML on 15/5/27.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "StationLocationViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "RootPickerView.h"

@interface StationLocationViewController ()<BMKLocationServiceDelegate>
@property(nonatomic,strong)NSMutableArray *textFieldMutableArray;
@property(nonatomic,strong)CLLocation *plantLocation;
@property(nonatomic,strong)BMKLocationService *locService;
@property(nonatomic,strong)NSString *lat;
@property(nonatomic,strong)NSString *lng;
@property (nonatomic, strong) UIView *readView;
@property (nonatomic, strong) UIView *writeView;
@property (nonatomic, strong) UIView *buttonView;
@property(nonatomic,strong)RootPickerView *pickerView;
@end

@implementation StationLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    self.navigationItem.title=root_Location_Information;
    [self requestData];
}


//rightBarButtonItem上变成取消
-(void)barButtonPressed:(UIBarButtonItem *)sender{
    //4.根据是否为浏览用户(登录接口返回参数判断)，屏蔽添加电站、添加采集器、修改电站信息功能，给予提示(浏览用户禁止操作)。
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDemo"] isEqualToString:@"isDemo"]) {
        [self showAlertViewWithTitle:nil message:NSLocalizedString(@"Browse user prohibited operation", @"Browse user prohibited operation") cancelButtonTitle:root_Yes];
        return;
    }
    if ([sender.title isEqual:NSLocalizedString(@"Edit", @"Edit")]) {
        [sender setTitle:root_Cancel];
        [_readView removeFromSuperview];
        _readView=nil;
        [self writeUI];
    }else{
        [sender setTitle:NSLocalizedString(@"Edit", @"Edit")];
        [self readUI];
        [_writeView removeFromSuperview];
        _writeView=nil;
        [_buttonView removeFromSuperview];
        _buttonView=nil;
    }
    
}

//请求数据
-(void)requestData{
    [BaseRequest requestWithMethodByGet:HEAD_URL paramars:@{@"plantId":_stationId} paramarsSite:@"/PlantAPI.do" sucessBlock:^(id content) {
        _dict=[NSDictionary new];
        _dict=content[@"data"];
        NSLog(@"_dict: %@", _dict);
        [self initUI];
        [self readUI];
    } failure:^(NSError *error) {
        
    }];
}

-(void)initUI{    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Edit", @"Edit") style:UIBarButtonItemStylePlain target:self action:@selector(barButtonPressed:)];
    self.navigationItem.rightBarButtonItem=rightItem;

    NSArray *array=[[NSArray alloc]initWithObjects:root_country,root_city,root_time_zone,root_longitude, root_latitude, nil];
    for (int i=0; i<5; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(40*NOW_SIZE, (100+i*40)*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        label.text=array[i];
        label.font=[UIFont systemFontOfSize:11*NOW_SIZE];
        label.textColor=[UIColor whiteColor];
        [self.view addSubview:label];
    }
}


-(void)readUI{
    _readView=[[UIView alloc]initWithFrame:CGRectMake(160*NOW_SIZE, 100*NOW_SIZE, 140*NOW_SIZE, 210*NOW_SIZE)];
    [self.view addSubview:_readView];
    NSArray *array=[[NSArray alloc]initWithObjects:_dict[@"country"],_dict[@"city"],_dict[@"timeZone"],_dict[@"plant_lat"],_dict[@"plant_lng"],nil];
    for (int i=0; i<5; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0*NOW_SIZE, (0+i*40)*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        label.text=array[i];
        label.font=[UIFont systemFontOfSize:14*NOW_SIZE];
        label.textColor=[UIColor whiteColor];
        [_readView addSubview:label];
    }
}


-(void)writeUI{
    _pickerView=[[RootPickerView alloc]initWithTwoArray:@[@"Other", @"China", @"Taiwan", @"Singapore", @"Thailand", @"Indonesia",
                                                          @"Malaysia", @"Vietnam", @"Japan", @"Russia", @"USA", @"Afghanistan",
                                                          @"Albania", @"Algeria", @"American Samoa", @"Andorra", @"Angola",
                                                          @"Anguilla", @"Antigua and Barbuda", @"Argentina", @"Armenia", @"Aruba",
                                                          @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain",
                                                          @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize", @"Benin",
                                                          @"Bermuda", @"Bhutan", @"Bolivia", @"Bosniaand Herzegovina", @"Botswana",
                                                          @"Brazil", @"British Virgin Islands", @"Brunei Darussalam", @"Bulgaria",
                                                          @"BurkinaFaso", @"Burundi", @"Cambodia", @"Cameroon", @"Canada",
                                                          @"CapeVerde", @"Cayman Islands", @"Central African Republic", @"Chad",
                                                          @"Chile", @"Colombia", @"Comoros", @"Congo", @"Congo Democratic Republic",
                                                          @"Cook Islands", @"Costa Rica", @"Croatia", @"Cuba", @"Cyprus",
                                                          @"Czech Republic", @"Denmark", @"Djibouti", @"Dominica",
                                                          @"Dominican Republic", @"EastTimor", @"Ecuador", @"Egypt", @"ElSalvador",
                                                          @"Equatorial Guinea", @"Eritrea", @"Estonia", @"Ethiopia",
                                                          @"FalklandIslands", @"Faroe Islands", @"Fiji", @"Finland", @"France",
                                                          @"French Guiana", @"French Polynesia", @"Gabon", @"Gambia", @"Georgia",
                                                          @"Germany", @"Ghana", @"Gibraltar", @"Greece", @"Greenland", @"Grenada",
                                                          @"Guadeloupe", @"Guam", @"Guatemala", @"Guinea", @"Guinea Bissau", @"Guyana",
                                                          @"Haiti", @"Honduras", @"HongKong", @"Hungary", @"Iceland", @"India", @"Iran",
                                                          @"Iraq", @"Ireland", @"Isle of Man", @"Israel", @"Italy", @"Jamaica",
                                                          @"Jordan", @"Kazakhstan", @"Kenya", @"Kiribati", @"Kuwait", @"Kyrgyzstan",
                                                          @"Laos", @"Latvia", @"Lebanon", @"Lesotho", @"Liberia", @"Libya",
                                                          @"Liechtenstein", @"Lithuania", @"Luxembourg", @"Macau", @"Macedonia",
                                                          @"Madagascar", @"Malawi", @"Maldives", @"Mali", @"Malta",
                                                          @"Marshall Islands", @"Martinique", @"Mauritania", @"Mauritius", @"Mexico",
                                                          @"Micronesia", @"Moldova", @"Monaco", @"Mongolia", @"Montenegro",
                                                          @"Montserrat", @"Morocco", @"Mozambique", @"Myanmar", @"Namibia", @"Nauru",
                                                          @"Nepal", @"Netherlands", @"NewCaledonia", @"NewZealand", @"Nicaragua",
                                                          @"Niger", @"Nigeria", @"Niue", @"Norfolk Island", @"NorthKorea",
                                                          @"Northern Mariana Islands", @"Norway", @"Oman", @"Pakistan", @"Palau",
                                                          @"Palestine", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru",
                                                          @"Philippines", @"Pitcairn Islands", @"Poland", @"Portugal", @"Puerto Rico",
                                                          @"Qatar", @"Romania", @"Rwanda", @"S&#;oTom&#;andPr&#;ncipe",
                                                          @"SaintHelena", @"SaintKittsandNevis", @"SaintLucia",
                                                          @"SaintPierreandMiquelon", @"SaintVincentandtheGrenadines", @"Samoa",
                                                          @"SanMarino", @"SaudiArabia", @"Senegal", @"Serbia", @"Seychelles",
                                                          @"SierraLeone", @"SintMaarten", @"Slovakia", @"Slovenia", @"SolomonIslands",
                                                          @"Somalia", @"SouthAfrica", @"SouthKorea", @"SouthSudan", @"Spain",
                                                          @"SriLanka", @"Sudan", @"Suriname", @"SvalbardandJanMayen", @"Swaziland",
                                                          @"Sweden", @"Switzerland", @"Syria", @"Tajikistan", @"Tanzania", @"Togo",
                                                          @"Tokelau", @"Tonga", @"TrinidadandTobago", @"Tunisia", @"Turkey",
                                                          @"Turkmenistan", @"Turks and Caicos Islands", @"Tuvalu",
                                                          @"US Virgin Islands", @"Uganda", @"Ukraine", @"United Arab Emirates",
                                                          @"United Kingdom", @"Uruguay", @"Uzbekistan", @"Vanuatu", @"Venezuela",
                                                          @"Wallis and Futuna", @"Yemen", @"Zambia", @"Zimbabwe"] arrayTwo:@[@"+1",@"+2",@"+3",@"+4",@"+5",@"+6",@"+7",@"+8",@"+9",@"+10",@"+11",@"+12",@"-1",@"-2",@"-3",@"-4",@"-5",@"-6",@"-7",@"-8",@"-9",@"-10",@"-11",@"-12"]];
    [self.view addSubview:_pickerView];
    _writeView=[[UIView alloc]initWithFrame:CGRectMake(160*NOW_SIZE, 100*NOW_SIZE, 140*NOW_SIZE, 210*NOW_SIZE)];
    [self.view addSubview:_writeView];
    _textFieldMutableArray=[NSMutableArray new];
    NSRange timerange=[_dict[@"timeZone"] rangeOfString:@"T"];
    NSRange timeNewRange={timerange.location+1,[_dict[@"timeZone"] length]-timerange.location-1};
    NSString *timeString=[_dict[@"timeZone"] substringWithRange:timeNewRange];
    NSArray *array=[[NSArray alloc]initWithObjects:_dict[@"country"],_dict[@"city"],timeString,_dict[@"plant_lat"],_dict[@"plant_lng"], nil];
    for (int i=0; i<5; i++) {
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(0*NOW_SIZE, (5+i*40)*NOW_SIZE, 100*NOW_SIZE, 30*NOW_SIZE)];
        textField.text=array[i];
        textField.layer.borderWidth=0.5;
        textField.layer.cornerRadius=5;
        textField.layer.borderColor=[UIColor whiteColor].CGColor;
        textField.tintColor = [UIColor whiteColor];
        [textField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
        [textField setValue:[UIFont systemFontOfSize:14*NOW_SIZE] forKeyPath:@"_placeholderLabel.font"];
        textField.font=[UIFont systemFontOfSize:14*NOW_SIZE];
        textField.textColor=[UIColor whiteColor];
        if (i==0) {
            textField.tag=1000;
        }else if(i==2){
            textField.tag=5000;
        }else{
            textField.tag=i;
        }
        textField.delegate=_pickerView;
        [_writeView addSubview:textField];
        [_textFieldMutableArray addObject:textField];
    }
    
    UIButton *latButton=[[UIButton alloc]initWithFrame:CGRectMake(105*NOW_SIZE, 130*NOW_SIZE, 50*NOW_SIZE, 20*NOW_SIZE)];
    [latButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [latButton setTitle:root_longitude forState:UIControlStateNormal];
    latButton.titleLabel.font=[UIFont systemFontOfSize:11*NOW_SIZE];
    [latButton setTitleColor:COLOR(82, 201, 194, 1) forState:0];
    latButton.tag=1;
    [latButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_writeView addSubview:latButton];
    
    UIButton *lngButton=[[UIButton alloc]initWithFrame:CGRectMake(105*NOW_SIZE, 170*NOW_SIZE, 50*NOW_SIZE, 20*NOW_SIZE)];
    [lngButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [lngButton setTitle:root_latitude forState:UIControlStateNormal];
    lngButton.titleLabel.font=[UIFont systemFontOfSize:11*NOW_SIZE];
    [lngButton setTitleColor:COLOR(82, 201, 194, 1) forState:0];
    lngButton.tag=2;
    [lngButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_writeView addSubview:lngButton];
    
    
    _buttonView=[[UIView alloc]initWithFrame:CGRectMake(80*NOW_SIZE, 350*NOW_SIZE, 160*NOW_SIZE, 21*NOW_SIZE)];
    [self.view addSubview:_buttonView];
    UIButton *delButton=[[UIButton alloc]initWithFrame:CGRectMake(0*NOW_SIZE, 0*NOW_SIZE, 60*NOW_SIZE, 21*NOW_SIZE)];
    [delButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:0];
    [delButton setTitle:root_Cancel forState:UIControlStateNormal];
    [delButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    [delButton addTarget:self action:@selector(delButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:delButton];
    
    UIButton *addButton=[[UIButton alloc]initWithFrame:CGRectMake(80*NOW_SIZE, 0*NOW_SIZE, 60*NOW_SIZE, 21*NOW_SIZE)];
    [addButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:0];
    [addButton setTitle:root_Yes forState:UIControlStateNormal];
    [addButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:addButton];
}



-(void)buttonPressed:(UIButton *)sender{
    if (sender.tag==1) {
        UIView *view=[self.view viewWithTag:3];
        UITextField *textField=(UITextField *)view;
        textField.text=_lat;
    }
    if (sender.tag==2) {
        UIView *view=[self.view viewWithTag:4];
        UITextField *textField=(UITextField *)view;
        textField.text=_lng;
    }
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _lat=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    _lng=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
}

-(void)delButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)addButtonPressed{
    NSArray *array=[[NSArray alloc]initWithObjects:NSLocalizedString(@"Country can not be empty", @"Country can not be empty"),
                    NSLocalizedString(@"City can not be empty", @"City can not be empty"),
                    NSLocalizedString(@"Time Zone can not be empty", @"Time Zone can not be empty"),
                    NSLocalizedString(@"longitude can not be empty", @"longitude can not be empty"),
                    NSLocalizedString(@"latitude can not be empty", @"latitude can not be empty"),nil];
    for (int i=0; i<5; i++) {
        if ([[_textFieldMutableArray[i] text] isEqual:@""]) {
            [self showToastViewWithTitle:array[i]];
            return;
        }
    }
    NSRange range=[_dict[@"normalPower"] rangeOfString:@" "];
    NSRange newRange={0,range.location};
    NSString *string=[_dict[@"normalPower"] substringWithRange:newRange];
    NSDictionary *dict=@{@"plantID":_stationId,
                         @"plantName":_dict[@"plantName"],
                         @"plantDate":_dict[@"createData"],
                         @"plantFirm":_dict[@"designCompany"],
                         @"plantPower":string,
                         @"plantCountry":[_textFieldMutableArray[0] text],
                         @"plantCity":[_textFieldMutableArray[1] text],
                         @"plantTimezone":[_textFieldMutableArray[2] text],
                         @"plantLat":[_textFieldMutableArray[3] text],
                         @"plantLng":[_textFieldMutableArray[4] text],
                         @"plantIncome":_dict[@"formulaMoney"],
                         @"plantMoney":_dict[@"formulaMoneyUnit"],
                         @"plantCoal":_dict[@"formulaCoal"],
                         @"plantCo2":_dict[@"formulaCo2"],
                         @"plantSo2":_dict[@"formulaSo2"],};
    [self showProgressView];
    [BaseRequest uplodImageWithMethod:HEAD_URL paramars:dict paramarsSite:@"/plantA.do?op=update" dataImageDict:nil sucessBlock:^(id content) {
        [self hideProgressView];
        NSLog(@"testtest: %@", content);
        id jsonObj = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingAllowFragments error:nil];
        if ([jsonObj integerValue]==1) {
            [self showAlertViewWithTitle:nil message:NSLocalizedString(@"Successfully modified", @"Successfully modified") cancelButtonTitle:root_Yes];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlertViewWithTitle:nil message:NSLocalizedString(@"Modification fails", @"Modification fails") cancelButtonTitle:root_Yes];
        }
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_pickerView viewDisappear];
    for (UITextField *textField in _textFieldMutableArray) {
        [textField resignFirstResponder];
    }
}

@end

//
//  LocationViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/21.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "LocationViewController.h"
#import "IncomeViewController.h"
#import <QBPopupMenu/QBPopupMenu.h>
#import "BaiduMapViewController.h"
#import "GoogleMapEditViewController.h"
#import "RootPickerView.h"

@interface LocationViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong) UITextField *countryTextField;
@property (nonatomic, strong) UITextField *cityTextField;
@property (nonatomic, strong) UITextField *timezoneTextField;
@property (nonatomic, strong) UITextField *eastlongitudeTextField;
@property (nonatomic, strong) UITextField *northlatitudeTextField;
@property (nonatomic, strong) UIActionSheet *chooseMapActionSheet;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) RootPickerView *pickerView;

@end

@implementation LocationViewController

- (instancetype)initWithDataDict:(NSMutableDictionary *)dataDict {
    if (self = [super init]) {
        self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.title = root_Add_Plant;
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_Width, 40*NOW_SIZE)];
    subTitleLabel.textColor = [UIColor whiteColor];
    subTitleLabel.text = root_Location_Information;
    subTitleLabel.backgroundColor = COLOR(39, 177, 159, 1);
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:subTitleLabel];
    
    for (int i=0; i<5; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 134*NOW_SIZE + i*60*NOW_SIZE, 80*NOW_SIZE, 30*NOW_SIZE)];
        if (i == 0) {
            label.text = root_country;
        } else if (i == 1) {
            label.text = root_city;
        } else if (i == 2) {
            label.text = root_time_zone;
        } else if (i == 3) {
            label.text = root_longitude;
        } else {
            label.text = root_latitude;
        }
        
        label.font = [UIFont systemFontOfSize:15*NOW_SIZE];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 165*NOW_SIZE + i*60*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 0.5*NOW_SIZE)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:lineView];
    }
    
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
    
    self.countryTextField = [[UITextField alloc] initWithFrame:CGRectMake(130*NOW_SIZE, 134*NOW_SIZE + 0*60*NOW_SIZE, SCREEN_Width - 134*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    self.countryTextField.textColor = [UIColor whiteColor];
    self.countryTextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.countryTextField.tag=1000;
    self.countryTextField.delegate=_pickerView;
    [self.view addSubview:_countryTextField];
    
    self.cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(130*NOW_SIZE, 134*NOW_SIZE + 1*60*NOW_SIZE, SCREEN_Width - 134*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    self.cityTextField.textColor = [UIColor whiteColor];
    self.cityTextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.cityTextField.delegate=_pickerView;
    [self.view addSubview:_cityTextField];
    
    self.timezoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(130*NOW_SIZE, 134*NOW_SIZE + 2*60*NOW_SIZE, SCREEN_Width - 134*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    self.timezoneTextField.textColor = [UIColor whiteColor];
    self.timezoneTextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.timezoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.timezoneTextField.tag=5000;
    self.timezoneTextField.delegate=_pickerView;
    [self.view addSubview:_timezoneTextField];
    
    self.eastlongitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(130*NOW_SIZE, 134*NOW_SIZE + 3*60*NOW_SIZE, SCREEN_Width - 134*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    self.eastlongitudeTextField.textColor = [UIColor whiteColor];
    self.eastlongitudeTextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.eastlongitudeTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.eastlongitudeTextField.delegate=_pickerView;
    [self.view addSubview:_eastlongitudeTextField];
    
    self.northlatitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(130*NOW_SIZE, 134*NOW_SIZE + 4*60*NOW_SIZE, SCREEN_Width - 134*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    self.northlatitudeTextField.textColor = [UIColor whiteColor];
    self.northlatitudeTextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.northlatitudeTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.northlatitudeTextField.delegate=_pickerView;
    [self.view addSubview:_northlatitudeTextField];
    
    for (int i=0; i<5; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(300*NOW_SIZE, (134+i*60)*NOW_SIZE, 20*NOW_SIZE, 30*NOW_SIZE)];
        label.text=@"*";
        label.textColor=[UIColor redColor];
        label.font=[UIFont systemFontOfSize:20*NOW_SIZE];
        [self.view addSubview:label];
    }
    
    UIButton *mapButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton1.frame = CGRectMake(CGRectGetMaxX(self.eastlongitudeTextField.frame) - 30*NOW_SIZE, 134*NOW_SIZE + 3*60*NOW_SIZE, 30*NOW_SIZE, 30*NOW_SIZE);
    [mapButton1 setBackgroundImage:IMAGE(@"poi_1.png") forState:UIControlStateNormal];
    mapButton1.tag = 1001;
    [mapButton1 addTarget:self action:@selector(mapButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapButton1];
    
    UIButton *mapButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton2.frame = CGRectMake(CGRectGetMaxX(self.northlatitudeTextField.frame) - 30*NOW_SIZE, 134*NOW_SIZE + 4*60*NOW_SIZE, 30*NOW_SIZE, 30*NOW_SIZE);
    [mapButton2 setBackgroundImage:IMAGE(@"poi_1.png") forState:UIControlStateNormal];
    mapButton2.tag = 1002;
    [mapButton2 addTarget:self action:@selector(mapButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapButton2];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(40*NOW_SIZE, 425*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 50*NOW_SIZE);
    [nextButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [nextButton setTitle:root_Next forState:UIControlStateNormal];
    [nextButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}

- (void)mapButtonDidClicked:(UIButton *)sender {
    if (sender.tag == 1001 ||sender.tag == 1002) {
        _chooseMapActionSheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Choice", @"Choice") delegate:self cancelButtonTitle:root_Cancel destructiveButtonTitle:nil otherButtonTitles:root_Baidu_Map,root_Google_Map, nil];
        _chooseMapActionSheet.actionSheetStyle=UIActionSheetStyleAutomatic;
        [_chooseMapActionSheet showInView:self.view];
        
        //        QBPopupMenuItem *baiduMapItem = [QBPopupMenuItem itemWithTitle:root_Baidu_Map target:self action:@selector(baiduMapDidClciked)];
        //        QBPopupMenuItem *googleMapItem = [QBPopupMenuItem itemWithTitle:root_Google_Map target:self action:@selector(googleMapDidClciked)];
        //        QBPopupMenu *popupMenu = [[QBPopupMenu alloc] initWithItems:@[baiduMapItem, googleMapItem]];
        //        popupMenu.center = sender.center;
        //        [popupMenu showInView:self.view targetRect:CGRectMake(0, 134*NOW_SIZE + 3*60*NOW_SIZE, SCREEN_Width, 30*NOW_SIZE) animated:YES];
    }
    
    //    if (sender.tag == 1002) {
    //        QBPopupMenuItem *baiduMapItem = [QBPopupMenuItem itemWithTitle:root_Baidu_Map target:self action:@selector(baiduMapDidClciked)];
    //        QBPopupMenuItem *googleMapItem = [QBPopupMenuItem itemWithTitle:root_Google_Map target:self action:@selector(googleMapDidClciked)];
    //        QBPopupMenu *popupMenu = [[QBPopupMenu alloc] initWithItems:@[baiduMapItem, googleMapItem]];
    //        popupMenu.center = sender.center;
    //        [popupMenu showInView:self.view targetRect:CGRectMake(0, 134*NOW_SIZE + 4*60*NOW_SIZE, SCREEN_Width, 30*NOW_SIZE) animated:YES];
    //    }
    
}

//- (void)baiduMapDidClciked {
//    BaiduMapViewController *bmvc = [[BaiduMapViewController alloc] initToGetLocation];
//    bmvc.locationBlock = ^(CLLocationCoordinate2D coordinate) {
//        self.eastlongitudeTextField.text = [NSString stringWithFormat:@"%f", coordinate.longitude];
//        self.northlatitudeTextField.text = [NSString stringWithFormat:@"%f", coordinate.latitude];
//    };
//    [self.navigationController pushViewController:bmvc animated:YES];
//}
//
//- (void)googleMapDidClciked {
//    GoogleMapEditViewController *bmvc = [[GoogleMapEditViewController alloc] initToGetLocation];
//    bmvc.locationBlock = ^(CLLocationCoordinate2D coordinate) {
//        self.eastlongitudeTextField.text = [NSString stringWithFormat:@"%f", coordinate.longitude];
//        self.northlatitudeTextField.text = [NSString stringWithFormat:@"%f", coordinate.latitude];
//    };
//    [self.navigationController pushViewController:bmvc animated:YES];
//}

- (void)buttonDidClicked:(UIButton *)sender {
    if (_countryTextField.text.length == 0) {
        
        return;
    }
    if (_cityTextField.text.length == 0) {
        
        return;
    }
    if (_timezoneTextField.text.length == 0) {
        
        return;
    }
    if (_eastlongitudeTextField.text.length == 0) {
        
        return;
    }
    if (_northlatitudeTextField.text.length == 0) {
        
        return;
    }
    
    [self.dataDic setObject:_countryTextField.text forKey:@"plantCountry"];
    [self.dataDic setObject:_cityTextField.text forKey:@"plantCity"];
    [self.dataDic setObject:[NSNumber numberWithInteger:[_timezoneTextField.text integerValue]] forKey:@"plantTimezone"];
    [self.dataDic setObject:_eastlongitudeTextField.text forKey:@"plantLng"];
    [self.dataDic setObject:_northlatitudeTextField.text forKey:@"plantLat"];
    
    IncomeViewController *ivc = [[IncomeViewController alloc] initWithDataDict:_dataDic];
    [self.navigationController pushViewController:ivc animated:YES];
    
}

#pragma mark-UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet==_chooseMapActionSheet) {
        if (buttonIndex==0) {
            BaiduMapViewController *bmvc = [[BaiduMapViewController alloc] initToGetLocation];
            bmvc.locationBlock = ^(CLLocationCoordinate2D coordinate) {
                self.eastlongitudeTextField.text = [NSString stringWithFormat:@"%f", coordinate.longitude];
                self.northlatitudeTextField.text = [NSString stringWithFormat:@"%f", coordinate.latitude];
            };
            [self.navigationController pushViewController:bmvc animated:YES];
        }
        
        if (buttonIndex==1) {
            GoogleMapEditViewController *bmvc = [[GoogleMapEditViewController alloc] initToGetLocation];
            bmvc.locationBlock = ^(CLLocationCoordinate2D coordinate) {
                self.eastlongitudeTextField.text = [NSString stringWithFormat:@"%f", coordinate.longitude];
                self.northlatitudeTextField.text = [NSString stringWithFormat:@"%f", coordinate.latitude];
            };
            [self.navigationController pushViewController:bmvc animated:YES];
        }
    }
}

@end

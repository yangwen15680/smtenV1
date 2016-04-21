//
//  IncomeViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/21.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "IncomeViewController.h"
#import "CompleteAddViewController.h"
#import "RootPickerView.h"

@interface IncomeViewController ()

@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UITextField *coalTextField;
@property (nonatomic, strong) UITextField *co2TextField;
@property (nonatomic, strong) UITextField *so2TextField;
@property (nonatomic, strong) UITextField *moneyUnitTextField;
@property (nonatomic, strong) RootPickerView *pickerView;

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end

@implementation IncomeViewController

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
    subTitleLabel.text = root_Capital_Income;
    subTitleLabel.backgroundColor = COLOR(39, 177, 159, 1);
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:subTitleLabel];
    
    for (int i=0; i<4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20*NOW_SIZE, 134*NOW_SIZE + i*60*NOW_SIZE, 120*NOW_SIZE, 30*NOW_SIZE)];
        if (i == 0) {
            label.text = root_capital_income;
        } else if (i == 1) {
            label.text = root_standard_coal_saved;
        } else if (i == 2) {
            label.text = root_CO2_reduced;
        } else {
            label.text = root_SO2_reduced;
        }
        
        label.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20*NOW_SIZE, 165*NOW_SIZE + i*60*NOW_SIZE, SCREEN_Width - 40*NOW_SIZE, 0.5*NOW_SIZE)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:lineView];
    }
    
    _pickerView=[[RootPickerView alloc]initWithArray:@[@"RMB",@"USD",@"EUR",@"AUD",@"JPY",@"GBP"]];
    [self.view addSubview:_pickerView];

    _moneyUnitTextField=[[UITextField alloc]initWithFrame:CGRectMake(245*NOW_SIZE, 134*NOW_SIZE, 60*NOW_SIZE, 31*NOW_SIZE)];
    _moneyUnitTextField.tintColor = [UIColor whiteColor];
    [_moneyUnitTextField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_moneyUnitTextField setValue:[UIFont systemFontOfSize:14*NOW_SIZE] forKeyPath:@"_placeholderLabel.font"];
    _moneyUnitTextField.font=[UIFont systemFontOfSize:14*NOW_SIZE];
    _moneyUnitTextField.textColor=[UIColor whiteColor];
    _moneyUnitTextField.tag=1000;
    _moneyUnitTextField.delegate=_pickerView;
    _moneyUnitTextField.text=@"EUR";
    [self.view addSubview:_moneyUnitTextField];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(240*NOW_SIZE, 140*NOW_SIZE, 0.5, 15*NOW_SIZE)];
    line.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:line];

    self.moneyTextField = [[UITextField alloc] initWithFrame:CGRectMake(160*NOW_SIZE, 134*NOW_SIZE + 0*60*NOW_SIZE, SCREEN_Width - 160*NOW_SIZE - 80*NOW_SIZE, 30*NOW_SIZE)];
    self.moneyTextField.textColor = [UIColor whiteColor];
    self.moneyTextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.moneyTextField.tag=100;
    self.moneyTextField.delegate=_pickerView;
    self.moneyTextField.text=@"0.1643";
    [self.view addSubview:_moneyTextField];
    
    self.coalTextField = [[UITextField alloc] initWithFrame:CGRectMake(160*NOW_SIZE, 134*NOW_SIZE + 1*60*NOW_SIZE, SCREEN_Width - 160*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    self.coalTextField.textColor = [UIColor whiteColor];
    self.coalTextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.coalTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.coalTextField.tag=101;
    self.coalTextField.delegate=_pickerView;
    self.coalTextField.text=@"0.400";
    [self.view addSubview:_coalTextField];
    
    self.co2TextField = [[UITextField alloc] initWithFrame:CGRectMake(160*NOW_SIZE, 134*NOW_SIZE + 2*60*NOW_SIZE, SCREEN_Width - 160*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    self.co2TextField.textColor = [UIColor whiteColor];
    self.co2TextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.co2TextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.co2TextField.tag=102;
    self.co2TextField.delegate=_pickerView;
    self.co2TextField.text=@"0.997";
    [self.view addSubview:_co2TextField];
    
    self.so2TextField = [[UITextField alloc] initWithFrame:CGRectMake(160*NOW_SIZE, 134*NOW_SIZE + 3*60*NOW_SIZE, SCREEN_Width - 160*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    self.so2TextField.textColor = [UIColor whiteColor];
    self.so2TextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.so2TextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.so2TextField.tag=103;
    self.so2TextField.delegate=_pickerView;
    self.so2TextField.text=@"0.030";
    [self.view addSubview:_so2TextField];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(40*NOW_SIZE, 425*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 50*NOW_SIZE);
    [nextButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [nextButton setTitle:root_Next forState:UIControlStateNormal];
    [nextButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}

- (void)buttonDidClicked:(UIButton *)sender {
//    if (_moneyTextField.text.length == 0) {
//        
//        return;
//    }
//    if (_coalTextField.text.length == 0) {
//        
//        return;
//    }
//    if (_co2TextField.text.length == 0) {
//        
//        return;
//    }
//    if (_so2TextField.text.length == 0) {
//        
//        return;
//    }
    
    [self.dataDic setObject:[NSNumber numberWithFloat:[_moneyTextField.text floatValue]] forKey:@"plantIncome"];
    [self.dataDic setObject:[NSNumber numberWithFloat:[_coalTextField.text floatValue]] forKey:@"plantCoal"];
    [self.dataDic setObject:[NSNumber numberWithFloat:[_co2TextField.text floatValue]] forKey:@"plantCo2"];
    [self.dataDic setObject:[NSNumber numberWithFloat:[_so2TextField.text floatValue]] forKey:@"plantSo2"];
    [self.dataDic setObject:_moneyUnitTextField.text forKey:@"plantMoney"];

    CompleteAddViewController *cavc = [[CompleteAddViewController alloc] initWithDataDict:_dataDic];
    [self.navigationController pushViewController:cavc animated:YES];
}

@end

//
//  StationEarningsViewController.m
//  ShinePhone
//
//  Created by ZML on 15/5/28.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "StationEarningsViewController.h"
#import "RootPickerView.h"

@interface StationEarningsViewController ()
@property(nonatomic,strong)NSMutableArray *textFieldMutableArray;
@property (nonatomic, strong) UIView *readView;
@property (nonatomic, strong) UIView *writeView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) RootPickerView *pickerView;
@end

@implementation StationEarningsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=root_Capital_Income;
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
    
    NSArray *array=[[NSArray alloc]initWithObjects:root_capital_income,root_standard_coal_saved,root_CO2_reduced,root_SO2_reduced, nil];
    for (int i=0; i<4; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(40*NOW_SIZE, (100+i*40)*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        label.text=array[i];
        label.font=[UIFont systemFontOfSize:11*NOW_SIZE];
        label.textColor=[UIColor whiteColor];
        [self.view addSubview:label];
    }
}


-(void)readUI{
    _readView=[[UIView alloc]initWithFrame:CGRectMake(160*NOW_SIZE, 100*NOW_SIZE, 140*NOW_SIZE, 170*NOW_SIZE)];
    [self.view addSubview:_readView];
    NSString *string=[NSString stringWithFormat:@"%@ %@",_dict[@"formulaMoney"],_dict[@"formulaMoneyUnit"]];
    NSArray *array=[[NSArray alloc]initWithObjects:string,_dict[@"formulaCoal"],_dict[@"formulaCo2"],_dict[@"formulaSo2"], nil];
    for (int i=0; i<4; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0*NOW_SIZE, (0+i*40)*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        label.text=array[i];
        label.font=[UIFont systemFontOfSize:14*NOW_SIZE];
        label.textColor=[UIColor whiteColor];
        [_readView addSubview:label];
    }
}


-(void)writeUI{
    _pickerView=[[RootPickerView alloc]initWithArray:@[@"RMB",@"USD",@"EUR",@"AUD",@"JPY",@"GBP"]];
    [self.view addSubview:_pickerView];
    _writeView=[[UIView alloc]initWithFrame:CGRectMake(160*NOW_SIZE, 100*NOW_SIZE, 140*NOW_SIZE, 170*NOW_SIZE)];
    [self.view addSubview:_writeView];
    _textFieldMutableArray=[NSMutableArray new];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(110*NOW_SIZE, 5*NOW_SIZE, 40*NOW_SIZE, 30*NOW_SIZE)];
    textField.text=_dict[@"formulaMoneyUnit"];
    textField.layer.borderWidth=0.5;
    textField.layer.cornerRadius=5;
    textField.layer.borderColor=[UIColor whiteColor].CGColor;
    textField.tintColor = [UIColor whiteColor];
    [textField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont systemFontOfSize:14*NOW_SIZE] forKeyPath:@"_placeholderLabel.font"];
    textField.font=[UIFont systemFontOfSize:14*NOW_SIZE];
    textField.textColor=[UIColor whiteColor];
    textField.tag=1000;
    textField.delegate=_pickerView;
    [_writeView addSubview:textField];
    [_textFieldMutableArray addObject:textField];
    NSArray *array=[[NSArray alloc]initWithObjects:_dict[@"formulaMoney"],_dict[@"formulaCoal"],_dict[@"formulaCo2"],_dict[@"formulaSo2"], nil];
    for (int i=0; i<4; i++) {
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
        textField.tag=i;
        textField.delegate=_pickerView;
        [_writeView addSubview:textField];
        
        [_textFieldMutableArray addObject:textField];
    }
    
    
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


-(void)delButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)addButtonPressed{
    
    //3.添加/修改电站：设计功率只能为数字、时区为-12到+12、发电收益为可填可不填
    
//    NSArray *array=[[NSArray alloc]initWithObjects:@"资金收益",@"节省标准煤",@"CO2减排",@"SO2减排", nil];
//    for (int i=0; i<4; i++) {
//        if ([[_textFieldMutableArray[i] text] isEqual:@""]) {
//            [self showToastViewWithTitle:[NSString stringWithFormat:@"%@不能为空!",array[i]]];
//            return;
//        }
//    }
    
    NSRange range=[_dict[@"normalPower"] rangeOfString:@" "];
    NSRange newRange={0,range.location};
    NSString *string=[_dict[@"normalPower"] substringWithRange:newRange];
    NSRange timerange=[_dict[@"timeZone"] rangeOfString:@"T"];
    NSRange timeNewRange={timerange.location+1,[_dict[@"timeZone"] length]-timerange.location-1};
    NSString *timeString=[_dict[@"timeZone"] substringWithRange:timeNewRange];
    NSDictionary *dict=@{@"plantID":_stationId,
                         @"plantName":_dict[@"plantName"],
                         @"plantDate":_dict[@"createData"],
                         @"plantFirm":_dict[@"designCompany"],
                         @"plantPower":string,
                         @"plantCountry":_dict[@"country"],
                         @"plantCity":_dict[@"city"],
                         @"plantTimezone":timeString,
                         @"plantLat":_dict[@"plant_lat"],
                         @"plantLng":_dict[@"plant_lng"],
                         @"plantIncome":[_textFieldMutableArray[1] text],
                         @"plantMoney":[_textFieldMutableArray[0] text],
                         @"plantCoal":[_textFieldMutableArray[2] text],
                         @"plantCo2":[_textFieldMutableArray[3] text],
                         @"plantSo2":[_textFieldMutableArray[4] text]};
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


//
//  StationSafeViewController.m
//  ShinePhone
//
//  Created by ZML on 15/5/27.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "StationSafeViewController.h"

@interface StationSafeViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *textFieldMutableArray;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *finishView;
@property (nonatomic, strong) UIView *readView;
@property (nonatomic, strong) UIView *writeView;
@property (nonatomic, strong) UIView *buttonView;
@property(nonatomic)BOOL flag;
@property (nonatomic, strong) UIToolbar *toolBar;
@end

@implementation StationSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=root_Installation_Information;
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

    NSArray *array=[[NSArray alloc]initWithObjects:root_plant_name, root_instal_date, root_company, root_power, nil];
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
    NSString *normalPower=[_dict[@"normalPower"] substringWithRange:NSMakeRange(0, [_dict[@"normalPower"] length]-1) ];
    
    NSArray *array=[[NSArray alloc]initWithObjects:_dict[@"plantName"],_dict[@"createData"],_dict[@"designCompany"],normalPower, nil];
    for (int i=0; i<4; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, (i*40)*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        label.text=array[i];
        label.font=[UIFont systemFontOfSize:14*NOW_SIZE];
        label.textColor=[UIColor whiteColor];
        [_readView addSubview:label];
    }
}


-(void)writeUI{
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    
//    _finishView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_Height, SCREEN_Width, 30)];
//    _finishView.backgroundColor=COLOR(82, 201, 194, 1);
//    UILabel *finish=[[UILabel alloc]initWithFrame:CGRectMake(280*NOW_SIZE, 5*NOW_SIZE, 40*NOW_SIZE, 20*NOW_SIZE)];
//    finish.text=root_Finish;
//    finish.textColor=[UIColor whiteColor];
//    [_finishView addSubview:finish];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_Height, SCREEN_Width, 30*NOW_SIZE)];
    _toolBar.barTintColor = COLOR(39, 177, 159, 1);
    _toolBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:root_Finish style:UIBarButtonItemStyleDone target:self action:@selector(doneBarItemDidClicked)];
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    _toolBar.items = @[spaceBarItem,doneBarItem];
    
    _writeView=[[UIView alloc]initWithFrame:CGRectMake(160*NOW_SIZE, 100*NOW_SIZE, 140*NOW_SIZE, 170*NOW_SIZE)];
    [self.view addSubview:_writeView];
    _textFieldMutableArray=[NSMutableArray new];
    NSRange range=[_dict[@"normalPower"] rangeOfString:@" "];
    NSRange newRange={0,range.location};
    NSString *string=[_dict[@"normalPower"] substringWithRange:newRange];
    NSArray *array=[[NSArray alloc]initWithObjects:_dict[@"plantName"],_dict[@"createData"],_dict[@"designCompany"],string,nil];
    for (int i=0; i<4; i++) {
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(0, (5+i*40)*NOW_SIZE, 120*NOW_SIZE, 30*NOW_SIZE)];
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
        textField.delegate=self;
        if (i==3) {
            textField.keyboardType=UIKeyboardTypeDecimalPad;
        }
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
    NSArray *array=[[NSArray alloc]initWithObjects:@"电站名称",@"安装时间",@"设计厂商",@"设计功率", nil];
    for (int i=0; i<4; i++) {
        if ([[_textFieldMutableArray[i] text] isEqual:@""]) {
            [self showToastViewWithTitle:[NSString stringWithFormat:@"%@不能为空!",array[i]]];
            return;
        }
    }
    NSRange range=[_dict[@"timeZone"] rangeOfString:@"T"];
    NSRange newRange={range.location+1,[_dict[@"timeZone"] length]-range.location-1};
    NSString *timeString=[_dict[@"timeZone"] substringWithRange:newRange];
    NSDictionary *dict=@{@"plantID":_stationId,
                         @"plantName":[_textFieldMutableArray[0] text],
                         @"plantDate":[_textFieldMutableArray[1] text],
                         @"plantFirm":[_textFieldMutableArray[2] text],
                         @"plantPower":[_textFieldMutableArray[3] text],
                         @"plantCountry":_dict[@"country"],
                         @"plantCity":_dict[@"city"],
                         @"plantTimezone":timeString,
                         @"plantLat":_dict[@"plant_lat"],
                         @"plantLng":_dict[@"plant_lng"],
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.datePicker) {
        [UIView animateWithDuration:0.3f animations:^{
            self.datePicker.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 216*NOW_SIZE);
            self.finishView.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 30*NOW_SIZE);
        } completion:^(BOOL finished) {
            [self.datePicker removeFromSuperview];
            [self.finishView removeFromSuperview];
        }];
    }
    for (UITextField *textField in _textFieldMutableArray) {
        [textField resignFirstResponder];
    }
}


- (void)chooseDate:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:selectedDate];
    UITextField *textField=_textFieldMutableArray[1];
    textField.text = dateString;
    _textFieldMutableArray[1]=textField;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag != 1) {
        if (self.datePicker.superview) {
            [self.datePicker removeFromSuperview];
            [self.toolBar removeFromSuperview];
        }
        _flag=NO;
        return YES;
    }
    if (self.datePicker.superview == nil) {
        self.datePicker.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 216*NOW_SIZE);
        [self.view addSubview:self.datePicker];
        self.toolBar.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 30*NOW_SIZE);
        [self.view addSubview:self.toolBar];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.datePicker.frame = CGRectMake(0, SCREEN_Height - 216*NOW_SIZE, SCREEN_Width, 216*NOW_SIZE);
        self.toolBar.frame = CGRectMake(0, SCREEN_Height - 246*NOW_SIZE, SCREEN_Width, 30*NOW_SIZE);
        [UIView commitAnimations];
        if (_flag) {
            [self resignMethod];
        }
    }
    _flag=NO;
    return NO;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _flag=YES;
    });
    
}


-(void)resignMethod{
    for (UITextField *textField in _textFieldMutableArray) {
        [textField resignFirstResponder];
    }
}

- (void)doneBarItemDidClicked {
    [self chooseDate:_datePicker];
    
    if (self.datePicker) {
        [UIView animateWithDuration:0.3f animations:^{
            self.datePicker.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 216*NOW_SIZE);
            self.toolBar.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 30*NOW_SIZE);
        } completion:^(BOOL finished) {
            [self.datePicker removeFromSuperview];
            [self.toolBar removeFromSuperview];
        }];
    }
    [self resignFirstResponder];
}

@end

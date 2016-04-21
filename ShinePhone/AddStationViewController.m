//
//  AddStationViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/21.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "AddStationViewController.h"
#import "LocationViewController.h"

@interface AddStationViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *dateTextField;
@property (nonatomic, strong) UITextField *companyTextField;
@property (nonatomic, strong) UITextField *powerTextField;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) UIToolbar *toolBar;
@property(nonatomic)BOOL flag;
@end

@implementation AddStationViewController

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
    subTitleLabel.text = root_Installation_Information;
    subTitleLabel.backgroundColor = COLOR(39, 177, 159, 1);
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:subTitleLabel];
    
    for (int i=0; i<4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 134*NOW_SIZE + i*60*NOW_SIZE, 80*NOW_SIZE, 30*NOW_SIZE)];
        if (i == 0) {
            label.text = root_plant_name;
        } else if (i == 1) {
            label.text = root_instal_date;
        } else if (i == 2) {
            label.text = root_company;
        } else {
            label.text = root_power;
        }
        
        label.font = [UIFont systemFontOfSize:15*NOW_SIZE];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 165*NOW_SIZE + i*60*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 0.5*NOW_SIZE)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:lineView];
    }
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
//    [self.datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_Height, SCREEN_Width, 30*NOW_SIZE)];
    _toolBar.barTintColor = COLOR(39, 177, 159, 1);
    _toolBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:root_Finish style:UIBarButtonItemStyleDone target:self action:@selector(doneBarItemDidClicked)];
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    _toolBar.items = @[spaceBarItem,doneBarItem];
    
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(130*NOW_SIZE, 134*NOW_SIZE + 0*60*NOW_SIZE, SCREEN_Width - 134*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    self.nameTextField.textColor = [UIColor whiteColor];
    self.nameTextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.nameTextField.tag = 1001;
    self.nameTextField.delegate = self;
    [self.view addSubview:_nameTextField];
    
    self.dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(130*NOW_SIZE, 134*NOW_SIZE + 1*60*NOW_SIZE, SCREEN_Width - 134*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    self.dateTextField.textColor = [UIColor whiteColor];
    self.dateTextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.dateTextField.delegate = self;
    self.dateTextField.tag = 1002;
    [self.view addSubview:_dateTextField];
    
    self.companyTextField = [[UITextField alloc] initWithFrame:CGRectMake(130*NOW_SIZE, 134*NOW_SIZE + 2*60*NOW_SIZE, SCREEN_Width - 134*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    self.companyTextField.textColor = [UIColor whiteColor];
    self.companyTextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.companyTextField.tag = 1003;
    self.companyTextField.delegate = self;
    [self.view addSubview:_companyTextField];
    
    self.powerTextField = [[UITextField alloc] initWithFrame:CGRectMake(130*NOW_SIZE, 134*NOW_SIZE + 3*60*NOW_SIZE, SCREEN_Width - 134*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    self.powerTextField.textColor = [UIColor whiteColor];
    self.powerTextField.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    self.powerTextField.tag = 1004;
    self.powerTextField.keyboardType=UIKeyboardTypeDecimalPad;
    self.powerTextField.delegate = self;
    [self.view addSubview:_powerTextField];
    
    for (int i=0; i<4; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(300*NOW_SIZE, (134+i*60)*NOW_SIZE, 20*NOW_SIZE, 30*NOW_SIZE)];
        label.text=@"*";
        label.textColor=[UIColor redColor];
        label.font=[UIFont systemFontOfSize:20*NOW_SIZE];
        [self.view addSubview:label];
    }
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(40*NOW_SIZE, 425*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 50*NOW_SIZE);
    [nextButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [nextButton setTitle:root_Next forState:UIControlStateNormal];
    [nextButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];

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
    
    [_nameTextField resignFirstResponder];
    [_dateTextField resignFirstResponder];
    [_companyTextField resignFirstResponder];
    [_powerTextField resignFirstResponder];
}

- (void)buttonDidClicked:(UIButton *)sender {
    if (_nameTextField.text.length == 0) {
        
        return;
    }
    if (_dateTextField.text.length == 0) {
        
        return;
    }
    if (_companyTextField.text.length == 0) {
        
        return;
    }
    if (_powerTextField.text.length == 0) {
        
        return;
    }
    //检查电站名字是否已经被使用
    [self showProgressView];
    [BaseRequest requestWithMethodResponseStringResult:HEAD_URL paramars:@{@"plantName":_nameTextField.text} paramarsSite:@"/plantA.do?op=checkPlantName" sucessBlock:^(id content) {
        [self hideProgressView];
        if (content) {
            NSString *res = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
            if ([res isEqualToString:@"false"]) {
                //未被使用
                self.dataDic = [NSMutableDictionary dictionary];
                [self.dataDic setObject:_nameTextField.text forKey:@"plantName"];
                [self.dataDic setObject:_dateTextField.text forKey:@"plantDate"];
                [self.dataDic setObject:_companyTextField.text forKey:@"plantFirm"];
                [self.dataDic setObject:_powerTextField.text forKey:@"plantPower"];
                
                LocationViewController *lvc = [[LocationViewController alloc] initWithDataDict:_dataDic];
                [self.navigationController pushViewController:lvc animated:YES];
            } else {
                //已被使用
                [self showAlertViewWithTitle:nil message:NSLocalizedString(@"Power station name has been used！", @"Power station name has been used！") cancelButtonTitle:root_Yes];
            }
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
            self.toolBar.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 30*NOW_SIZE);
        } completion:^(BOOL finished) {
            [self.datePicker removeFromSuperview];
            [self.toolBar removeFromSuperview];
        }];
    }
    
    [_nameTextField resignFirstResponder];
    [_dateTextField resignFirstResponder];
    [_companyTextField resignFirstResponder];
    [_powerTextField resignFirstResponder];
    
}

- (void)chooseDate:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:selectedDate];
    self.dateTextField.text = dateString;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag != 1002) {
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
    [_nameTextField resignFirstResponder];
    [_dateTextField resignFirstResponder];
    [_companyTextField resignFirstResponder];
    [_powerTextField resignFirstResponder];
}

@end

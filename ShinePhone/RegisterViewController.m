//
//  registerViewController.m
//  ShinePhone
//
//  Created by ZML on 15/5/20.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomePageViewController.h"
#import "IQDropDownTextField.h"

@interface RegisterViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic,strong)UIScrollView *backScroll;
@property(nonatomic,strong)NSMutableArray *textFieldMutableArray;
@property(nonatomic,strong)NSString *testString;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)UITextField *verificationTextField;
@property(nonatomic,strong)UIButton *verificationButton;

@property (nonatomic, strong) UIPickerView *languagePicker;
@property (nonatomic, strong) UIToolbar *toolBar;

@property (nonatomic, strong) NSArray *languageArr;
@property(nonatomic,strong)IQDropDownTextField *dropDownTextField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textFieldMutableArray=[NSMutableArray new];
    _languageArr = [NSArray arrayWithObjects:@"English", @"中文", @"Français", @"日本語", @"In Italiano", @"Nederland", @"Türkçe", @"Polish", nil];
    [self initUI];
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)initUI {
    self.title = root_Register;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _backScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_Width, SCREEN_Height - 64)];
    [self.view addSubview:_backScroll];
    
    NSArray *imageArray=[NSArray arrayWithObjects:@"用户名.png", @"密码.png", @"邮箱.png", @"手机号码.png", @"公司名称.png", @"采集器序列号.png", @"采集器效验码.png", @"时区.png", @"语言.png", nil];
    NSArray *labelArray=[NSArray arrayWithObjects:root_username, root_password, root_e_mail, root_telphone, root_company_name, root_datalog_sn, root_datalog_valicode, root_timezone, root_language, nil];
    NSArray *textFieldArray=[NSArray arrayWithObjects:root_Enter_your_username, root_Enter_your_pwd, root_Enter_email, root_Enter_phone_number, root_Enter_company_name, root_Enter_DatalogSN, root_Datalog_valicode, root_Select_a_timezone, root_Enter_the_language, nil];
    for (int i=0; i<9; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(30*NOW_SIZE,17*NOW_SIZE+i*60*NOW_SIZE, 15*NOW_SIZE, 15*NOW_SIZE)];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds=YES;
        imageView.image=[UIImage imageNamed:imageArray[i]];
        [_backScroll addSubview:imageView];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50*NOW_SIZE,10*NOW_SIZE+i*60*NOW_SIZE, 100*NOW_SIZE, 30*NOW_SIZE)];
        label.text=labelArray[i];
        label.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        label.textColor=[UIColor whiteColor];
        [_backScroll addSubview:label];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(30*NOW_SIZE,40*NOW_SIZE+i*60*NOW_SIZE, 260*NOW_SIZE, 0.5)];
        line.backgroundColor=[UIColor whiteColor];
        [_backScroll addSubview:line];
        
        if (i !=7 && i!=8) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(155*NOW_SIZE,10*NOW_SIZE+i*60*NOW_SIZE, 135*NOW_SIZE, 30*NOW_SIZE)];
            textField.placeholder =textFieldArray[i];
            textField.textColor = [UIColor whiteColor];
            textField.tintColor = [UIColor whiteColor];
            [textField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
            [textField setValue:[UIFont systemFontOfSize:11*NOW_SIZE] forKeyPath:@"_placeholderLabel.font"];
            textField.font = [UIFont systemFontOfSize:11*NOW_SIZE];
            textField.tag = i;
            textField.delegate = self;
            [_backScroll addSubview:textField];
            [_textFieldMutableArray addObject:textField];
            if (i == 1 || i == 5 || i == 6) {
                textField.keyboardType = UIKeyboardTypeASCIICapable;
                textField.secureTextEntry = YES;
            }
            if (i == 2) {
                textField.keyboardType = UIKeyboardTypeEmailAddress;
            }
            if (i == 3) {
                textField.keyboardType = UIKeyboardTypePhonePad;
            }
        }else{
            IQDropDownTextField *textField=[[IQDropDownTextField alloc]initWithFrame:CGRectMake(155*NOW_SIZE,10*NOW_SIZE+i*60*NOW_SIZE, 135*NOW_SIZE, 30*NOW_SIZE)];
            textField.placeholder =textFieldArray[i];
            textField.textColor = [UIColor whiteColor];
            textField.tintColor = [UIColor whiteColor];
            [textField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
            [textField setValue:[UIFont systemFontOfSize:11*NOW_SIZE] forKeyPath:@"_placeholderLabel.font"];
            textField.font = [UIFont systemFontOfSize:11*NOW_SIZE];
            if (i==7) {
                [textField setItemList:[NSArray arrayWithObjects:@"+1",@"+2",@"+3",@"+4",@"+5",@"+6",@"+7",@"+8",@"+9",@"+10",@"+11",@"+12",@"-1",@"-2",@"-3",@"-4",@"-5",@"-6",@"-7",@"-8",@"-9",@"-10",@"-11",@"-12",nil]];
            }else{
                [textField setItemList:[NSArray arrayWithObjects:@"English", @"中文", @"Français", @"日本語", @"In Italiano", @"Nederland", @"Türkçe", @"Polish",nil]];
            }
            [_backScroll addSubview:textField];
            [_textFieldMutableArray addObject:textField];
        }
    }
    
    _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(50*NOW_SIZE,540*NOW_SIZE, 100*NOW_SIZE, 40*NOW_SIZE)];
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapToGenerateCode)];
    _numberLabel.userInteractionEnabled=YES;
    [_numberLabel  addGestureRecognizer:imageTap];
    [_backScroll addSubview:_numberLabel];
    [self onTapToGenerateCode];
    
    
    UIImageView *verificationImageView=[[UIImageView alloc]initWithFrame:CGRectMake(190*NOW_SIZE, 545*NOW_SIZE, 93*NOW_SIZE, 40*NOW_SIZE)];
    verificationImageView.image=[UIImage imageNamed:@"验证码框.png"];
    verificationImageView.contentMode=UIViewContentModeScaleAspectFit;
    verificationImageView.clipsToBounds=YES;
    verificationImageView.userInteractionEnabled = YES;
    [_backScroll addSubview:verificationImageView];
    
    _verificationTextField=[[UITextField alloc]initWithFrame:CGRectMake(10*NOW_SIZE, 10*NOW_SIZE, 73*NOW_SIZE, 20*NOW_SIZE)];
    _verificationTextField.placeholder=root_Enter_code;
    _verificationTextField.textColor = [UIColor whiteColor];
    _verificationTextField.tintColor = [UIColor whiteColor];
    _verificationTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _verificationTextField.font = [UIFont systemFontOfSize:10*NOW_SIZE];
    [_verificationTextField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_verificationTextField setValue:[UIFont systemFontOfSize:10*NOW_SIZE] forKeyPath:@"_placeholderLabel.font"];
    [verificationImageView addSubview:_verificationTextField];
    
    UIButton *confirmButton=[[UIButton alloc]initWithFrame:CGRectMake(30*NOW_SIZE,650*NOW_SIZE, 260*NOW_SIZE, 50*NOW_SIZE)];
    [confirmButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:root_Finish forState:UIControlStateNormal];
    [confirmButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    [_backScroll addSubview:confirmButton];
    _backScroll.contentSize=CGSizeMake(SCREEN_Width, CGRectGetMaxY(confirmButton.frame)+50);
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backScrollDidTapped:)];
    [_backScroll addGestureRecognizer:tapGesture];

}

- (void)backScrollDidTapped:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.languagePicker) {
            [UIView animateWithDuration:0.3f animations:^{
                self.languagePicker.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 216*NOW_SIZE);
                self.toolBar.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 30*NOW_SIZE);
            } completion:^(BOOL finished) {
                [self.languagePicker removeFromSuperview];
                [self.toolBar removeFromSuperview];
            }];
        }
        
        for (UITextField *textField in _textFieldMutableArray) {
            [textField resignFirstResponder];
        }
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.languagePicker) {
        [UIView animateWithDuration:0.3f animations:^{
            self.languagePicker.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 216*NOW_SIZE);
            self.toolBar.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 30*NOW_SIZE);
        } completion:^(BOOL finished) {
            [self.languagePicker removeFromSuperview];
            [self.toolBar removeFromSuperview];
        }];
    }
    
    for (UITextField *textField in _textFieldMutableArray) {
        [textField resignFirstResponder];
    }
    
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag != 8) {
        if (self.languagePicker) {
            [self.languagePicker removeFromSuperview];
            [self.toolBar removeFromSuperview];
        }
        return YES;
    }
    
    if (!_toolBar) {
        self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_Height, SCREEN_Width, 30)];
        UIBarButtonItem *sapceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:root_Finish style:UIBarButtonItemStyleDone target:self action:@selector(completeSelect)];
        self.toolBar.barTintColor = COLOR(39, 177, 159, 1);
        self.toolBar.tintColor = [UIColor whiteColor];
        self.toolBar.items = @[sapceItem, doneItem];
    }
    
    if (!_languagePicker) {
        self.languagePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_Height, SCREEN_Width, 216)];
        self.languagePicker.backgroundColor = [UIColor whiteColor];
        self.languagePicker.dataSource = self;
        self.languagePicker.delegate = self;
    }
    
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view addSubview:self.toolBar];
        [self.view addSubview:self.languagePicker];
        self.toolBar.frame = CGRectMake(0, SCREEN_Height - 246, SCREEN_Width, 30);
        self.languagePicker.frame = CGRectMake(0, SCREEN_Height - 216, SCREEN_Width, 216);
    }];
    
    return NO;
}



- (void)completeSelect {
    UITextField *textfield = (UITextField *)[self.view viewWithTag:8];
    if (textfield.isFirstResponder) {
        [textfield resignFirstResponder];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.toolBar removeFromSuperview];
        [self.languagePicker removeFromSuperview];
        self.toolBar.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 30);
        self.languagePicker.frame = CGRectMake(0, SCREEN_Height, SCREEN_Width, 216);
    }];
    
    NSInteger selectedRow = [_languagePicker  selectedRowInComponent:0];
    textfield.text = _languageArr[selectedRow];
}


-(void)confirmButtonPressed:(UIButton *)sender{
    
    NSArray *array=[[NSArray alloc]initWithObjects:root_Please_insert_username, root_Enter_your_pwd, root_E_mail_format_error, root_The_phone_number_can_not_be_empty, root_Company_name_can_not_be_empty, root_Insert_true_datalog_sn, root_Insert_datalog_code, root_Select_a_timezone, root_Language_can_not_be_empty, nil];
    for (int i=0; i<9; i++) {
        if ([[_textFieldMutableArray[i] text] isEqual:@""]) {
            [self showToastViewWithTitle:array[i]];
            return;
        }
    }
    if ([[_textFieldMutableArray[1] text] length]<6) {
        [self showToastViewWithTitle:root_Password_must_more_than_six_word];
        return;
    }
    if (![self isValidateEmail:[_textFieldMutableArray[2] text]]) {
        [self showToastViewWithTitle:root_E_mail_format_error];
        return;
    }
    if (![self isValidateTel:[_textFieldMutableArray[3] text]]) {
        [self showToastViewWithTitle:root_Phone_number_format_is_incorrect];
        return;
    }
    if ([[_textFieldMutableArray[5] text] length]!=10) {
        [self showToastViewWithTitle:NSLocalizedString(@"Acquisition sequence number must be 10!", @"Acquisition sequence number must be 10!")];
        return;
    }
    
    if (![_verificationTextField.text isEqual:_code]) {
        [self showToastViewWithTitle:root_Valicode_error];
        return;
    }
    
    //  NSDictionary *dictUserName=@{@"regUserName":[_textFieldMutableArray[0] text]};
    NSDictionary *dictcheckCode=@{@"dataLogSN":[_textFieldMutableArray[5] text],
                                  @"checkCode":[_textFieldMutableArray[6] text]};
    NSDictionary *dict=@{@"regUserName":[_textFieldMutableArray[0] text],
                         @"regPassword":[_textFieldMutableArray[1] text],
                         @"regEmail":[_textFieldMutableArray[2] text],
                         @"regPhoneNumber":[_textFieldMutableArray[3] text],
                         @"regCompanyName":[_textFieldMutableArray[4] text],
                         @"regDataLoggerNo":[_textFieldMutableArray[5] text],
                         @"regTimeZone":[_textFieldMutableArray[7] text],
                         @"regLanguage":[_textFieldMutableArray[8] text]};
    NSLog(@"testtesr: %@", dict);
    
    [self showProgressView];
    
    
    [BaseRequest requestWithMethod:HEAD_URL paramars:@{@"regUserName":[_textFieldMutableArray[0] text]} paramarsSite:@"/userInfoAPI.do" sucessBlock:^(id content) {
        NSLog(@"userInfoAPI: %@", content);
        [self hideProgressView];
        if (content) {
            if ([content[@"success"] integerValue] == 0) {
                [BaseRequest requestWithMethod:HEAD_URL paramars:dictcheckCode paramarsSite:@"/registerAPI.do?action=checkDataLogSn" sucessBlock:^(id content) {
                    NSLog(@"checkDataLogSn: %@", content);
                    [self hideProgressView];
                    if (content) {
                        if ([content[@"msg"] isEqual:@"success"]) {
                            [BaseRequest requestWithMethod:HEAD_URL paramars:dict paramarsSite:@"/registerAPI.do?action=creatAccount" sucessBlock:^(id content) {
                                NSLog(@"creatAccount: %@", content);
                                [self hideProgressView];
                                if (content) {
                                    if ([content[@"back"][@"success"] integerValue] == 0) {
                                        //注册失败
                                        if ([content[@"back"][@"msg"] isEqual:@"error_userCountLimit"]) {
                                            [self showAlertViewWithTitle:nil message:@"超出版本限制注册用户数量" cancelButtonTitle:root_Yes];
                                        }else{
                                            //注册成功
                                            [self succeedRegister];
                                            [self showAlertViewWithTitle:nil message:root_Registration_success  cancelButtonTitle:root_Yes];
                                        }
                                    } else {
                                        //注册成功
                                        [self succeedRegister];
                                        [self showAlertViewWithTitle:nil message:root_Registration_success cancelButtonTitle:root_Yes];
                                    }
                                }
                                
                            } failure:^(NSError *error) {
                                [self hideProgressView];
                                [self showToastViewWithTitle:root_Networking];
                            }];
                        } else if([content[@"msg"] isEqual:@"dataLogSn_Exist"]) {
                            [self showAlertViewWithTitle:nil message:@"采集器已被注册" cancelButtonTitle:root_Yes];
                        }else {
                            [self showAlertViewWithTitle:nil message:root_Datalog_verification_code_is_incorrect cancelButtonTitle:root_Yes];
                        }
                    }
                    
                } failure:^(NSError *error) {
                    [self hideProgressView];
                    [self showToastViewWithTitle:root_Networking];
                }];
                
            } else {
                [self showAlertViewWithTitle:nil message:@"用户名已被使用" cancelButtonTitle:root_Yes];
            }
        }
        
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
    
}


//注册成功
-(void)succeedRegister{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0*NOW_SIZE, 0*NOW_SIZE, SCREEN_Width, SCREEN_Height)];
    UIImage *bgImage = IMAGE(@"bg_login.png");
    view.layer.contents = (id)bgImage.CGImage;
    [self.view addSubview:view];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(100*NOW_SIZE, 160*NOW_SIZE, 120*NOW_SIZE, 90*NOW_SIZE)];
    imageView.image=[UIImage imageNamed:@"勾-02.png"];
    [view addSubview:imageView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(120*NOW_SIZE, 260*NOW_SIZE, 80*NOW_SIZE, 20*NOW_SIZE)];
    label.text=root_Registration_success;
    //label.contentMode=UITextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [view addSubview:label];
    
    UIButton *loginButton=[[UIButton alloc]initWithFrame:CGRectMake(30*NOW_SIZE,350*NOW_SIZE, 260*NOW_SIZE, 50*NOW_SIZE)];
    [loginButton setImage:[UIImage imageNamed:@"登录.png"] forState:0];
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:loginButton];
}


//登录首页
-(void)loginButtonPressed:(UIButton *)sender{
    HomePageViewController *hpvc = [[HomePageViewController alloc] init];
    [self.navigationController pushViewController:hpvc animated:YES];
}


//判断是否是正确的email
-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



//判断手机号码
- (BOOL)isValidateTel:(NSString *)tel {
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:tel];
}



//生成验证码
- (void)onTapToGenerateCode {
    for (UIView *view in self.numberLabel.subviews) {
        [view removeFromSuperview];
    }
    // @{
    // @name 生成背景色
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.2];
    [_numberLabel setBackgroundColor:color];
    // @} end 生成背景色
    
    // @{
    // @name 生成文字
    const int count = 5;
    char data[count];
    for (int x = 0; x < count; x++) {
        int j = '0' + (arc4random_uniform(75));
        if((j >= 58 && j <= 96)){
            --x;
        }else{
            data[x] = (char)j;
        }
    }
    NSString *text = [[NSString alloc] initWithBytes:data
                                              length:count encoding:NSUTF8StringEncoding];
    _code = text;
    // @} end 生成文字
    
    //CGSize cSize = [@"S" sizeWithFont:[UIFont systemFontOfSize:16]];
    int width = _numberLabel.frame.size.width / text.length;
    int height = _numberLabel.frame.size.height/8;
    CGPoint point;
    float pX, pY;
    for (int i = 0; i < count; i++) {
        pX = arc4random() % width + (_numberLabel.frame.size.width-10*NOW_SIZE) / text.length * i - 1;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        UILabel *tempLabel = [[UILabel alloc]
                              initWithFrame:CGRectMake(pX, pY,
                                                       _numberLabel.frame.size.width / 4,
                                                       _numberLabel.frame.size.height)];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        // 字体颜色
        float red = arc4random() % 100 / 100.0;
        float green = arc4random() % 100 / 100.0;
        float blue = arc4random() % 100 / 100.0;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        tempLabel.textColor = color;
        tempLabel.text = textC;
        tempLabel.font=[UIFont fontWithName:nil size:25];
        [_numberLabel addSubview:tempLabel];
    }
    
    NSLog(@"testtest: %@", _code);
    return;
}

#pragma mark picker delegate datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _languageArr.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _languageArr[row];
}



@end

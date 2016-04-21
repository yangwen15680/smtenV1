//
//  LoginViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/18.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "LoginViewController.h"
#import "ZJSwitch.h"
#import "AboutViewController.h"
#import "RegisterViewController.h"
#import "HomePageViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) ZJSwitch *autoLoginSwitch;
@property (nonatomic, strong) ZJSwitch *rememberPwdSwitch;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registButton;
@property (nonatomic, strong) UIButton *aboutButton;
@property (nonatomic, strong) UIButton *sampleButton;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.rememberPwdSwitch.on == NO) {
        [[UserInfo defaultUserInfo] setUserPassword:@""];
        self.pwdTextField.text = [UserInfo defaultUserInfo].userPassword;
    }
}


- (void)initUI {
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Height)];
    [self.view addSubview:_scrollView];
    
    //logo
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(20*NOW_SIZE, 80*NOW_SIZE, SCREEN_Width - 40*NOW_SIZE, 60*NOW_SIZE)];
    logo.image = IMAGE(@"icon_logo.png");
    [_scrollView addSubview:logo];
    
    //用户名
    UIImageView *userBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 210*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 45*NOW_SIZE)];
    userBgImageView.userInteractionEnabled = YES;
    userBgImageView.image = IMAGE(@"账号3.png");
    [_scrollView addSubview:userBgImageView];
    
    self.userTextField = [[UITextField alloc] initWithFrame:CGRectMake(50*NOW_SIZE, 0, CGRectGetWidth(userBgImageView.frame) - 50*NOW_SIZE, 45*NOW_SIZE)];
    self.userTextField.placeholder = root_Enter_your_username;
    self.userTextField.textColor = [UIColor whiteColor];
    self.userTextField.tintColor = [UIColor whiteColor];
    [self.userTextField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.userTextField setValue:[UIFont systemFontOfSize:13*NOW_SIZE] forKeyPath:@"_placeholderLabel.font"];
    self.userTextField.font = [UIFont systemFontOfSize:15*NOW_SIZE];
    [userBgImageView addSubview:_userTextField];
    
    //密码
    UIImageView *pwdBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 270*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 45*NOW_SIZE)];
    pwdBgImageView.image = IMAGE(@"密码3.png");
    pwdBgImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:pwdBgImageView];
    
    self.pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(50*NOW_SIZE, 0, CGRectGetWidth(pwdBgImageView.frame) - 50*NOW_SIZE, 45*NOW_SIZE)];
    self.pwdTextField.placeholder = root_Enter_your_pwd;
    self.pwdTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.pwdTextField.secureTextEntry = YES;
    self.pwdTextField.textColor = [UIColor whiteColor];
    self.pwdTextField.tintColor = [UIColor whiteColor];
    [self.pwdTextField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.pwdTextField setValue:[UIFont systemFontOfSize:13*NOW_SIZE] forKeyPath:@"_placeholderLabel.font"];
    [pwdBgImageView addSubview:_pwdTextField];
    
    //自动登陆开关
    self.autoLoginSwitch = [[ZJSwitch alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 330*NOW_SIZE, 100*NOW_SIZE, 20*NOW_SIZE)];
    self.autoLoginSwitch.backgroundColor = [UIColor clearColor];
    self.autoLoginSwitch.tintColor = COLOR(11, 141, 115, 1);
    self.autoLoginSwitch.onTintColor = COLOR(79, 178, 31, 1);
    self.autoLoginSwitch.thumbTintColor = COLOR(237, 239, 84, 1);
    
    self.autoLoginSwitch.onText = root_Auto_Login;
    self.autoLoginSwitch.offText = root_Auto_Login;
    self.autoLoginSwitch.tag = 10;
    [self.autoLoginSwitch addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_autoLoginSwitch];
    
    
    //记住密码开关
    self.rememberPwdSwitch = [[ZJSwitch alloc] initWithFrame:CGRectMake(170*NOW_SIZE, 330*NOW_SIZE, 100*NOW_SIZE, 20*NOW_SIZE)];
    self.rememberPwdSwitch.backgroundColor = [UIColor clearColor];
    self.rememberPwdSwitch.tintColor = COLOR(11, 141, 115, 1);
    self.rememberPwdSwitch.onTintColor = COLOR(79, 178, 31, 1);
    self.rememberPwdSwitch.thumbTintColor = COLOR(237, 239, 84, 1);
    self.rememberPwdSwitch.onText = root_Remember;
    self.rememberPwdSwitch.offText = root_Remember;
    self.rememberPwdSwitch.tag = 11;
    [self.rememberPwdSwitch addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_rememberPwdSwitch];
    
    //登陆按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(40*NOW_SIZE, 390*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 50*NOW_SIZE);
    [self.loginButton setBackgroundImage:IMAGE(@"圆角矩形3.png") forState:UIControlStateNormal];
    [self.loginButton setTitle:root_Sign_In forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.tag = 12;
    [self.loginButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_loginButton];
    
    //注册按钮
    self.registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registButton.frame = CGRectMake(40*NOW_SIZE, 450*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 50*NOW_SIZE);
    [self.registButton setBackgroundImage:IMAGE(@"圆角矩形3.png") forState:UIControlStateNormal];
    [self.registButton setTitle:root_New_User forState:UIControlStateNormal];
    [self.registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registButton.tag = 13;
    [self.registButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_registButton];
    
    //关于按钮
    self.aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.aboutButton.frame = CGRectMake(10*NOW_SIZE, 520*NOW_SIZE, 140*NOW_SIZE, 20*NOW_SIZE);
    [self.aboutButton setTitle:root_About forState:UIControlStateNormal];
    [self.aboutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.aboutButton.titleLabel.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    self.aboutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.aboutButton.tag = 14;
    [self.aboutButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_aboutButton];
    
    //示例按钮
    self.sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sampleButton.frame = CGRectMake(160*NOW_SIZE, 520*NOW_SIZE, 150*NOW_SIZE, 20*NOW_SIZE);
    [self.sampleButton setTitle:root_Example_Plants forState:UIControlStateNormal];
    [self.sampleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sampleButton.titleLabel.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    self.sampleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.sampleButton.tag = 15;
    [self.sampleButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sampleButton];
    
    _scrollView.contentSize=CGSizeMake(SCREEN_Width, CGRectGetMaxY(_sampleButton.frame));
    
}

- (void)initData {
    self.userTextField.text = [UserInfo defaultUserInfo].userName;
    self.pwdTextField.text = [UserInfo defaultUserInfo].userPassword;
    self.autoLoginSwitch.on = [UserInfo defaultUserInfo].isAutoLogin;
    self.rememberPwdSwitch.on = [UserInfo defaultUserInfo].isRememberPwd;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma UI事件
- (void)handleSwitchEvent:(UISwitch *)sender {
    if (sender.tag == 10) {
        //autoLoginSwitch
        NSLog(@"%d", sender.on);
        if (sender.on == YES) {
            self.rememberPwdSwitch.on = YES;
        }
        [[UserInfo defaultUserInfo] setIsAutoLogin:sender.on];
    }
    
    if (sender.tag == 11) {
        //rememberPwdSwitch
        NSLog(@"%d", sender.on);
        [[UserInfo defaultUserInfo] setIsRememberPwd:sender.on];
    }
}

- (void)buttonDidClicked:(UIButton *)sender {
    if (sender.tag == 12) {
        //登陆按钮
        if (_userTextField.text.length ==  0) {
            [self showToastViewWithTitle:root_Enter_your_username];
            return;
        }
        
        if (_pwdTextField.text.length == 0) {
            [self showToastViewWithTitle:root_Enter_your_pwd];
            return;
        }
        
        [self showProgressView];
        [BaseRequest requestWithMethod:HEAD_URL paramars:@{@"userName":_userTextField.text, @"password":[self MD5:_pwdTextField.text]} paramarsSite:@"/LoginAPI.do" sucessBlock:^(id content) {
            [self hideProgressView];
            NSLog(@"TEST:%@",content);
            if ([content[@"userLevel"] integerValue]==2) {
                [[NSUserDefaults standardUserDefaults] setObject:@"isDemo" forKey:@"isDemo"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"isNotDemo" forKey:@"isDemo"];
            }
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
                    
                    if (_rememberPwdSwitch.on) {
                        [[UserInfo defaultUserInfo] setUserPassword:_pwdTextField.text];
                    }
                    [[UserInfo defaultUserInfo] setUserName:_userTextField.text];
                    [[UserInfo defaultUserInfo] setUserId:content[@"userId"]];
                    [[UserInfo defaultUserInfo] setIsRememberPwd:_rememberPwdSwitch.on];
                    [[UserInfo defaultUserInfo] setIsAutoLogin:_autoLoginSwitch.on];
                    
                    HomePageViewController *hpvc = [[HomePageViewController alloc] init];
                    hpvc.example=NO;
                    [self.navigationController pushViewController:hpvc animated:YES];
                }
            }
            
        } failure:^(NSError *error) {
            [self hideProgressView];
            [self showToastViewWithTitle:root_Networking];
        }];
    }
    
    if (sender.tag == 13) {
        //注册按钮
        RegisterViewController *reg=[[RegisterViewController alloc]init];
        [self.navigationController pushViewController:reg animated:YES];
    }
    
    if (sender.tag == 14) {
        //关于按钮
        AboutViewController *avc = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:avc animated:YES];
    }
    
    if (sender.tag == 15) {
        //示例按钮
        HomePageViewController *hpvc = [[HomePageViewController alloc] init];
        hpvc.example=YES;
        [self.navigationController pushViewController:hpvc animated:YES];
    }
    
}

@end

//
//  AboutViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/19.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "AboutViewController.h"
#import "CompanyViewController.h"
#import "ProductInfoViewController.h"
#import "VersionInfoViewController.h"
#import "UpdateInfoViewController.h"

@interface AboutViewController ()

@property (nonatomic, strong) UIButton *companyInfoButton;
@property (nonatomic, strong) UIButton *productInfoButton;
@property (nonatomic, strong) UIButton *versionInfoButton;
@property (nonatomic, strong) UIButton *updateInfoButton;
@property (nonatomic, strong) UIButton *changeServerButton;
@property (nonatomic, strong) UITextField *textfield;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)initUI {
    self.title = root_About;
    
    //logo文字
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 90*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 40*NOW_SIZE)];
    logoLabel.text = ABOUT_LOGO_TITLE;
    logoLabel.textAlignment = NSTextAlignmentCenter;
    logoLabel.textColor = [UIColor whiteColor];
    logoLabel.font = [UIFont systemFontOfSize:40*NOW_SIZE];
    [self.view addSubview:logoLabel];
    
    //版权信息
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_Height - 30*NOW_SIZE, SCREEN_Width, 30*NOW_SIZE)];
    infoLabel.text = ABOUT_INFO;
    infoLabel.font = [UIFont systemFontOfSize:10*NOW_SIZE];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoLabel];
    
    //公司信息
    self.companyInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.companyInfoButton.frame = CGRectMake(40*NOW_SIZE, 170*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 45*NOW_SIZE);
    [self.companyInfoButton setBackgroundImage:IMAGE(@"about_btn_bg.png") forState:UIControlStateNormal];
    [self.companyInfoButton setTitle:root_Company_Information forState:UIControlStateNormal];
    self.companyInfoButton.titleLabel.font = [UIFont systemFontOfSize:15*NOW_SIZE];
    self.companyInfoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.companyInfoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20*NOW_SIZE, 0, 0);
    self.companyInfoButton.tag = 10;
    [self.companyInfoButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_companyInfoButton];
    
    //产品信息
    self.productInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.productInfoButton.frame = CGRectMake(40*NOW_SIZE, 230*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 45*NOW_SIZE);
    [self.productInfoButton setBackgroundImage:IMAGE(@"about_btn_bg.png") forState:UIControlStateNormal];
    [self.productInfoButton setTitle:root_Product_Information forState:UIControlStateNormal];
    self.productInfoButton.titleLabel.font = [UIFont systemFontOfSize:15*NOW_SIZE];
    self.productInfoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.productInfoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20*NOW_SIZE, 0, 0);
    self.productInfoButton.tag = 11;
    [self.productInfoButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_productInfoButton];
    
    //版本信息
    self.versionInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.versionInfoButton.frame = CGRectMake(40*NOW_SIZE, 290*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 45*NOW_SIZE);
    [self.versionInfoButton setBackgroundImage:IMAGE(@"about_btn_bg.png") forState:UIControlStateNormal];
    [self.versionInfoButton setTitle:ABOUT_VERSIONINFO forState:UIControlStateNormal];
    self.versionInfoButton.titleLabel.font = [UIFont systemFontOfSize:15*NOW_SIZE];
    self.versionInfoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.versionInfoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20*NOW_SIZE, 0, 0);
    self.versionInfoButton.tag = 12;
    [self.versionInfoButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_versionInfoButton];
    
    //更新日志
    self.updateInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.updateInfoButton.frame = CGRectMake(40*NOW_SIZE, 350*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 45*NOW_SIZE);
    [self.updateInfoButton setBackgroundImage:IMAGE(@"about_btn_bg.png") forState:UIControlStateNormal];
    [self.updateInfoButton setTitle:root_Update_Log forState:UIControlStateNormal];
    self.updateInfoButton.titleLabel.font = [UIFont systemFontOfSize:15*NOW_SIZE];
    self.updateInfoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.updateInfoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20*NOW_SIZE, 0, 0);
    self.updateInfoButton.tag = 13;
    [self.updateInfoButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_updateInfoButton];
    
    //修改服务器地址
    self.changeServerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeServerButton.frame = CGRectMake(40*NOW_SIZE, 410*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 45*NOW_SIZE);
    [self.changeServerButton setBackgroundImage:IMAGE(@"about_btn_bg.png") forState:UIControlStateNormal];
    [self.changeServerButton setTitle:root_Server_address_changes forState:UIControlStateNormal];
    self.changeServerButton.titleLabel.font = [UIFont systemFontOfSize:15*NOW_SIZE];
    self.changeServerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.changeServerButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20*NOW_SIZE, 0, 0);
    self.changeServerButton.tag = 14;
    [self.changeServerButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeServerButton];
}

- (void)buttonDidClicked:(UIButton *)sender {
    if (sender.tag == 10) {
        CompanyViewController *civc = [[CompanyViewController alloc] init];
        [self.navigationController pushViewController:civc animated:YES];
    }
    
    if (sender.tag == 11) {
        ProductInfoViewController *pivc = [[ProductInfoViewController alloc] init];
        [self.navigationController pushViewController:pivc animated:YES];
    }
    
    if (sender.tag == 12) {
//        VersionInfoViewController *vivc = [[VersionInfoViewController alloc] init];
//        [self.navigationController pushViewController:vivc animated:YES];
        [self showToastViewWithTitle:NSLocalizedString(@"New Version", @"New Version")];
    }
    
    if (sender.tag == 13) {
        UpdateInfoViewController *uivc = [[UpdateInfoViewController alloc] init];
        [self.navigationController pushViewController:uivc animated:YES];
    }
    
    if (sender.tag == 14) {
        [self showChangeServerView];
    }
    
    if (sender.tag == 15) {
        //取消修改服务器地址
        [self hideChangeServerView];
    }
    
    if (sender.tag == 16) {
        //确认修改服务器地址
        [[UserInfo defaultUserInfo] setServer:_textfield.text];
        [self showToastViewWithTitle:NSLocalizedString(@"Successfully modified", @"Successfully modified")];
        [self hideChangeServerView];
    }
}

- (void)showChangeServerView{
    UIView *alertView = [[UIView alloc] initWithFrame:self.view.bounds];
    alertView.backgroundColor = COLOR(45, 45, 45, 0.5);
    alertView.tag = 1001;
    [self.view addSubview:alertView];
    
    UIImageView *alertImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25*NOW_SIZE, 185*NOW_SIZE, SCREEN_Width - 50*NOW_SIZE, 150*NOW_SIZE)];
    alertImageView.image = IMAGE(@"bg_alert(1).png");
    alertImageView.userInteractionEnabled = YES;
    alertImageView.tag = 1002;
    [self.view addSubview:alertImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*NOW_SIZE, CGRectGetWidth(alertImageView.frame), 30*NOW_SIZE)];
    titleLabel.text = root_Please_enter_the_server_address;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [alertImageView addSubview:titleLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20*NOW_SIZE, 150*NOW_SIZE - 35*NOW_SIZE, 65*NOW_SIZE, 23*NOW_SIZE);
    [cancelButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [cancelButton setTitle:root_Cancel forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 15;
    [alertImageView addSubview:cancelButton];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(SCREEN_Width - 135*NOW_SIZE, 150*NOW_SIZE - 35*NOW_SIZE, 65*NOW_SIZE, 23*NOW_SIZE);
    [confirmButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [confirmButton setTitle:root_Yes forState:UIControlStateNormal];
    [confirmButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.tag = 16;
    [alertImageView addSubview:confirmButton];
    
    _textfield = [[UITextField alloc] initWithFrame:CGRectMake(15*NOW_SIZE, 60*NOW_SIZE, 243*NOW_SIZE, 30*NOW_SIZE)];
    _textfield.textColor = [UIColor whiteColor];
    _textfield.font = [UIFont systemFontOfSize:14];
    _textfield.keyboardType = UIKeyboardTypeASCIICapable;
    _textfield.tintColor = [UIColor whiteColor];
    _textfield.text=@"http://server.growatt.com";
    [_textfield setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [alertImageView addSubview:_textfield];
    
}

- (void)hideChangeServerView {
    [UIView animateWithDuration:0.5 animations:^{
        [[self.view viewWithTag:1001] removeFromSuperview];
        [[self.view viewWithTag:1002] removeFromSuperview];
    }];
}

@end

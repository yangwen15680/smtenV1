//
//  CompanyViewController.m
//  ShinePhone
//
//  Created by 潘佳文 on 15/8/12.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "CompanyViewController.h"

@interface CompanyViewController ()

@end

@implementation CompanyViewController

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
    self.title = root_Company_Information;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60*NOW_SIZE, 100*NOW_SIZE, SCREEN_Width - 120*NOW_SIZE, 50*NOW_SIZE)];
    logoImageView.image = IMAGE(@"icon_logo.png");
    [self.view addSubview:logoImageView];
    
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180*NOW_SIZE, SCREEN_Width, 20*NOW_SIZE)];
    logoLabel.text = ABOUT_LOGO_TITLE;
    logoLabel.textColor = [UIColor whiteColor];
    logoLabel.font = [UIFont systemFontOfSize:25*NOW_SIZE];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:logoLabel];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 215*NOW_SIZE, SCREEN_Width, 10*NOW_SIZE)];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // 当前应用版本号码
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    versionLabel.text = [NSString stringWithFormat:@"v%@.%@", appCurVersion, appCurVersionNum];
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.font = [UIFont systemFontOfSize:14*NOW_SIZE];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 245*NOW_SIZE, SCREEN_Width, 0.5)];
    lineView.backgroundColor = COLOR(143, 219, 213, 1);
    [self.view addSubview:lineView];
    
    
    /////////详细内容
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15*NOW_SIZE, 300*NOW_SIZE, 80*NOW_SIZE, 15*NOW_SIZE)];
    name.text = root_Name;
    name.textColor = [UIColor whiteColor];
    name.font = [UIFont systemFontOfSize:13*NOW_SIZE];
    [self.view addSubview:name];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(95*NOW_SIZE, 300*NOW_SIZE, SCREEN_Width - 100*NOW_SIZE, 15*NOW_SIZE)];
    nameLabel.text = COMPANY_NAME_INFO;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:13*NOW_SIZE];
    nameLabel.numberOfLines = 0;
    [nameLabel sizeToFit];
    [self.view addSubview:nameLabel];
    
    //
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(15*NOW_SIZE, CGRectGetMaxY(nameLabel.frame)+5*NOW_SIZE, 80*NOW_SIZE, 15*NOW_SIZE)];
    address.text = root_Address;
    address.textColor = [UIColor whiteColor];
    address.font = [UIFont systemFontOfSize:13*NOW_SIZE];
    [self.view addSubview:address];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(95*NOW_SIZE, CGRectGetMaxY(nameLabel.frame)+5*NOW_SIZE, SCREEN_Width - 100*NOW_SIZE, 15*NOW_SIZE)];
    addressLabel.text = COMPANY_ADRESS_INFO;
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.font = [UIFont systemFontOfSize:13*NOW_SIZE];
    addressLabel.numberOfLines = 0;
    [addressLabel sizeToFit];
    [self.view addSubview:addressLabel];
    
    //
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(15*NOW_SIZE, CGRectGetMaxY(addressLabel.frame)+5*NOW_SIZE, 80*NOW_SIZE, 15*NOW_SIZE)];
    phone.text = root_Tel_Phone;
    phone.textColor = [UIColor whiteColor];
    phone.font = [UIFont systemFontOfSize:13*NOW_SIZE];
    [self.view addSubview:phone];
    
    UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(95*NOW_SIZE, CGRectGetMaxY(addressLabel.frame)+5*NOW_SIZE, SCREEN_Width - 100*NOW_SIZE, 15*NOW_SIZE)];
    phoneNumLabel.text = COMPANY_PHONE_NUMBER;
    phoneNumLabel.textColor = [UIColor whiteColor];
    phoneNumLabel.font = [UIFont systemFontOfSize:13*NOW_SIZE];
    phoneNumLabel.numberOfLines = 0;
    [phoneNumLabel sizeToFit];
    [self.view addSubview:phoneNumLabel];
    
    //
    UILabel *email = [[UILabel alloc] initWithFrame:CGRectMake(15*NOW_SIZE, CGRectGetMaxY(phoneNumLabel.frame)+5*NOW_SIZE, 80*NOW_SIZE, 15*NOW_SIZE)];
    email.text = root_E_Mail;
    email.textColor = [UIColor whiteColor];
    email.font = [UIFont systemFontOfSize:13*NOW_SIZE];
    [self.view addSubview:email];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(95*NOW_SIZE, CGRectGetMaxY(phoneNumLabel.frame)+5*NOW_SIZE, SCREEN_Width - 100*NOW_SIZE, 15*NOW_SIZE)];
    emailLabel.text = COMPANY_EMAIL_ADDRESS;
    emailLabel.textColor = [UIColor whiteColor];
    emailLabel.font = [UIFont systemFontOfSize:13*NOW_SIZE];
    emailLabel.numberOfLines = 0;
    [emailLabel sizeToFit];
    [self.view addSubview:emailLabel];
    
    //
    UILabel *url = [[UILabel alloc] initWithFrame:CGRectMake(15*NOW_SIZE, CGRectGetMaxY(emailLabel.frame)+5*NOW_SIZE, 80*NOW_SIZE, 15*NOW_SIZE)];
    url.text = root_Site;
    url.textColor = [UIColor whiteColor];
    url.font = [UIFont systemFontOfSize:13*NOW_SIZE];
    [self.view addSubview:url];

    UILabel *urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(95*NOW_SIZE, CGRectGetMaxY(emailLabel.frame)+5*NOW_SIZE, SCREEN_Width - 100*NOW_SIZE, 15*NOW_SIZE)];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:COMPANY_URL];
    NSRange contentRange = {5,[content length] - 5};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    urlLabel.attributedText = content;
    urlLabel.textColor = [UIColor whiteColor];
    urlLabel.font = [UIFont systemFontOfSize:13*NOW_SIZE];
    urlLabel.numberOfLines = 0;
    [urlLabel sizeToFit];
    [self.view addSubview:urlLabel];
    
    
    UILabel *urlLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(95*NOW_SIZE, CGRectGetMaxY(urlLabel.frame)+5*NOW_SIZE, SCREEN_Width - 100*NOW_SIZE, 15*NOW_SIZE)];
    NSMutableAttributedString *content2 = [[NSMutableAttributedString alloc] initWithString:COMPANY_URL_EX];
    NSRange contentRange2 = {0,[content2 length]};
    [content2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange2];
    urlLabel2.attributedText = content2;
    urlLabel2.textColor = [UIColor whiteColor];
    urlLabel2.font = [UIFont systemFontOfSize:13*NOW_SIZE];
    urlLabel2.numberOfLines = 0;
    [urlLabel2 sizeToFit];
    [self.view addSubview:urlLabel2];
    
    
    
}

@end

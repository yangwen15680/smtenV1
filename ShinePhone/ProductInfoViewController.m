//
//  ProductInfoViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/19.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "ProductInfoViewController.h"

@interface ProductInfoViewController ()

@end

@implementation ProductInfoViewController

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
    self.title = root_Product_Information;
    
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
    
    //////////
    UILabel *product = [[UILabel alloc] initWithFrame:CGRectMake(15*NOW_SIZE, 310*NOW_SIZE, 100*NOW_SIZE, 15*NOW_SIZE)];
    product.text = root_Product_Name;
    product.textColor = [UIColor whiteColor];
    product.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [self.view addSubview:product];
    
    UILabel *productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(115*NOW_SIZE, 310*NOW_SIZE, SCREEN_Width - 120*NOW_SIZE, 15*NOW_SIZE)];
    productNameLabel.text = COMPANY_PRODUCT_NAME;
    productNameLabel.textColor = [UIColor whiteColor];
    productNameLabel.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [productNameLabel setNumberOfLines:0];
    [productNameLabel sizeToFit];
    [self.view addSubview:productNameLabel];
    
    //
    UILabel *productVersion = [[UILabel alloc] initWithFrame:CGRectMake(15*NOW_SIZE, CGRectGetMaxY(productNameLabel.frame)+5*NOW_SIZE, 100*NOW_SIZE, 15*NOW_SIZE)];
    productVersion.text = root_Current_Version;
    productVersion.textColor = [UIColor whiteColor];
    productVersion.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [self.view addSubview:productVersion];
    
    UILabel *productVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(115*NOW_SIZE, CGRectGetMaxY(productNameLabel.frame)+5*NOW_SIZE, SCREEN_Width - 120*NOW_SIZE, 15*NOW_SIZE)];
    productVersionLabel.text = COMPANY_CURRENT_VERSION;
    productVersionLabel.textColor = [UIColor whiteColor];
    productVersionLabel.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [productVersionLabel setNumberOfLines:0];
    [productVersionLabel sizeToFit];
    [self.view addSubview:productVersionLabel];
    
    //
    UILabel *publishCompany = [[UILabel alloc] initWithFrame:CGRectMake(15*NOW_SIZE, CGRectGetMaxY(productVersionLabel.frame)+5*NOW_SIZE, 100*NOW_SIZE, 15*NOW_SIZE)];
    publishCompany.text = root_Manufacturer;
    publishCompany.textColor = [UIColor whiteColor];
    publishCompany.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [self.view addSubview:publishCompany];
    
    UILabel *publishCompanyLabel = [[UILabel alloc] initWithFrame:CGRectMake(115*NOW_SIZE, CGRectGetMaxY(productVersionLabel.frame)+5*NOW_SIZE, SCREEN_Width - 120*NOW_SIZE, 15*NOW_SIZE)];
    publishCompanyLabel.text = COMPANY_PUBLISH_COMPANY;
    publishCompanyLabel.textColor = [UIColor whiteColor];
    publishCompanyLabel.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [publishCompanyLabel setNumberOfLines:0];
    [publishCompanyLabel sizeToFit];
    [self.view addSubview:publishCompanyLabel];
    
    //
    UILabel *copyright = [[UILabel alloc] initWithFrame:CGRectMake(15*NOW_SIZE, CGRectGetMaxY(publishCompanyLabel.frame)+5*NOW_SIZE, 100*NOW_SIZE, 15*NOW_SIZE)];
    copyright.text = root_Copyright_Notice;
    copyright.textColor = [UIColor whiteColor];
    copyright.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [self.view addSubview:copyright];
    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(115*NOW_SIZE, CGRectGetMaxY(publishCompanyLabel.frame)+5*NOW_SIZE, SCREEN_Width - 120*NOW_SIZE, 15*NOW_SIZE)];
    copyrightLabel.text = COMPANY_COPYRIGHT;
    copyrightLabel.textColor = [UIColor whiteColor];
    copyrightLabel.font = [UIFont systemFontOfSize:12*NOW_SIZE];
    [self.view addSubview:copyrightLabel];
}

@end

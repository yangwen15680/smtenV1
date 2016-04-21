//
//  UserInfo.h
//  ShinePhone
//
//  Created by LinKai on 15/5/19.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

+ (UserInfo *)defaultUserInfo;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isAutoLogin;
@property (nonatomic, assign) BOOL isRememberPwd;
@property (nonatomic, strong) NSString *server;
@property(weak ,nonatomic)NSTimer *R_timer;

@end

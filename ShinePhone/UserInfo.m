//
//  UserInfo.m
//  ShinePhone
//
//  Created by LinKai on 15/5/19.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *userInfo = nil;
static int timerNumber=0;

@implementation UserInfo

+ (UserInfo *)defaultUserInfo {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[UserInfo alloc]init];
    });
    return userInfo;
}

- (instancetype)init {
    if (self = [super init]) {
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if (![ud objectForKey:@"isAutoLogin"]) {
            [ud setBool:NO forKey:@"isAutoLogin"];
            _isAutoLogin = NO;
        } else {
            _isAutoLogin = [ud boolForKey:@"isAutoLogin"];
        }
        
        if (![ud objectForKey:@"isRememberPwd"]) {
            [ud setBool:NO forKey:@"isRememberPwd"];
            _isRememberPwd = NO;
        } else {
            _isRememberPwd = [ud boolForKey:@"isRememberPwd"];
        }
        
        if (![ud objectForKey:@"userName"]) {
            [ud setObject:@"" forKey:@"userName"];
            _userName = @"";
        } else {
            _userName = [ud objectForKey:@"userName"];
        }
        
        if (![ud objectForKey:@"userPassword"]) {
            [ud setObject:@"" forKey:@"userPassword"];
            _userPassword = @"";
        } else {
            _userPassword = [ud objectForKey:@"userPassword"];
        }
        
        if (![ud objectForKey:@"userId"]) {
            [ud setObject:@"" forKey:@"userId"];
            _userId = @"";
        } else {
            _userId = [ud objectForKey:@"userId"];
        }
        
        if (![ud objectForKey:@"server"]) {
            [ud setObject:@"http://server.growatt.com" forKey:@"server"];
            _server = @"http://server.growatt.com";
        } else {
            _server = [ud objectForKey:@"server"];
        }
        
        [ud synchronize];
    
    }
    return self;
}

- (void)setIsRememberPwd:(BOOL)isRememberPwd {
    _isRememberPwd = isRememberPwd;
    
    [[NSUserDefaults standardUserDefaults] setBool:_isRememberPwd forKey:@"isRememberPwd"];
}

- (void)setIsAutoLogin:(BOOL)isAutoLogin {
    _isAutoLogin = isAutoLogin;
    
    [[NSUserDefaults standardUserDefaults] setBool:_isAutoLogin forKey:@"isAutoLogin"];
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    
    [[NSUserDefaults standardUserDefaults] setObject:_userId forKey:@"userId"];
}

- (void)setUserPassword:(NSString *)userPassword {
    _userPassword = userPassword;
    
    [[NSUserDefaults standardUserDefaults] setObject:_userPassword forKey:@"userPassword"];
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    
    [[NSUserDefaults standardUserDefaults] setObject:_userName forKey:@"userName"];
}

- (void)setServer:(NSString *)server{
    _server = server;
    
    [[NSUserDefaults standardUserDefaults] setObject:_server forKey:@"server"];
}

#pragma mark - Tool Method

-(NSTimer *)R_timer{
    timerNumber=0;
    if (!_R_timer) {
        _R_timer=[NSTimer scheduledTimerWithTimeInterval:3540 target:self selector:@selector(stopDownload) userInfo:nil repeats:true];
    }
    return _R_timer;
}

-(void)stopDownload{
    if (timerNumber==1) {
        NSLog(@"test1111");
        self.R_timer.fireDate=[NSDate distantFuture];
        [[UserInfo defaultUserInfo] setIsAutoLogin:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:nil];
    }
    timerNumber=timerNumber+1;
}


@end

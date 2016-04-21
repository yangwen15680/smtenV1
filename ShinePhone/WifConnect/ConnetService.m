//
//  ConnetService.m
//  WifiConnect
//
//  Created by 黄煜楠 on 15/2/8.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "ConnetService.h"
#import "AppMacro.h"
#import "JDStatusBarNotification.h"

@implementation ConnetService

+(ConnetService *)shareConnetService{
    static ConnetService *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ConnetService alloc] init];
    });
    return _sharedInstance;
}

-(void)reciveData:(NSData *)data infoSend:(InfoSend *)info{
    NSString *receiveString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    BOOL isOk = [receiveString rangeOfString:CMD_ENTER_CMD].location != NSNotFound;
    
    switch (_type) {
        case k_connect_module:
            break;
        case k_connect_wsss:{
            if ([receiveString rangeOfString:RESPONSE_SCAN_MODULE].location != NSNotFound && _state == k_begin_setup) {
                [JDStatusBarNotification dismiss];
                [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleGray];
                [self query];
            }else if (isOk && _state == k_query_send) {
                [self queryWann];
            }else if (isOk && _state == k_query_wann_send) {
                [self setWsssid:info.wsssid];
            }else if (_state == k_set_wsssid_send) {
                if (isOk) {
                    [self setWskey:info.wskey];
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetSSIDSuccess",nil) dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
                }else{
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetSSIDFail",nil) dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
                }
            }else if (_state == k_set_wskey_send) {
                if (isOk) {
                    [self getModuleInfo];
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetPwdSuccess",nil) dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
                }else{
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetPwdFail",nil) dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
                }
            }else if (_state == k_query_module_send) {
                if (isOk) {
                    [self paseModuleInfo:receiveString];
                    [self reset];
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"queryCollectorOK",nil) dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
                }else{
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"queryCollectorFailed",nil) dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
                }
            }else if (_state == k_reset_send) {
                if (isOk) {
                    [self exit];
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_Success",nil) dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
                }else{
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetPwdFail",nil) dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
                }
            }
        }
            break;
        case k_reset_passwork:{
            if ([receiveString rangeOfString:RESPONSE_SCAN_MODULE].location != NSNotFound && _state == k_begin_setup) {
                [JDStatusBarNotification dismiss];
                [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleGray];
                [self query];
            }else if (isOk && _state == k_query_send) {
                [self queryWann];
            }else if (isOk && _state == k_query_wann_send) {
                [self setWsssid:info.wsssid];
            }else if (_state == k_set_wsssid_send) {
                if (isOk) {
                    [self setWskey:info.wskey];
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetSSIDSuccess",nil) dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
                }else{
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetSSIDFail",nil) dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
                }
            }else if (_state == k_set_wskey_send) {
                if (isOk) {
                    [self setWakey:info.wakey];
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetPwdSuccess",nil) dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
                }else{
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetPwdFail",nil) dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
                }
            }else if (_state == k_set_wakey_send) {
                if (isOk) {
                    [self getModuleInfo];
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetWifiPwdSuccess",nil) dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
                }else{
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_WifiFail",nil) dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
                }
            }else if (_state == k_query_module_send) {
                if (isOk) {
                    [self paseModuleInfo:receiveString];
                    [self reset];
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"queryCollectorOK",nil) dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
                }else{
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"queryCollectorFailed",nil) dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
                }
            }else if (_state == k_reset_send) {
                if (isOk) {
                    [self exit];
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_Success",nil) dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
                }else{
                    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetPwdFail",nil) dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
                }

            }
        }
            break;
        default:
            break;
    }
}

-(void)beginSetup{
    [_udpSocket sendData:[CMD_SCAN_MODULE dataUsingEncoding:NSUTF8StringEncoding] toHost:HOST port:PORT withTimeout:-1 tag:1];
    _state = k_begin_setup;
    
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_FirstSeting", nil) styleName:JDStatusBarStyleDefault];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    
    NSLog(@"send data:%@",CMD_SCAN_MODULE);
    NSLog(@"state:k_begin_setup");
}

-(void)query{
    [_udpSocket sendData:[CMD_ENTER_CMD dataUsingEncoding:NSUTF8StringEncoding] toHost:HOST port:PORT withTimeout:-1 tag:1];
    [_udpSocket sendData:[CMD_QUERY_WSSSID dataUsingEncoding:NSUTF8StringEncoding] toHost:HOST port:PORT withTimeout:-1 tag:1];
    _state = k_query_send;
    
    NSLog(@"send data:%@",CMD_ENTER_CMD);
    NSLog(@"send data:%@",CMD_QUERY_WSSSID);
    NSLog(@"state:k_query_send");
}

-(void)queryWann{
    [_udpSocket sendData:[CMD_QUERY_WANN dataUsingEncoding:NSUTF8StringEncoding] toHost:HOST port:PORT withTimeout:-1 tag:1];
    _state = k_query_wann_send;
    
    NSLog(@"send data:%@",CMD_QUERY_WANN);
    NSLog(@"state:k_query_wann_send");
}

-(void)setWsssid:(NSString *)id{
    NSString *sendString = [NSString stringWithFormat:CMD_SET_WSSSID,id];
    [_udpSocket sendData:[sendString dataUsingEncoding:NSUTF8StringEncoding] toHost:HOST port:PORT withTimeout:-1 tag:1];
    _state = k_set_wsssid_send;
    
    NSLog(@"send data:%@",sendString);
    NSLog(@"state:k_set_wsssid_send");
}
-(void)setWskey:(NSString *)key{
    NSString *sendString = [NSString stringWithFormat:CMD_SET_WSKEY,key];
    [_udpSocket sendData:[sendString dataUsingEncoding:NSUTF8StringEncoding] toHost:HOST port:PORT withTimeout:-1 tag:1];
    _state = k_set_wskey_send;
    
    NSLog(@"send data:%@",sendString);
    NSLog(@"state:k_set_wskey_send");
}

-(void)setWakey:(NSString *)key{
    NSString *sendString = [NSString stringWithFormat:CMD_SET_WAKEY,key];
    [_udpSocket sendData:[sendString dataUsingEncoding:NSUTF8StringEncoding] toHost:HOST port:PORT withTimeout:-1 tag:1];
    _state = k_set_wakey_send;
    
    NSLog(@"send data:%@",sendString);
    NSLog(@"state:k_set_wakey_send");
}

-(void)getModuleInfo{
    [_udpSocket sendData:[CMD_QUERY_MODULE dataUsingEncoding:NSUTF8StringEncoding] toHost:HOST port:PORT withTimeout:-1 tag:1];
    _state = k_query_module_send;
    
    NSLog(@"send data:%@",CMD_QUERY_MODULE);
    NSLog(@"state:k_query_module_send");
}

-(void)reset{
    [_udpSocket sendData:[CMD_RESET_MODULE dataUsingEncoding:NSUTF8StringEncoding] toHost:HOST port:PORT withTimeout:-1 tag:1];
    _state = k_reset_send;
    
    NSLog(@"send data:%@",CMD_RESET_MODULE);
    NSLog(@"state:k_query_module_send");
}

-(void)exit{
    [_udpSocket sendData:[CMD_EXIT_CMD dataUsingEncoding:NSUTF8StringEncoding] toHost:HOST port:PORT withTimeout:-1 tag:1];
    _state = k_exit_send;
    
    NSLog(@"send data:%@",CMD_EXIT_CMD);
    NSLog(@"state:k_exit_send");
}

-(void)paseModuleInfo:(NSString *)reciveString{
    if (reciveString.length > 0) {
        NSArray *array = [reciveString componentsSeparatedByString:@","];
        if ([array count] > 2) {
            NSString * name = array[1];
            if (name.length > 0) {
                ModuleInfo *moduleInfo = [[ModuleInfo alloc] init];
                moduleInfo.name = name;
                NSString *checkCode = [self validateWebbox:name];
                if (checkCode.length > 0) {
                    moduleInfo.checkCode = checkCode;
                }
                [self.delegate updateModuleInfo:moduleInfo];
            }
        }
    }
}

-(NSString *)validateWebbox:(NSString *)serialNum{
    if (serialNum.length == 0){
        return @"";
    }
    NSData* snData = [serialNum dataUsingEncoding:NSUTF8StringEncoding];
    Byte * snBytes = (Byte *)[snData bytes];
    int sum = 0;
    for (int i = 0; i<[snData length]; i++) {
        sum += snBytes[i];
    }
    int B = sum % 8;
    NSString *text = [self ToHex:sum*sum];
    NSString *resultTemp = [NSString stringWithFormat:@"%@%@%d",[text substringToIndex:2],[text substringFromIndex:text.length-2],B];
    NSMutableString *result = [[NSMutableString alloc] init];
    const char *charArray = [resultTemp UTF8String];
    for (int i = 0; i < resultTemp.length; i++) {
        char c = charArray[i];
        if (c == 0x30 || c == 0x4F || c == 0x6F) {
            c++;
        }
        [result appendFormat:@"%c",c];
    }
    return result;
}

-(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}



@end

//
//  AppMacro.h
//  WifiConnect
//
//  Created by 黄煜楠 on 15/2/7.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HOST @"192.168.10.100"
#define PORT  48899

#define PEER_ADDRESS @"192.168.10.100"
#define CMD_SCAN_MODULE @"HF-A11ASSISTHREAD"
#define CMD_ENTER_CMD @"+ok"
#define CMD_EXIT_CMD @"AT+Q\r"
#define CMD_QUERY_WSSSID @"AT+WSSSID\r"
#define CMD_QUERY_WANN @"AT+WANN\r"
#define CMD_SET_WSSSID @"AT+WSSSID=%@\r"
#define CMD_SET_WSKEY @"AT+WSKEY=%@\r"
#define CMD_SET_WAKEY @"AT+WAKEY=%@\r"
//CMD_RELOAD_MODULE @"AT+RELD\r"
#define CMD_RESET_MODULE @"AT+Z\r"
#define CMD_QUERY_MODULE @"AT+WAP\r"

#define RESPONSE_SCAN_MODULE @"192.168.10.100"
#define RESPONSE_SET_OK @"+ok"
#define RESPONSE_QUERY_OK @"+ok="
#define RESPONSE_SET_ERR @"+ERR"

#define IS_OS_7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface AppMacro : NSObject

@end

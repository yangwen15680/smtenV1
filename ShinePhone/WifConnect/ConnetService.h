//
//  ConnetService.h
//  WifiConnect
//
//  Created by 黄煜楠 on 15/2/8.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "InfoSend.h"
#import "ModuleInfo.h"

typedef enum : NSUInteger {
    k_no_setup,
    k_begin_setup,
    k_query_send,
    k_query_wann_send,
    k_set_wsssid_send,
    k_set_wskey_send,
    k_set_wakey_send,
    k_query_module_send,
    k_reset_send,
    k_exit_send
} ConnectState;

typedef enum : NSUInteger {
    k_connect_module,
    k_connect_wsss,
    k_reset_passwork
} OperationType;

@protocol ConnetServiceDelegate <NSObject>

@optional
-(void) updateModuleInfo:(ModuleInfo *)moduleInfo;

@end

@interface ConnetService : NSObject

@property(nonatomic,assign) ConnectState state;
@property(nonatomic,retain) GCDAsyncUdpSocket *udpSocket;
@property(nonatomic,assign) OperationType type;
@property(nonatomic,assign) id<ConnetServiceDelegate> delegate;

+(ConnetService *)shareConnetService;

-(void)reciveData:(NSData *)data infoSend:(InfoSend *)info;

-(void)beginSetup;
-(void)query;
-(void)queryWann;
-(void)setWsssid:(NSString*)id;
-(void)setWskey:(NSString *)key;
-(void)setWakleiey:(NSString *)key;
-(void)getModuleInfo;
-(void)reset;
-(void)exit;

-(NSString *)validateWebbox:(NSString *)serialNum;

@end

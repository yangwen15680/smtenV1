//
//  BaseRequest.h
//  ShinePhone
//
//  Created by LinKai on 15/5/19.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^successBlock) (id content);

@interface BaseRequest : NSObject

+ (void)requestWithMethod:(NSString *)method
                 paramars:(NSDictionary *)paramars
             paramarsSite:(NSString *)site
              sucessBlock:(successBlock)successBlock
                  failure:(void (^)(NSError * error))failure;

+ (void)requestWithMethodResponseStringResult:(NSString *)method
                 paramars:(NSDictionary *)paramars
             paramarsSite:(NSString *)site
              sucessBlock:(successBlock)successBlock
                  failure:(void (^)(NSError * error))failure;

+ (void)requestWithMethodByGet:(NSString *)method
                 paramars:(NSDictionary *)paramars
             paramarsSite:(NSString *)site
              sucessBlock:(successBlock)successBlock
                  failure:(void (^)(NSError * error))failure;

+ (void)requestWithMethodResponseJsonByGet:(NSString *)method
                      paramars:(NSDictionary *)paramars
                  paramarsSite:(NSString *)site
                   sucessBlock:(successBlock)successBlock
                       failure:(void (^)(NSError * error))failure;

+ (void)requestImageWithMethodByGet:(NSString *)method
                      paramars:(NSDictionary *)paramars
                  paramarsSite:(NSString *)site
                   sucessBlock:(successBlock)successBlock
                       failure:(void (^)(NSError * error))failure;

+ (void)requestWithMethod:(NSString *)method
                 paramars:(NSDictionary *)paramars
             paramarsSite:(NSString *)site
                dataImage:(NSData *)data
              sucessBlock:(successBlock)successBlock
                  failure:(void (^)(NSError * error))failure;

+ (void)uplodImageWithMethod:(NSString *)method
                 paramars:(NSDictionary *)paramars
             paramarsSite:(NSString *)site
                dataImageDict:(NSMutableDictionary *)dataDict
              sucessBlock:(successBlock)successBlock
                  failure:(void (^)(NSError * error))failure;


@end

//
//  WKQuickLogin.h
//  QuickLogin
//
//  Created by bitlib on 2020/10/1.
//

#import <Foundation/Foundation.h>

typedef void (^BitlibLoginResultListener)(NSDictionary * _Nonnull data);

typedef NS_ENUM(NSUInteger, OperatorType) {
    OperatorTypeUnknow = 0, //未知
    OperatorTypeCMCC   = 1, //移动
    OperatorTypeCTCC   = 2, //电信
    OperatorTypeCUCC   = 3  //联通
};

@interface WKQuickLogin : NSObject

+(WKQuickLogin *_Nonnull) getInstance;

/**
 SDK初始化，只需执行一次初始化
 @param appKey 平台分配的appKey
 */
- (void)initWithKey:(NSString *_Nullable)appKey  complete:(void (^_Nullable)(NSDictionary * _Nonnull resultDic))complete;

/**
 预授权获取token
 @param timeout 超时时间
 @param listener 回调监听
 */
- (void)getAccessCode:(double)timeout listener:(BitlibLoginResultListener _Nonnull) listener;

@end

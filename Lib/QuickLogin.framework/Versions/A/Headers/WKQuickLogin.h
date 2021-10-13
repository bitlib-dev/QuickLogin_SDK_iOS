//
//  WKQuickLogin.h
//  QuickLogin
//
//  Created by bitlib on 2020/10/1.
//

#import <Foundation/Foundation.h>

typedef void (^LoginResultListener)(NSDictionary * _Nonnull data);

typedef NS_ENUM(NSUInteger, OperatorType) {
    OperatorTypeUnknow = 0, //未知
    OperatorTypeCMCC   = 1, //移动
    OperatorTypeCTCC   = 2, //电信
    OperatorTypeCUCC   = 3  //联通
};

@interface WKQuickLogin : NSObject

/// 单例
+ (WKQuickLogin *_Nonnull) getInstance;


/// 初始化SDK
/// @param appKey 平台分配的appKey
/// @param complete 回调监听
- (void)initWithKey:(NSString *_Nullable)appKey  complete:(void (^_Nullable)(NSDictionary * _Nonnull resultDic))complete;


/// 设置重试次数（默认3次）
/// @param retryCount 重试次数
-(void)setRetryCount:(NSInteger)retryCount;


/// 预授权获取token
/// @param timeout 超时时间
/// @param listener 回调监听
- (void)getAccessCode:(double)timeout listener:(LoginResultListener _Nonnull) listener;


@end

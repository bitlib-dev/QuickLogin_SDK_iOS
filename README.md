# iOS SDK对接文档（ App一键登录）

### 1.导入SDK

*可以直接导入下载的SDK或通过Cocoapods安装SDK*

#### 1.1 手动导入

> 1.直接导入QuickLogin_iOS.framework（注意勾选Copy items if needed）

> 2.在Other Linker Flags中 添加-ObjC：xcode-&BuildSetting-&Other Linker Flags 添加 -ObjC 和 -all_load
![](https://webdid-1304666826.cos.ap-beijing.myqcloud.com/doc/img/otherLinkerFlags.png)

> 3.添加libc++.1.tbd: 在xcode-&General-&Linked Frameworks and Libraries中点击 + ，搜索并选择添加SystemConfiguration.framework 
![](https://webdid-1304666826.cos.ap-beijing.myqcloud.com/doc/img/framework.png)



#### 1.2 通过Cocoapods导入SDK
通过[CocoaPods](https://cocoapods.org)获取。安装它，编辑Podfile文件并添加以下代码

```ruby
pod 'QuickLogin'
```


`> 执行 pod install`

`> 从现在开始使用 .xcworkspace 打开项目，而不是 .xcodeproj`


### 2.初始化SDK
**接口**

```java
/**
  * SDK初始化，只需执行一次初始化
  * @param key 平台分配的appKey
  * @param complete 初始化结果回调
  */
- (void)initWithKey:(NSString *_Nullable)appKey  complete:(void (^_Nullable)(NSDictionary * _Nonnull resultDic))complete;

```

[获取appkey](https://www.bitlib.cc/)

**参数说明**

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| key | String | 分配的Key |

**示例**

```java
#import <QuickLogin/WKQuickLogin.h>

...

[[WKQuickLogin getInstance] initWithKey:@"分配的Key" complete:^(NSDictionary * _Nonnull resultDic) {

//初始化回调结果

}];

```

### 3.获取token

**接口**

```java
/**
 * 预授权获取accessCode
 * @param timeout 超时时间
 * @param type 运营商类型
 * @param listener 回调监听
 */
 
- (void)getTokenWithTimeout:(double)timeout listener:(WKResultListener _Nonnull) listener;


```
**参数说明**

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| timeout | double | 请求超时时间 |
| listener | WKResultListener | 请求运营商结果回调 |



**示例**

```

#import <QuickLogin/WKQuickLogin.h>

...

[[WKQuickLogin getInstance] getAccessCode:999 listener:^(NSDictionary * _Nonnull data) {

/**
      * 成功时回调
      *
      * @param resultCode   0：成功，其他状态码为失败
      * @param msg          成功信息
      * @param operatorType 运营商类型，CM：中国移动 CU：中国联通  CT:中国电信
      * @param accessCode      成功时返回，用于置换手机号的accessCode
      * @param traceID         成功时返回，追踪ID
      */
      
       /**
      * 失败时回调
      *
      * @param resultCode  xx：非0状态码为失败
      * @param msg         失败原因
      */

            
}];

```

**参数说明**

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| resultCode | int | token获取成功时回调，0：成功，其他状态码为失败 |
| msg | String | 回调信息 |
| mobile | String | 成功时返回，脱敏手机号 ,示例：188****8888 |
| operatorType | String | 成功时返回，运营商类型，CM：中国移动 CU：中国联通 CT：中国电信|
| accessCode | String | 成功时返回，置换token|
| traceID | String | 成功时返回，追踪ID|







# iOS

## 接入指南
**SDK支持版本：iOS 8.0及以上**

> 本文档为一键登录SDK开发文档注意事项：

1.一键登录服务必须打开蜂窝数据流量并且手机操作系统给予应用蜂窝数据权限才能使用。
    
2.取号请求过程需要消耗用户少量数据流量（国外漫游时可能会产生额外的费用）。
    
3.一键登录服务目前支持2G/3G/4G/5G（2G、3G因为无线网络环境问题，时延和成功率会比4G/5G低）

4.关于双卡的适配问题：

* a.当两张卡的运营商不一致时，SDK会获取设备上网卡的运营商并进行取号，但上网卡不一定会获取成功（飞行模式状态时），若获取失败，SDK将默认依次请求中国移动SDK，中国联通SDK，中国电信SDK。

* b.当SDK存在缓存并且两张卡的运营商不相同时，SDK会重新获取上网卡运营商与上一次取号的运营商进行对比，若两次运营商不一致，则以最新设置的上网卡的运营商为准，重新取号，上次获取的缓存将自动失效。

* c.iOS 13上已完成双卡适配，SDK通过苹果提供的方法获取运营商，若获取失败，SDK将默认依次请求中国移动SDK，中国联通SDK，中国电信SDK。

## 开发流程

### 1.导入SDK
#### 1.1 手动导入SDK
可以直接导入[下载](https://github.com/bitlib-dev/QuickLogin_SDK_iOS)的SDK或通过Cocoapods安装SDK


> 在xcode - General - Linked Frameworks and Libraries中点击 + ，搜索并选择添加SystemConfiguration.framewor / libc++.tbd / libz.1.2.8tbd


![](<https://static.bitlib.cc/doc/img/quicklogin-iOS-03.png>)

#### 1.2 通过Cocoapods导入SDK

通过[CocoaPods](https://cocoapods.org)获取。安装它，编辑Podfile文件并添加以下代码

```ruby
pod 'QuickLogin'
```

`> 执行 pod install`

`> 从现在开始使用 .xcworkspace 打开项目，而不是 .xcodeproj`
### 2.搭建开发环境

>xcode版本需使用9.0以上，否则会报错

> 1.直接导入QuickLogin_iOS.framework /EAccountApiSDK.framework /TYRZUISDK.framework（注意勾选Copy items if needed）

![](<https://static.bitlib.cc/doc/img/quicklogin-iOS-01.png>)

> 在Xcode中找到TARGETS-->Build Setting-->Linking-->Other Linker Flags在这选项中需要添加 -ObjC。
     注意:如果以上操作仍然出现unrecognized selector sent to instance找不到方法的报错,则添加更改为_all_load。

![](<https://static.bitlib.cc/doc/img/quicklogin-iOS-02.png>)

> 资源文件:在Xcode中务必导入WKResource.bundle到项目中，否则授权界面显示异常（不显示默认图片）

> TARGETS-->Build Phases-->Copy Bundle Resources-> 点击 "+" --> Add Other --> TYRUIZSDK.framework--> TYRZResource.bundle -->Open。


![](<https://static.bitlib.cc/doc/img/quicklogin-iOS-TLS.png>)
> 在info.plist 文件中添加一个子项目App Transport Security Settings，然后在其中添加一个key： Allow Arbitrary Loads，其值为YES。修改后其他运营商才能使用一键登录。

如需支持iOS12以下系统，需要添加依赖库，在项目设置target -> 选项卡Build Phase -> Linked Binary with Libraries添加如下依赖库：Network.framework。


## 3.初始化SDK

**接口**

```java
/**
  * SDK初始化，只需执行一次初始化
  * @param key 平台分配的appKey
  * @param complete 初始化结果回调
  */
- (void)initWithKey:(NSString *_Nullable)appKey  complete:(void (^_Nullable)(NSDictionary * _Nonnull resultDic))complete;
```

[获取appkey](https://www.bitlib.cc)

**参数说明**

| 参数  | 类型     | 说明     |
| --- | ------ | ------ |
| key | String | 分配的Key |

**示例**

```java
#import <QuickLogin/WKQuickLogin.h>

...

[[WKQuickLogin getInstance] initWithKey:@"后台分配的Key" complete:^(NSDictionary * _Nonnull resultDic) {
    //初始化回调结果
}];
```

## 4.获取token

### 4.1 隐式获取token

> 自定义授权页,遵循[授权页面设计规范](/login/documents/authorization.md )

**接口**

```java
/**
 * 预授权获取accessCode
 * @param timeout 超时时间
 * @param type 运营商类型
 * @param listener 回调监听
 */

- (void)getAccessCode:(double)timeout listener:(LoginResultListener _Nonnull) listener;
参数说明
```

| 参数       | 类型     | 说明  |
| -------- | ---------------- | --------- |
| timeout  | double   | 请求超时时间    |
| listener | WKResultListener | 请求运营商结果回调 |

**示例**

```
#import <QuickLogin/WKQuickLogin.h>

...
    [[WKQuickLogin getInstance] getAccessCode:8000 listener:^(NSDictionary * _Nonnull data) {

    /**
      * 成功时回调
      *
      * @param resultCode   0：成功，其他状态码为失败
      * @param msg          成功信息
      * @param operatorType 运营商类型，CM：中国移动 CU：中国联通  CT:中国电信
      * @param accessCode   成功时返回，用于置换手机号的accessCode
      * @param traceID      成功时返回，追踪ID
      * @param authCode     成功时返回，电信一键登录校验参数
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

| 参数           | 类型     | 是否回传服务器 | 说明                                  |
| ------------ | ------ | ------- | ----------------------------------- |
| resultCode   | int    | 否       | token获取成功时回调，0：成功，其他状态码为失败          |
| msg          | String | 否       | 回调信息                                |
| mobile       | String | 是       | 成功时返回，脱敏手机号 ,示例：188****8888   |
| operatorType | String | 是       | 成功时返回，运营商类型，CM：中国移动 CU：中国联通 CT：中国电信 |
| authCode     | String | 是       | 电信校验code                            |
| accessCode   | String | 是       | 成功时返回，置换token                       |
| traceID      | String | 是       | 成功时返回，追踪ID                          |


### 4.2 显式获取token


**接口**

```java
/* 显式获取token
 * @param model 需要配置的model属性（控制器必传）
 * @param timeout 超时时间
 * @param listener 回调
 * /
 
- (void)getAuthorizationWithModel:(WKCustomModel* )model timeout:(double)timeout listener:(LoginResultListener _Nonnull) listener;

```

| 参数       | 类型     | 说明  |
| -------- | ---------------- | --------- |
| model  | WKCustomModel   | 需要配置的Model属性（控制器必传）    |
| timeout  | double   | 请求超时时间    |
| listener | WKResultListener | 请求运营商结果回调 |

**示例**

```
#import <QuickLogin/WKQuickLogin.h>
#import "WKCustomModel.h"

···

    WKCustomModel *model = [[WKCustomModel alloc]init];
    
    // 当前试图控制器
    model.currentVC = self;
    
    [[WKQuickLogin getInstance] getAuthorizationWithModel:model timeout:8000 listener:^(NSDictionary * _Nonnull data) {
    
        /**
          * 成功时回调
          *
          * @param resultCode   0：成功，其他状态码为失败
          * @param msg          成功信息
          * @param operatorType 运营商类型，CM：中国移动 CU：中国联通  CT:中国电信
          * @param accessCode   成功时返回，用于置换手机号的accessCode
          * @param traceID      成功时返回，追踪ID
          * @param authCode     成功时返回，电信一键登录校验参数
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

| 参数           | 类型     | 是否回传服务器 | 说明                                  |
| ------------ | ------ | ------- | ----------------------------------- |
| resultCode   | int    | 否       | token获取成功时回调，0：成功，其他状态码为失败          |
| msg          | String | 否       | 回调信息                                |
| mobile       | String | 是       | 成功时返回，脱敏手机号 ,示例：188****8888   |
| operatorType | String | 是       | 成功时返回，运营商类型，CM：中国移动 CU：中国联通 CT：中国电信 |
| authCode     | String | 是       | 电信校验code                            |
| accessCode   | String | 是       | 成功时返回，置换token                       |
| traceID      | String | 是       | 成功时返回，追踪ID                          |

4.3 Model属性
通过model属性，可以实现：

可以允许开发者在授权页面上添加自定义的控件；
设置授权页面的元素控件的布局

**注意：使用显式登录时，这个值必传**
> @property (nonatomic,strong) UIViewController *currentVC;

授权界面自定义控件View的Block：

| model属性 | 值类型 | 属性说明 |
| --- | --- | --- |
| authViewBlock | UIView *customView, NSString *operatorType, CGRect numberFrame,CGRect loginBtnFrame, CGRect privacyFrame  | 设置授权页应用自定义控件 |

**示例**

```
[model setAuthViewBlock:^(UIView * _Nonnull customView, NSString * _Nonnull operatorType, CGRect numberFrame, CGRect loginBtnFrame, CGRect privacyFrame) {
        
    UIImageView *ima = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xxx"]];
    ima.frame = customView.bounds;
    [customView addSubview:ima];
        
}];
```

**授权界面背景图片:**

| model属性 | 值类型 | 属性说明 |
| --- | --- | --- |
| authPageBackgroundImage | UIImage | 授权页面背景图片|


**号码栏：**

| model属性 | 值类型 | 属性说明 |
| --- | --- | --- |
|numberText |NSDictionary<NSAttributedStringKey,id> |手机号码富文本设置（字体大小、颜色）
|numberOffsetY |CGFloat |号码栏Y相对于界面上边缘y偏移
numberOffsetY_B |CGFloat |号码栏Y相对于界面下边缘y偏移
|numberOffsetX|NSNumber|号码栏X相对于默认值的左右偏移

**登录按钮：**

| model属性 | 值类型 | 属性说明 |
| --- | --- | --- |
|logBtnText |NSAttributedString |设置登录按钮的富文本属性（字体大小、颜色、文案内容）
|logBtnImgs |NSArray |设置授权登录按钮三种状态的图片数组，数组顺序为：[0]激活状态的图片；[1] 失效状态的图片；[2] 高亮状态的图片
|logBtnOriginLR |NSArray (NSNumber *) |设置登录按钮距离屏幕的左右边距（左右边距可以不一样）
|logBtnHeight |CGFloat|设置登录按钮高h
|logBtnOffsetY|CGFloat|设置登录按钮相对于界面上边缘y偏移
logBtnOffsetY_B|CGFloat|设置登录按钮相对于界面下边缘y偏移

**隐私条款：**

| model属性 | 值类型 | 属性说明 |
| --- | --- | --- |
|appPrivacy |NSArray（NSAttributedString）|APP自定义隐私条款:数组（务必按顺序）要设置NSLinkAttributeName属性可以跳转协议 比如:@[NSAttributedString对象,...]
|appPrivacyDemo|NSAttributedString|设置隐私的内容模板：，1、全句可自定义但必须保留"&&默认&&"字段表明SDK默认协议,否则设置不生效 2、协议1和协议2的名称要与数组 NSAttributedString1 和NSAttributedString2 ... 里的名称 一样 3、必设置项（参考SDK的demo） appPrivacyDemo设置内容：登录并同意&&默认&&和&&百度协议&&、&&京东协议2&&登录并支持一键登录 展示： 登录并同意中国移动条款协议和百度协议1、京东协议2登录并支持一键登录
|privacySymbol|BOOL|设置协议是否有书名号
|uncheckedImg|UIImage|设置复选框未选中时图片
|checkedImg|UIImage|设置复选框选中时图片
|checkTipText|NSString|设置未勾选提示的自定义提示文案(不设置则为空白)
|checkboxWH|CGFloat|复选框大小（只能正方形）必须大于12*/
|privacyColor|UIColor|设置隐私条款名称颜色（协议）
|privacyState|BOOL|隐私条款check框默认状态 默认:NO
|privacyOffsetY|NSNumber|设置隐私条款相对于界面上边缘y偏移
|privacyOffsetY_B|NSNumber|设置隐私条款相对于界面下边缘y偏移
|appPrivacyOriginLR|NSArray (NSNumber *)|设置隐私协议距离屏幕的左右边距

**弹窗授权页：**

| model属性 | 值类型 | 属性说明 |
| --- | --- | --- |
|authWindow|BOOL|窗口模式开关
|controllerSize|CGSize|此属性支持半弹框方式与authWindow不同（此方式为UIPresentationController）设置后自动隐藏切换按钮
|cornerRadius|CGFloat|自定义窗口弧度半径 默认是10
|scaleH|CGFloat|自定义窗口高-缩放系数(屏幕高乘以系数) 默认是0.5
|scaleW|CGFloat|自定义窗口宽-缩放系数(屏幕宽乘以系数) 默认是0.8


###4.3 授权页面的关闭
开发者可以自定义关闭授权页面。

```
- (void)wk_dismissViewControllerAnimated: (BOOL)flag completion: (void (^__nullable)(void))completion;
```

**示例：**

```
···

[[WKQuickLogin getInstance] wk_dismissViewControllerAnimated:YES completion:^{
    NSLog(@"关闭授权页面");        
}];
···
```



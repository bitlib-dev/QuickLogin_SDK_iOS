//
//  WKViewController.m
//  QuickLogin
//
//  Created by bitlib on 04/03/2021.
//  Copyright (c) 2021 bitlib. All rights reserved.
//

#import "ViewController.h"
#import <QuickLogin/WKQuickLogin.h>
#import <QuickLogin/WKCustomModel.h>

@interface ViewController (){
    UIView *loadView;
}

@property (weak, nonatomic) IBOutlet UIButton *getTokenBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController{
    UIActivityIndicatorView *activity;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)pringLog:(NSDictionary *)logDic{
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:logDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = jsonStr;
        NSLog(@"%@",jsonStr);
    });
}

- (IBAction)preLogin:(id)sender {
    [[WKQuickLogin getInstance] preLogin:8000 listener:^(NSDictionary * _Nonnull data) {
        [self pringLog:data];
    }];
}


#pragma mark 隐式登录

- (IBAction)getToken:(id)sender {
    [[WKQuickLogin getInstance] getAccessCode:8000 listener:^(NSDictionary * _Nonnull data) {
        [self pringLog:data];
    }];
}

#pragma mark 显式登录

- (IBAction)getTokenWithAuthVC:(UIButton *)sender{
    // 加载LoadingView
    loadView = [self loadingView];
    [self.view addSubview:loadView];
    
    WKCustomModel *model = [WKCustomModel new];
    
    // 当前VC
    model.currentVC = self;
    
    // 隐私协议距离屏幕左右边距
    model.appPrivacyOriginLR = @[@20,@20];
    // 自定义隐私协议
    model.appPrivacyDemo = [[NSAttributedString alloc]initWithString:@"为保障您的个人隐私权益，请在登录前仔细阅读&&默认&&和xx服务协议以及xx隐私协议" attributes:
                            @{NSFontAttributeName:[UIFont systemFontOfSize: 13],
                              NSForegroundColorAttributeName:UIColor.grayColor,
                            }];
    
    NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:@"xx服务协议" attributes:@{NSLinkAttributeName:@"https://www.qq.com"}];
    NSAttributedString *str2 = [[NSAttributedString alloc]initWithString:@"xx隐私协议" attributes:@{NSLinkAttributeName:@"https://www.baidu.com"}];
    model.appPrivacy = @[str1,str2];
    // 隐私协议颜色
    model.privacyColor = [UIColor systemBlueColor];

    // 脱敏手机号
    model.numberTextAttributes = @{NSForegroundColorAttributeName:UIColor.blackColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:35]};
    
    //全屏模式
    if (sender.tag == 2000) {
        // 登录按钮位置
        model.logBtnOffsetY = @250;
        // 登录按钮左右边距
        model.logBtnOriginLR = @[@20,@20];
        // 登录按钮高度
        model.logBtnHeight = 60;
        //隐私协议
        model.privacyOffsetY  = @420;
        
        // 小屏手机适配
        BOOL isSmallScreen = UIScreen.mainScreen.bounds.size.height < 667.0f;
        if (isSmallScreen) {
            model.numberOffsetY_B = @100;
            model.scaleW = 0.7;
            model.privacyOffsetY_B = @5;
        }
        
        __weak typeof(self) weakSelf = self;
        
        // 自定义授权页（添加元素）
        [model setAuthViewBlock:^(UIView * _Nonnull customView, NSString * _Nonnull operatorType, CGRect numberFrame, CGRect loginBtnFrame, CGRect privacyFrame) {
            
            // slogen
            UILabel *slogen = [[UILabel alloc]init];
            slogen.font = [UIFont systemFontOfSize:12];
            slogen.textColor = [UIColor grayColor];
            slogen.textAlignment = NSTextAlignmentCenter;
            slogen.frame = CGRectMake(0, numberFrame.origin.y + 50, self.view.frame.size.width, 30);
            NSString *operatorName;
            if ([operatorType isEqualToString:@"CM"]) {
                operatorName = @"移动";
            }else if([operatorType isEqualToString:@"CU"]) {
                operatorName = @"联通";
            }else{
                operatorName = @"电信";
            }
            slogen.text = [NSString stringWithFormat:@"认证服务由中国%@提供",operatorName];
            [customView addSubview:slogen];
            
            // 使用其他号码登录
            UIButton *otherPhoneNum = [UIButton buttonWithType:UIButtonTypeCustom];
            otherPhoneNum.frame = CGRectMake(20, loginBtnFrame.origin.y + 80, loginBtnFrame.size.width, loginBtnFrame.size.height);
            [otherPhoneNum setTitle:@"其他号码登录" forState:UIControlStateNormal];
            [otherPhoneNum addTarget:weakSelf action:@selector(useOtherNum:) forControlEvents:UIControlEventTouchUpInside];
            [otherPhoneNum setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [otherPhoneNum setBackgroundImage:[UIImage imageNamed:@"loginBtn_Other"] forState:UIControlStateNormal];
            [customView addSubview:otherPhoneNum];
            
            // 其他号码登录
            UIView * otherLoginView = [[UIView alloc]init];
            otherLoginView.frame = CGRectMake(loginBtnFrame.origin.x, customView.frame.size.height - 150, loginBtnFrame.size.width, 80);
            UILabel *oterLogin = [[UILabel alloc]init];
            oterLogin.frame = CGRectMake(0, 0, otherLoginView.frame.size.width, 15);
            oterLogin.text = @"其他方式登录";
            oterLogin.font = [UIFont systemFontOfSize:12];
            oterLogin.textColor = [UIColor blackColor];
            oterLogin.textAlignment = NSTextAlignmentCenter;
            [otherLoginView addSubview:oterLogin];
            [customView addSubview:otherLoginView];
            
            // 第三方登录
            NSArray *btnTitles = @[@"wechat", @"qq", @"weibo"];
               for (int i = 1; i<4; i++) {
                   UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((otherLoginView.frame.size.width /3 - 39) * i , 30, 30, 30)];
                   [btn setImage:[UIImage imageNamed:btnTitles[i-1]] forState:UIControlStateNormal];
                   [btn setTag:i + 1];
                   [btn addTarget:weakSelf action:@selector(customBtn:) forControlEvents:UIControlEventTouchUpInside];
                   [btn setTintColor:[UIColor blackColor]];
                   [otherLoginView addSubview:btn];
               }
        }];
    }

    // 自定义隐私协议页面
    [model setPrivacyClickBlock:^(NSString * _Nonnull title, NSURL * _Nonnull url) {
        NSLog(@"用户点击了协议：%@ 地址：%@",title,url);
    }];
    
    // 弹窗模式
    if (sender.tag == 1000) {
        model.authWindow = YES;
    }
        
    // 打开授权页获取 -> 获取token
    [[WKQuickLogin getInstance] getAuthorizationWithModel:model timeout:8000 listener:^(NSDictionary * _Nonnull data) {
        
        // 移除loadingView
        [self->loadView removeFromSuperview];
        
        // 关闭授权页
        [[WKQuickLogin getInstance] wk_dismissViewControllerAnimated:YES completion:^{
            NSLog(@"关闭授权页面");
        }];
        
        // 输出日志
        [self pringLog:data];
    }];
}

// 等待HUD
- (UIView *)loadingView{
    UIView *loadView = [[UIView alloc]init];
    loadView.frame = CGRectMake(0,0, 100, 100);
    loadView.center = self.view.center;
    loadView.backgroundColor = [UIColor grayColor];
    loadView.layer.cornerRadius = 10;
    [self.view addSubview:loadView];
    
    UILabel *loadLabel = [[UILabel alloc]init];
    loadLabel.frame = CGRectMake(25, 70, 60, 15);
    loadLabel.font = [UIFont systemFontOfSize:13];
    loadLabel.text = @"登录中...";
    [loadView addSubview:loadLabel];

    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    activity.center = CGPointMake(50, 40);
    activity.transform = CGAffineTransformMakeScale(1,1);
    activity.tag = 100;
    //菊花开始动画
    [activity  startAnimating];
    [loadView  addSubview:activity];
    
    return loadView;
}

// 使用其他号码登录
- (void)useOtherNum:(UIButton *)sender{
    [loadView removeFromSuperview];
    
    [[WKQuickLogin getInstance] wk_dismissViewControllerAnimated:YES completion:^{
        NSLog(@"使用其他号码登录，触发获取验证码逻辑");
    }];
}

// 第三方登录
- (void)customBtn:(UIButton *)sender{
    NSLog(@"button click:%ld",sender.tag);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

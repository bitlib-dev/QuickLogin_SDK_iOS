//
//  WKViewController.m
//  QuickLogin
//
//  Created by bitlib on 04/03/2021.
//  Copyright (c) 2021 bitlib. All rights reserved.
//

#import "ViewController.h"
#import <QuickLogin/WKQuickLogin.h>
#import <TYRZUISDK/UASDKLogin.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

typedef enum : NSUInteger {
    SSOperatorsTypeChinaTietong,//中国铁通
    SSOperatorsTypeTelecom,//中国电信
    SSOperatorsTypeChinaUnicom,//中国联通
    SSOperatorsTypeChinaMobile,//中国移动
    SSOperatorsTypeUnknown,//未知
} SSOperatorsType;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getTokenBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

//预取号
- (IBAction)getToken:(id)sender {
    
    [[WKQuickLogin getInstance] getAccessCode:9999 listener:^(NSDictionary * _Nonnull data) {
            
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = jsonStr;
            NSLog(@"%@",jsonStr);
        });
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

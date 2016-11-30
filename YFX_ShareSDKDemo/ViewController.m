//
//  ViewController.m
//  YFX_ShareSDKDemo
//
//  Created by fangxue on 2016/11/28.
//  Copyright © 2016年 fangxue. All rights reserved.
//

#import "ViewController.h"
#import "YYShareSDKTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"YFX_ShareAndLogin" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(YFX_ShareAndLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
- (void)YFX_ShareAndLogin{
    //注册ShareSDK 可放在APPDelegate中
    [YYShareSDKTool registerShare];
   /*1.关于ShareSDK的集成详情请看Mob官方文档*/
   /*2.本Demo中只做了对ShareSDK的封装和调用*/
    
    //分享
    [YYShareSDKTool shareContentWithShareContentType:@"" contentTitle:@"" contentDescription:@"" contentImage:@"" contentURL:@"" showInView:self.view success:^{
        
        NSLog(@"成功");
        
    } failure:^(NSString *failureInfo) {
        
        NSLog(@"失败");
    } OtherResponseStatus:^(int state) {
        
        //State状态(用户点击了取消分享)
        
    }];
    //登录
    [YYShareSDKTool thirdLoginWithType:@"" result:^(BOOL success, NSString *errorString) {
        
        if (success) {
            
            NSLog(@"登录成功");
            
        }else{
            NSLog(@"%@",errorString);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

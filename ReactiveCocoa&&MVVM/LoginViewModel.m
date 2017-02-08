//
//  LoginViewModel.m
//  ReactiveCocoa&&MVVM
//
//  Created by MY on 2017/2/8.
//  Copyright © 2017年 com.gzkiwi.yinpubaoblue. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

//初始化操作
-(void)setUp
{
    //处理登陆点击信号
    //1. 处理文本框的业务逻辑
    
    //RAC监听文本框改变
    
    /*
     需求:_acountTextFeild/_pwdTextFeild 同时有内容处理事情
     
     */
    _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, acount),RACObserve(self, pwd)] reduce:^id(NSString * account,NSString * pwd){
        return @(account.length > 0 && pwd.length > 0);
    }];
    //处理登录命令
    _loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        //block调用:执行命令就会调用
        //block作用:事件处理
        
        //发送登录请求
        NSLog(@"发送登录请求");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //发送数据请求
                [subscriber sendNext:@"请求登陆的数据"];
                
                //发送完成
                [subscriber sendCompleted];
            });
            
            return nil;
        }];
    }];
    
    //处理登录请求结果
    
    //获取命令中的信号源[subscriber sendNext:@"请求登陆的数据"];
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"获取命令中的信号源:%@",x);
    }];
    //监听命令的执行过程
    //skip:1 跳过没有执行
    [[_loginCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            //正在执行
            NSLog(@"正在执行");
            //显示蒙版
            [MBProgressHUD showMessage:@"正在登录..."];
        }else{
            //没有执行/执行完成
            NSLog(@"执行完成");
            //隐藏蒙版
            [MBProgressHUD hideHUD];
        }
    }];
    
    

    
    
 
    
}

@end

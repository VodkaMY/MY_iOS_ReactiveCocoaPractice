//
//  ViewController.m
//  ReactiveCocoa&&MVVM
//
//  Created by MY on 2017/2/8.
//  Copyright © 2017年 com.gzkiwi.yinpubaoblue. All rights reserved.
//

#import "ViewController.h"

#import "GlobeHeader.h"

#import "LoginViewModel.h"

@interface ViewController ()
@property(nonatomic,strong)LoginViewModel * loginVM;

@end

@implementation ViewController

-(LoginViewModel *)loginVM
{
    if (_loginVM == nil) {
        _loginVM = [[LoginViewModel alloc]init];
    }
    return _loginVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //MVVM:
    //VM:视图模型, 处理界面上所有业务逻辑
    
    //每一个控制器都对应一个VM模型
    //最好不要包括视图V
    [self bindViewModel];
    [self loginEvent];
    
    
}

//绑定viewModel
-(void)bindViewModel
{
    //1. 给视图模型的账号和密码绑定信号
    RAC(self.loginVM,acount) = _acountTextFeild.rac_textSignal;
    RAC(self.loginVM,pwd) = _pwdTextFeild.rac_textSignal;
}

//登录事件
-(void)loginEvent
{
    RAC(_loginBtn,enabled) = self.loginVM.loginEnableSignal;
    //2. 监听登录按钮的点击
    
    //创建登录命令
    
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了登录按钮");
        
        //处理登录事件
        [self.loginVM.loginCommand execute:nil];
        
        
    }];
}







#pragma mark - RAC实现登录
-(void)RACLogin
{
    //RAC监听文本框改变
    
    //1. 处理文本框的业务逻辑
    /*
     需求:_acountTextFeild/_pwdTextFeild 同时有内容处理事情
     
     */
    RACSignal * loginEnableSignal = [RACSignal combineLatest:@[_acountTextFeild.rac_textSignal,_pwdTextFeild.rac_textSignal] reduce:^id(NSString * account,NSString * pwd){
        return @(account.length > 0 && pwd.length > 0);
    }];
    RAC(_loginBtn,enabled) = loginEnableSignal;
    /*
     [loginEnableSignal subscribeNext:^(id x) {
     _loginBtn.enabled = [x boolValue];
     }];
     */
    
    //2. 监听登录按钮的点击
    
    //创建登录命令
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
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
    
    //获取命令中的信号源[subscriber sendNext:@"请求登陆的数据"];
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"获取命令中的信号源:%@",x);
    }];
    //监听命令的执行过程
    //skip:1 跳过没有执行
    [[command.executing skip:1] subscribeNext:^(id x) {
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
    
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了登录按钮");
        
        //处理登录事件
        [command execute:nil];
        
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

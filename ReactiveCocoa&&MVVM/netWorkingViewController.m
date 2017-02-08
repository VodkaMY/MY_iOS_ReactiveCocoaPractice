//
//  netWorkingViewController.m
//  ReactiveCocoa&&MVVM
//
//  Created by MY on 2017/2/8.
//  Copyright © 2017年 com.gzkiwi.yinpubaoblue. All rights reserved.
//

#import "netWorkingViewController.h"
#import "GlobeHeader.h"
#import "RequestViewModel.h"

@interface netWorkingViewController ()
/*** 请求视图模型 ***/
@property(nonatomic,strong)RequestViewModel * requestVM;

@end

@implementation netWorkingViewController

//所有的视图模型都是懒加载
-(RequestViewModel *)requestVM
{
    if (_requestVM == nil) {
        _requestVM = [[RequestViewModel alloc]init];
    }
    return _requestVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    //https://api.douban.com/v2/book/search?q=%E5%9F%BA%E7%A1%80
    
    //MVVM+RAC
    
    //发送请求并拿到数据
    RACSignal * signal = [self.requestVM.requestCommand execute:nil];
    
    //订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
        requestModel * model = x[0];
        NSLog(@"%@",model.subtitle);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //发送请求并拿到数据
    RACSignal * signal = [self.requestVM.requestCommand execute:nil];
    
    //订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
        requestModel * model = x[0];
        NSLog(@"%@",model.subtitle);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

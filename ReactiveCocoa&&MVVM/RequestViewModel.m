//
//  RequestViewModel.m
//  ReactiveCocoa&&MVVM
//
//  Created by MY on 2017/2/8.
//  Copyright © 2017年 com.gzkiwi.yinpubaoblue. All rights reserved.
//

#import "RequestViewModel.h"
#import "MJExtension.h"

@implementation RequestViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    _requestCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        //执行命令
        //发送请求
        
        //创建信号
        RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
            [manager GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":@"%E5%9F%BA%E7%A1%80"}  success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                //                NSLog(@"%@",responseObject);
                //发送数据
                NSArray * dictArr = responseObject[@"books"];
                NSArray * modelArr = [[dictArr.rac_sequence map:^id(id value) {
                    requestModel * model = [requestModel mj_objectWithKeyValues:value];
                    return model;
                }] array];
                [subscriber sendNext:modelArr];
//                NSArray * dicArr = [NSArray array];
//                NSArray * dataList =  [[dicArr.rac_sequence map:^id(NSDictionary * value) {
//                    //value是dic, 可以使用mjexternsion
//                    return nil;
//                }] array];
                //发送成功
                [subscriber sendCompleted];
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                //失败处理
            }];
            return nil;
        }];
        
        return signal;
    }];
    
    //监听
    [[_requestCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            [MBProgressHUD showMessage:@"正在加载..."];
        }else{
            [MBProgressHUD hideHUD];
        }
    }];
    
    
    
}


//分页处理 存在优化, 以后处理
//- (RACCommand *)refreshDataCommand {
//    
//    if (!_refreshDataCommand) {
//        
//        @weakify(self);
//        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            
//            @strongify(self);
//            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                
//                @strongify(self);
//                self.currentPage = 1;
//                [self.request POST:REQUEST_URL parameters:nil success:^(CMRequest *request, NSString *responseString) {
//                    
//                    NSDictionary *dict = [responseString objectFromJSONString];
//                    [subscriber sendNext:dict];
//                    [subscriber sendCompleted];
//                    
//                } failure:^(CMRequest *request, NSError *error) {
//                    
//                    ShowErrorStatus(@"网络连接失败");
//                    [subscriber sendCompleted];
//                }];
//                return nil;
//            }];
//        }];
//    }
//    
//    return _refreshDataCommand;
//}
//
//- (RACCommand *)nextPageCommand {
//    
//    if (!_nextPageCommand) {
//        
//        @weakify(self);
//        //        _nextPageCommand = self.refreshDataCommand; //分页优化处理
//        
//        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            
//            @strongify(self);
//            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                
//                @strongify(self);
//                self.currentPage ++;
//                [self.request POST:REQUEST_URL parameters:nil success:^(CMRequest *request, NSString *responseString) {
//                    
//                    NSDictionary *dict = [responseString objectFromJSONString];
//                    [subscriber sendNext:dict];
//                    [subscriber sendCompleted];
//                    
//                } failure:^(CMRequest *request, NSError *error) {
//                    
//                    @strongify(self);
//                    self.currentPage --;
//                    ShowErrorStatus(@"网络连接失败");
//                    [subscriber sendCompleted];
//                }];
//                return nil;
//            }];
//        }];
//    }
//    
//    return _nextPageCommand;
//}

@end

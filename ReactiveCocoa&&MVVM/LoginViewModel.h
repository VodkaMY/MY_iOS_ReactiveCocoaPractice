//
//  LoginViewModel.h
//  ReactiveCocoa&&MVVM
//
//  Created by MY on 2017/2/8.
//  Copyright © 2017年 com.gzkiwi.yinpubaoblue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobeHeader.h"

@interface LoginViewModel : NSObject

//保存登录界面的账号和密码
/*** 账号 ***/
@property(nonatomic,strong)NSString * acount;
@property(nonatomic,strong)NSString  * pwd;

//处理登录按钮是否允许点击
@property(nonatomic,strong,readonly)RACSignal * loginEnableSignal;

//登录名令
@property(nonatomic,copy)RACCommand * loginCommand;
@end

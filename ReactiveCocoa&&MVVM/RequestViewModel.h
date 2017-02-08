//
//  RequestViewModel.h
//  ReactiveCocoa&&MVVM
//
//  Created by MY on 2017/2/8.
//  Copyright © 2017年 com.gzkiwi.yinpubaoblue. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GlobeHeader.h"
#import "requestModel.h"

@interface RequestViewModel : NSObject
@property(nonatomic,strong,readonly)RACCommand * requestCommand;

@end

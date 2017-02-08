//
//  ViewController.h
//  ReactiveCocoa&&MVVM
//
//  Created by MY on 2017/2/8.
//  Copyright © 2017年 com.gzkiwi.yinpubaoblue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
/*** 账号 ***/
@property (weak, nonatomic) IBOutlet UITextField *acountTextFeild;
/*** 密码 ***/
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFeild;
/*** 登录 ***/
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end


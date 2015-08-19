//
//  UISetup.m
//  OC在线销售系统
//
//  Created by Larry on 15/8/19.
//  Copyright (c) 2015年 Larry. All rights reserved.
//

#import "UISetup.h"

@implementation UISetup

void setupHomeUI() {
    printf("_______________________________\n");
    printf("       在线销售系统欢迎您       \n");
    printf("-----------------------------\n");
    printf("       |  1.用户登录  ｜       \n");
    printf("       |  2.用户注册  ｜       \n");
    printf("       |  0.程序退出  ｜       \n");
    printf("-----------------------------\n");
}

void setupAdminUI(){
    printf("_______________________________\n");
    printf("        你好，管理员       \n");
    printf("-----------------------------\n");
    printf("       |  1.查看用户信息  ｜    \n");
    printf("       |  2.修改用户名字  ｜    \n");
    printf("       |  3.删除用户信息  ｜    \n");
    printf("       |  4.用户资金操作  ｜    \n");
    printf("       |  5.我要商品操作  ｜     \n");
    printf("       |  6.我要订单操作  ｜     \n");
    printf("       |  7.我要添加用户  ｜     \n");
    printf("       |  0.注销返回首页  ｜    \n");
    printf("-----------------------------\n");
}

void setupMemUI(){
    printf("_______________________________\n");
    printf("      你好，普通用户      \n");
    printf("-----------------------------\n");
    printf("     |  1.我要存款         \n");
    printf("     |  2.我要取款        \n");
    printf("     |  3.查看资金流水        \n");
    printf("     |  4.用户转账          \n");
    printf("     |  5.修改密码         \n");
    printf("     |  6.购买商品           \n");
    printf("     |  7.订单操作          \n");
    printf("     |  0.注销返回首页            \n");
    printf("-----------------------------\n");
}




@end

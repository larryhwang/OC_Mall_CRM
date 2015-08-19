//
//  Test.m
//  OC在线销售系统
//
//  Created by Larry on 15/8/19.
//  Copyright (c) 2015年 Larry. All rights reserved.
//

#import "Test.h"

@implementation Test


void MainUILoop() {
    setupHomeUI();
    int n;
    while (1)
    {
        printf("请输入序号：");
        scanf("%d",&n);
        switch(n) {
            case 1:   //登录
            {
                printf("1");
                break;
            }
            case 2:  //注册
            {
                printf("2");
                break;
            }
            case 0:
            {
                printf("系统已退出");
             //   NSLog(@"哈哈哈");
                return;
            }
            default:
            {
#warning 补充乱点序号的处理
                break;
            }
        }
    }
}
@end

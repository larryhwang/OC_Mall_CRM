//
//  main.m
//  OC在线销售系统
//
//  Created by Larry on 15/8/19.
//  Copyright (c) 2015年 Larry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetUI.h"
void Loop();
int main(int argc, const char * argv[]) {
    setupHomeUI();
    Loop();
    return 0;
}

void Loop() {
    int n;
    while (1)
    {
        printf("请输入序号：");
        scanf("%d",&n);
        switch(n) {
            case 1:
            {
                NSLog(@"1");
                break;
            }
            case 2:
            {   NSLog(@"2");
                break;
            }
            case 0:
            {   NSLog(@"系统已退出，谢谢使用！");
                return;
            }
            default:
            {
                
                break;
            }
        }
    }
}
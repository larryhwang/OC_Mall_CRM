//
//  Test.m
//  OC在线销售系统
//
//  Created by Larry on 15/8/19.
//  Copyright (c) 2015年 Larry. All rights reserved.
//

#import "Test.h"
#include<string.h>
#include<malloc/malloc.h>
#include <stdlib.h>
#include "UISetup.h"
@implementation Test


void MainUILoop() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    
    setupHomeUI();
    int n;
    while (1)
    {
        printf("现在为主菜单,请选择：");
        scanf("%d",&n);
        switch(n) {
            case 1:   //登录
            {
                printf("输入用户名:");
                char *Name=(char *)malloc(20);
                char *PW=(char *)malloc(20);
                
                scanf("%s",Name);
                NSString *name =[NSString stringWithCString:Name encoding:NSUTF8StringEncoding];
                NSLog(@"%@",name);
                
                printf("请输入密码:");
                scanf("%s",PW);
                NSString *pw =[NSString stringWithCString:PW encoding:NSUTF8StringEncoding];
                NSLog(@"%@",pw);
     
                NSString *NameFromDB = [db stringForQuery:@"SELECT Name FROM Users WHERE Name = ?",name];
                NSString *PwFromDb =[db stringForQuery:@"SELECT PW FROM Users WHERE Name = ?",name];
                if (PwFromDb ==nil||!([PwFromDb isEqualToString:pw])) {
                    printf("账号或密码不正确\n");
                    break;
                }else if ([NameFromDB isEqualToString:@"Admin"]){
                    //建立一个人对象，并拥有SuperOration
                    
                    
                    
                    
                    
                    setupAdminUI();
                }
                break;
            }
            case 2:  //注册
            {
                printf("2");
                printf("1");
                system("cls");
                printf("输入用户名:");
                char *Name=(char *)malloc(20);
                char *PW=(char *)malloc(20);
                
                scanf("%s",Name);
                NSString *name =[NSString stringWithCString:Name encoding:NSUTF8StringEncoding];
                NSLog(@"%@",name);
                
                printf("请输入密码:");
                scanf("%s",PW);
                NSString *pw =[NSString stringWithCString:PW encoding:NSUTF8StringEncoding];
                NSLog(@"%@",pw);
                
                
   
                BOOL SUCESS =   [db executeUpdate:@"INSERT INTO Users (Name,PW) VALUES (?,?)",
                                 name,
                                 pw,
                                 [NSData dataWithContentsOfFile: dbPath]];
                if (SUCESS) {
                    printf("恭喜，注册成功\n");
                    break;
                }
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

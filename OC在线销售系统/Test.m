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
                    //进入，管理员界面 建立一个人对象，并拥有SuperOration操作
                    
                    //画出视图，并进入事件循环
                    
                    
                    
                    AdminUILoop();
                }
                // 进入普通会员界面
                 //画出视图，并进入事件循环
                 // 建立一个人对象，并拥有Operation操作

                
                
                setupMemUI();
                
                
                
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


void AdminUILoop(){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
   
    int n;
    while (1)
    {
        setupAdminUI();
        printf("现在管理员菜单,请选择：");
        scanf("%d",&n);
        switch(n) {
            case 1:   //查看用户信息
            {
                FMResultSet *rs = [db executeQuery:@"select * from Users"];
                printf("                                                    name    |    password    |     money\n");
                while ([rs next]) {
                    NSString *name = [rs stringForColumnIndex:1];
                    NSString *pw = [rs stringForColumnIndex:2];
                    int  Money = [rs intForColumnIndex:3];
                    
                    NSLog(@"%@          %@           %i",name,pw,Money);
                    ;
                }
                
                break;
            }
            case 2:  //修改用户名字
            {
            
               
                printf("输入所需更改的用户名:");
                char *Name=(char *)malloc(20);
                scanf("%s",Name);
                NSString *name =[NSString stringWithCString:Name encoding:NSUTF8StringEncoding];
                NSLog(@"%@",name);
                
                NSString *NameFromDB = [db stringForQuery:@"SELECT Name FROM Users WHERE Name = ?",name];
                if (NameFromDB ==nil) {
                   printf("该用户不存在\n");
                     setupAdminUI();
                   break;
                }else {
                    char *NewName=(char *)malloc(20);
                    printf("请输入新名字\n");
                    scanf("%s",NewName);
                    NSString *New_name =[NSString stringWithCString:NewName encoding:NSUTF8StringEncoding];
                    if ([db executeUpdate:@"UPDATE  Users SET Name= ? WHERE Name = ?", New_name,name, [NSData dataWithContentsOfFile: dbPath]]) {
                        printf("修改成功!\n");
                    }

                }
                
                break;
            }
            case 3:  //删除用户信息
            {
                printf("输入要删除的用户名:");
                char *Name=(char *)malloc(20);
                scanf("%s",Name);
                NSString *name =[NSString stringWithCString:Name encoding:NSUTF8StringEncoding];
                NSLog(@"%@",name);
                
                NSString *NameFromDB = [db stringForQuery:@"SELECT Name FROM Users WHERE Name = ?",name];
                if (NameFromDB ==nil) {
                    printf("该用户不存在\n");
                    setupAdminUI();
                    break;
                }else {
                    /*
                     NSString * query = [NSString stringWithFormat:@"DELETE FROM SUser WHERE uid = '%@'",uid];
                     [AppDelegate showStatusWithText:@"删除一条数据" duration:2.0];
                     [_db executeUpdate:query];
                     */
                     NSString * query = [NSString stringWithFormat:@"DELETE FROM Users WHERE Name = '%@'",NameFromDB];
                    if ([db executeUpdate:query]) {
                        printf("删除成功\n");
                    }
                }
                break;
            }
            case 4:  //用户资金操作
            {      int n;
#warning 资金变更
                while (1){
                    printf("_______________________________\n");
                    printf("          资金操作       \n");
                    printf("-----------------------------\n");
                    printf("    |  1.变更单个用户存款  ｜    \n");
                    printf("    |  2.用户之间进行转账  ｜    \n");
                    printf("-----------------------------\n");
                    printf("请输入操作序号:");
                    scanf("%d",&n);
                    switch (n) {
                        case 1:{
                            printf("输入变更账号的用户名:");
                            
                            char *Name=(char *)malloc(20);
                            
                            scanf("%s",Name);
                            
                            NSString *name =[NSString stringWithCString:Name encoding:NSUTF8StringEncoding];
                            
                            NSLog(@"%@",name);
                            
                            
                            
                            NSString *NameFromDB = [db stringForQuery:@"SELECT Name FROM Users WHERE Name = ?",name];
                            
                            if (NameFromDB ==nil) {
                                
                                printf("该用户不存在\n");
                                
                                setupAdminUI();
                                
                                break;
                                
                            }else {
                                
                                int M;
                                
                                printf("请输入含符号的整数完成资金变更:");
                                
                                scanf("%d",&M);
                                
                                int MoneyDB = [db intForQuery:@"SELECT Money FROM Users WHERE Name = ?",NameFromDB];
                                
                                int New_Money = MoneyDB  + M;
                                
                                NSString *sql =[NSString stringWithFormat:@"UPDATE  Users SET Money= %d WHERE Name = '%@'",New_Money, NameFromDB];
                                
                                
                                
                                // if ([db executeUpdate:@"UPDATE  Users SET Money= ? WHERE Name = ?", New_Money,NameFromDB, [NSData dataWithContentsOfFile: dbPath]]) {
                                
                                NSLog(@"%@",sql);
                                
                                if ([db executeUpdate:sql]) {
                                    
                                    printf("资金修改成功!\n");
                                    
                                }
                                
                            }
                            
                            break;
                             //单个
                             break;
                                  }//end _ Case
                        case 2:{
                              //转账
                            break;
                                  }
                        default:
                        {

                            break;
                        }
                    
                } //end_while
            }
        }//end_case4
                
                
                
                
            case 5:  //我要商品操作
            {
                
                break;
            }
            case 6:  //我要订单操作
            {
                
                break;
            }
            case 7:  //我要添加用户
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
                    printf("恭喜，添加成功\n");
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

void MemUILoop(){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    
    setupMemUI();
    int n;
    while (1)
    {
        printf("现在普通用户菜单,请选择：");
        scanf("%d",&n);
        switch(n) {
            case 1:   //我要存款
            {
                
                
                break;
            }
            case 2:  //我要取款
            {
                
                break;
            }
            case 3:  //查看资金流水
            {
                
                break;
            }
            case 4:  //用户转账
            {
                
                break;
            }
            case 5:  //修改密码
            {
                
                break;
            }
            case 6:  //购买商品
            {
                
                break;
            }
            case 7:  //订单操作
            {
                
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

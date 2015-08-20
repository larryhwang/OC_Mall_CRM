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

-(void)setCurUser:(NSString *)name{
    self.CurrenUser = name;
}
-(void) MainUILoop {
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
#pragma mark -查看所有用户信息
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
#warning 转账
                            printf("输入需要转账的用户名:");
                            
                            char *Name=(char *)malloc(20);
                            
                            scanf("%s",Name);
                            
                            NSString *de_name =[NSString stringWithCString:Name encoding:NSUTF8StringEncoding];
                            
                            NSLog(@"%@",de_name);
                            
                            
                            
                            NSString *NameFromDB = [db stringForQuery:@"SELECT Name FROM Users WHERE Name = ?",de_name];
                            
                            if (NameFromDB ==nil) {
                                printf("该用户不存在\n");
                                break ;
                            } else {
                                printf("输入转入账户的用户名:");
                                scanf("%s",Name);
                                NSString *Acept_name =[NSString stringWithCString:Name encoding:NSUTF8StringEncoding];
                                NSString *Acept_NameFromDB = [db stringForQuery:@"SELECT Name FROM Users WHERE Name = ?",de_name];
                                if (Acept_NameFromDB == nil) {
                                    printf("该用户不存在");
                                }else{
                                    int M ;
                                    printf("输入转账金额");
                                    scanf("%d",&M);
                                    int de_MoneyDB = [db intForQuery:@"SELECT Money FROM Users WHERE Name = ?",de_name];
                                    int ac_MoneyDB = [db intForQuery:@"SELECT Money FROM Users WHERE Name = ?",Acept_name];
                                    if (M>de_MoneyDB) {
                                        printf("余额为%d,金额不足\n",de_MoneyDB);
                                        break ;
                                    }else{
                                        //计算
                                        int New_deMoneyDB = de_MoneyDB - M;
                                        int New_acMoneyDB = ac_MoneyDB + M;
                                        //更新
                                        NSString *sql_de =[NSString stringWithFormat:@"UPDATE  Users SET Money= %d WHERE Name = '%@'",New_deMoneyDB, de_name];
                                        NSString *sql_ac =[NSString stringWithFormat:@"UPDATE  Users SET Money= %d WHERE Name = '%@'",New_acMoneyDB, Acept_name];
                                        if ([db executeUpdate:sql_de]&&[db executeUpdate:sql_ac]) {
                                            printf("转账成功!\n");
                                        }
                                    }
                                }
                            }
                            break;
                                  }
                        default:
                        {

                            break;
                        }
                    
                } //end_while
                    break;
            }
        }//end_case4
                
                
                
                
            case 5:  //我要商品操作
            {
                int n;
#warning 商品变更
                while (1){
                    printf("_______________________________\n");
                    printf("          商品操作       \n");
                    printf("-----------------------------\n");
                    printf("    |  1.查询当前商品  ｜    \n");
                    printf("    |  2.新增额外商品  ｜    \n");
                    printf("    |  3.删除制定商品  ｜    \n");
                    printf("-----------------------------\n");
                    printf("请输入操作序号:");
                    scanf("%d",&n);
                    switch (n) {
#warning 查询商品
                        case 1:{
                            FMResultSet *rs = [db executeQuery:@"select * from Goods"];
                            printf("                                                    name    |    Count    |     Price     \n");
                            while ([rs next]) {
                                NSString *name = [rs stringForColumnIndex:1];
                                int  count = [rs intForColumnIndex:2];
                                int  Money = [rs intForColumnIndex:3];
                                
                                NSLog(@"%@      %i           %i",name,count,Money);
                               
                            }
                             break;

                        }//end _ Case1
                        case 2:{
                            
                                                } //end_case2 新增商品
                       
                      
                            
                            
                            
                            
                        case 3:{
                            //删除商品
#warning 删除商品
                            printf("输入需要删除的商品名:");
                            
                            char *Name=(char *)malloc(20);
                            
                            scanf("%s",Name);
                            
                            NSString *pd_name =[NSString stringWithCString:Name encoding:NSUTF8StringEncoding];
                            
                            NSLog(@"%@",pd_name);
                            
                            
                            
                            NSString *pd_nameDB = [db stringForQuery:@"SELECT Name FROM Goods WHERE Name = ?",pd_name];
                            
                            if (pd_nameDB ==nil) {
                                printf("该商品不存在\n");
                                break ;
                            } else {
                               
                                NSString * query = [NSString stringWithFormat:@"DELETE FROM Goods WHERE Name = '%@'",pd_nameDB];
                                if ([db executeUpdate:query]) {
                                    printf("删除成功\n");
                                }

                            } //end_else
                            break;
                        }//end_case3  删除商品
                            
                            
                        default:
                        {
                            
                            break;
                        }
                            
                    } //end_while
                    break;
                }


                break;
            }
            case 6:  //我要订单操作
            {
                {      int n;
#warning 订单操作
                    while (1){
                        printf("_______________________________\n");
                        printf("          订单操作       \n");
                        printf("-----------------------------\n");
                        printf("    |  1.查询所有订单  ｜    \n");
                        printf("    |  2.按照商品查询  ｜    \n");
                        printf("    |  3.按照用户查询  ｜    \n");
                        printf("    |  4.新增额外订单  ｜    \n");
                        printf("    |  5.删除指定订单  ｜    \n");
                        printf("-----------------------------\n");
                        printf("请输入操作序号:");
                        scanf("%d",&n);
                        switch (n) {
#pragma mark -Case1.订单查询
                            case 1:{   //
                                FMResultSet *rs = [db executeQuery:@"select * from Deal"];
                                printf("                                                    Payer    |    Goods    |     Price   |        Count           \n");
                                while ([rs next]) {
                                    NSString *name = [rs stringForColumnIndex:1];
                                    NSString  *goods = [rs stringForColumnIndex:2];
                                    int  Count = [rs intForColumnIndex:3];
                                    int  Price = [rs intForColumnIndex:4];
                                    
                                    NSLog(@"%@          %@           %i        %i",name,goods,Price,Count);
                                   
                                }
            
                                 break;
                                
                                      }//end _ Case1.订单查询
#pragma mark -Case2.按商品查询
                            case 2:{    //按商品查询
                                
#warning 按商品名查询
                                printf("输入需要查询的商品名:");
                                
                                char *Name=(char *)malloc(20);
                                
                                scanf("%s",Name);
                                
                                NSString *pro_name =[NSString stringWithCString:Name encoding:NSUTF8StringEncoding];
                                
                                NSLog(@"%@",pro_name);
                                
                                
                                
                                NSString *ProNameFromDB = [db stringForQuery:@"SELECT Name FROM Goods WHERE Name = ?",pro_name];
                                
                                if (ProNameFromDB ==nil) {
                                    printf("该商品不存在\n");
                                    break ;
                                } else {
                                    NSString *sql = [NSString stringWithFormat:@"select * from Deal WHERE Goods = '%@'",ProNameFromDB];
                                    FMResultSet *rs = [db executeQuery:sql];
                                    printf("                                                    Payer    |    Goods    |     Price   |        Count           \n");
                                    while ([rs next]) {
                                        NSString *name = [rs stringForColumnIndex:1];
                                        NSString  *goods = [rs stringForColumnIndex:2];
                                        int  Count = [rs intForColumnIndex:3];
                                        int  Price = [rs intForColumnIndex:4];
                                        
                                        NSLog(@"%@          %@           %i        %i",name,goods,Price,Count);
                                        
                                    }
                                    
                                    break;
                                }//end_else
                                break;
                            }//end _ Case2.商品查询
#pragma mark -Case3.按用户查询
                            case 3:{
                                
                                printf("输入需要查询的用户名:");
                                
                                char *Name=(char *)malloc(20);
                                
                                scanf("%s",Name);
                                
                                NSString *_name =[NSString stringWithCString:Name encoding:NSUTF8StringEncoding];
                                
                                NSLog(@"%@",_name);
                                
                                
                                
                                NSString *NameFromDB = [db stringForQuery:@"SELECT Name FROM Users WHERE Name = ?",_name];
                                
                                if (NameFromDB ==nil) {
                                    printf("该用户不存在\n");
                                    break ;
                                } else {
                                    NSString *sql = [NSString stringWithFormat:@"select * from Deal WHERE Payer = '%@'",NameFromDB];
                                    FMResultSet *rs = [db executeQuery:sql];
                                    printf("                                                    Payer    |    Goods    |     Price   |        Count           \n");
                                    while ([rs next]) {
                                        NSString *name = [rs stringForColumnIndex:1];
                                        NSString  *goods = [rs stringForColumnIndex:2];
                                        int  Count = [rs intForColumnIndex:3];
                                        int  Price = [rs intForColumnIndex:4];
                                        
                                        NSLog(@"%@          %@           %i        %i",name,goods,Price,Count);
                                        
                                    }
                                    
                                    break;
                                }//end_else
                                break;

                            
                            } //end _ Case3.按用户查询
#pragma mark -Case4.新增订单
                            case 4:{
                             //获取
                                
                            printf("输入购买者用户名:");
                                
                            char *Name=(char *)malloc(20);
                            
                            scanf("%s",Name);
                                
                            NSString *_name =[NSString stringWithCString:Name encoding:NSUTF8StringEncoding];
                                
                            NSLog(@"%@",_name);
                                
                                
                                
                            NSString *NameFromDB = [db stringForQuery:@"SELECT Name FROM Users WHERE Name = ?",_name];
                                
                            if (NameFromDB ==nil) {
                                printf("该用户不存在\n");
                                break ;
                            } else {
                                printf("请输入购买商品名称");
                                char *PrName=(char *)malloc(20);
                                
                                scanf("%s",PrName);
                                
                                NSString *str_PR_name =[NSString stringWithCString:PrName encoding:NSUTF8StringEncoding];
                                NSString *PrNameFromDB = [db stringForQuery:@"SELECT Name FROM Goods WHERE Name = ?",str_PR_name];
                                if (PrNameFromDB ==nil) {
                                    printf("商品名不存在");
                                    break;
                                }else {
#warning 订单添加
                                 //更新
                                    int P;
                                    int C;
                                    printf("请输入购买数量:");
                                    scanf("%d",&C);
                                    printf("请输入购买单价:");
                                    scanf("%d",&P);
                                    BOOL SUCESS =   [db executeUpdate:@"INSERT INTO Deal (Payer,Goods,Count,Price) VALUES (?,?,?,?)",
                                                     NameFromDB,
                                                     PrNameFromDB,
                                                     [NSNumber numberWithInt:C],
                                                     [NSNumber numberWithInt:P],
                                                     [NSData dataWithContentsOfFile: dbPath]];

                                    if (SUCESS) {
                                        printf("添加订单成功\n");
                                        break ;
                                    }
                                    
                                    
                                }

                            
                            
                            }
                                
                           
                            
                            
                            } //end _ Case4.新增订单
#pragma mark -Case3.删除订单
                            case 5:{} //end _ Case5.删除订单
                            default:
                            {
                                FMResultSet *rs = [db executeQuery:@"select * from Deal"];
                                printf("                                                UID      Payer    |    Goods    |     Price   |        Count           \n");
                                while ([rs next]) {
                                    int UID = [rs intForColumnIndex:0];
                                    NSString *name = [rs stringForColumnIndex:1];
                                    NSString  *goods = [rs stringForColumnIndex:2];
                                    int  Count = [rs intForColumnIndex:3];
                                    int  Price = [rs intForColumnIndex:4];
                                    NSLog(@"%i       %@          %@           %i        %i",UID,name,goods,Price,Count);
                                    
                                }
                                int Key;
                                printf("请输入需要删除订单的UID");
                                scanf("%d",&Key);
                                
                                int KeyDB =[db intForQuery:@"SELECT UID FROM Deal WHERE UID = ?",[NSNumber numberWithInt:Key]];
                                
                                NSLog(@"%d",KeyDB);
                                if (KeyDB ==0) {
                                    printf("输入UID有误,稍后重试");
                                    break ;
                                } else {
                                    //执行删除订单
                                    NSString *sql =[NSString stringWithFormat:@"DELETE FROM Deal WHERE UID = '%d'",KeyDB];
                                    if ([db executeUpdate:sql]) {
                                        printf("删除成功\n");
                                    }
                                }

                                break;
                            }
                                
                        } //end_while
                        break;
                    }
                }
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
    NSArray    *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString   *documentDirectory = [paths objectAtIndex:0];
    NSString   *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
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


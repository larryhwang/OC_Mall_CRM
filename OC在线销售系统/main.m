//
//  main.m
//  OC在线销售系统
//
//  Created by Larry on 15/8/19.
//  Copyright (c) 2015年 Larry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Test.h"
void MainUILoop();
int main(int argc, const char * argv[]) {
//    //数据库创建
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return 0;
    }
//     //建一张用户表，UID 、姓名、 密码、资金、购买商品ID，
//    [db executeUpdate:@"CREATE TABLE Users (UID integer,Name text, PW text, Money integer,Goods integer)"];
// 
//    [db executeUpdate:@"INSERT INTO Users (Name,Money,PW,Goods) VALUES (?,?,?,?)",
//   
//
//     @"Admin", [NSNumber numberWithInt:0], @"psp",[NSNumber numberWithInt:0],[NSData dataWithContentsOfFile: dbPath]];
//    //以上创建了系统员

//     FMResultSet *rs = [db executeQuery:@"select * from Users"];
//           printf("                                                    name    |    password    |     money\n");
//    while ([rs next]) {
//        NSString *name = [rs stringForColumnIndex:1];
//        NSString *pw = [rs stringForColumnIndex:2];
//        int  Money = [rs intForColumnIndex:3];
// 
//        NSLog(@"%@          %@           %i",name,pw,Money);
//        ;
//    }
  //  MainUILoop();
   // setupAdminUI();
    AdminUILoop();
    
    return 0;
}


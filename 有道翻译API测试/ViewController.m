//
//  ViewController.m
//  有道翻译API测试
//
//  Created by 萨缪 on 2019/2/14.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import "ViewController.h"
#import "NSString+NSString_MD5.h"
#import <AFNetworking.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString * appId = @"5d4b4002ec7509c9";
    NSString * key = @"vt3pIADtrmx0PH4SX88fnz2nPudduNTj";
    NSString * input = [[NSString alloc] initWithFormat:@"salt"];
    NSInteger length = input.length;
    NSString * salt = @"2";
    NSString * from = @"EN";
    NSString * to = @"zh-CHS";
    NSString * string = [NSString stringWithFormat:@"%@%@%@%@",appId,input,salt,key];
    NSString * sign = [NSString md5:string];
//    [input appendFormat:@"%li",length];
    NSString * urlString = [NSString stringWithFormat:@"https://openapi.youdao.com/api?q=%@&from=%@&to=%@&appKey=%@&salt=%@&sign=%@",input,from,to,appId,salt,sign];
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    //get请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //2.封装参数
    NSDictionary *dict = @{
                           @"username":@"Lion",
                           @"pwd":@"1314",
                           @"type":@"JSON"
                           };
     //urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray * resArray = [[responseObject objectForKey:@"basic"] objectForKey:@"explains"];
        dispatch_async(dispatch_get_main_queue(), ^{
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:20];
            NSMutableString * string = [[NSMutableString alloc] init];
            for (int i = 0; i < resArray.count; i++) {
                [string appendString:resArray[i]];
            }
            label.text = string;
            [self.view addSubview:label];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error = %@",error);
        } else {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //NSLog(@"dic = %@",dic);
            //获取翻译后的字符串
            NSArray * resStr = [[dic objectForKey:@"basic"] objectForKey:@"explains"];
            NSString * phoneticStr = [[dic objectForKey:@"basic"] objectForKey:@"us-phonetic"];
            NSString * finalStr = [dic objectForKey:@"web"];
            NSLog(@"finalStr = %@",finalStr);
            NSLog(@"resStr = %@",resStr);
            dispatch_async(dispatch_get_main_queue(), ^{
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
                label.numberOfLines = 0;
                label.font = [UIFont systemFontOfSize:20];
                NSMutableString * string = [[NSMutableString alloc] init];
                for (int i = 0; i < resStr.count; i++) {
                    [string appendString:resStr[i]];
                }
                label.text = phoneticStr;
                [self.view addSubview:label];
            });
//            dispatch_get_main_queue()
        }
    }];
    //开启任务
    //[task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

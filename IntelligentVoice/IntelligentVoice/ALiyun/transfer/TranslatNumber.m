//
//  TranslatNumber.m
//  PocketSchedule
//
//  Created by dongmingming on 2018/8/16.
//  Copyright © 2018年 qtz. All rights reserved.
//

#import "TranslatNumber.h"

@implementation TranslatNumber

+(NSString *)translatNum:(NSString *)arebic

{
    NSString *str = arebic;
    
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零", @"十"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:arabic_numerals forKeys:chinese_numerals];

    NSMutableArray *sums = [NSMutableArray array];

    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *sum = substr;
        if([chinese_numerals containsObject:substr]){
            NSLog(@"=====%@", substr);
            if([substr isEqualToString:@"十"] && i < str.length){
                NSString *nextStr = [str substringWithRange:NSMakeRange(i+1, 1)];
                NSLog(@"-----%@", nextStr);
                if([chinese_numerals containsObject:nextStr]){
                    continue;
                }
            }
            sum = [dictionary objectForKey:substr];
        }
        NSLog(@"====%@", sum);
        [sums addObject:sum];
    }

    NSString *sumStr = [sums  componentsJoinedByString:@""];
    return sumStr;
    
}

@end

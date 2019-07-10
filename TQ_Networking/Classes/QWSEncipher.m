//
//  QWSEncipher.m
//  demo
//
//  Created by Yibo Niu on 2016/11/11.
//  Copyright © 2016年 Yibo Niu. All rights reserved.
//

#import "QWSEncipher.h"

static QWSEncipher *instan = nil;

@implementation QWSEncipher

/** 实现单例 */
+ (instancetype)sharerEncipher
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instan = [[super allocWithZone:NULL] init];
    });
    
    return instan;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [QWSEncipher sharerEncipher];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [QWSEncipher sharerEncipher];
}

// 加密
- (id)QWSEncryption:(NSString*)Encryption{

    NSData *nsdata = [Encryption
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    NSString * temp = nil;
    
    NSMutableArray * tempArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<[base64Encoded length]; i++) {
        temp  = [base64Encoded substringWithRange:NSMakeRange(i, 1)];
        
        [tempArray addObject:temp];
        
    }
    NSString * strings = @"";
    NSString * strings1 = @"";
    NSString * qianstr = @"z";
    NSString * houstr = @"m";
    
    NSMutableArray * arrays = [NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"*",@"!",@"/",@"+",@"=",@"#",nil];
    
    NSMutableArray * mutables = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i< tempArray.count; i++) {
        
        strings = [NSString stringWithFormat:@"%@",tempArray[i]];
        
        strings1 = [NSString stringWithFormat:@"%@",arrays[(i)%arrays.count]];
        
        int asciiCode = [strings characterAtIndex:0];
        
        int asciiCode2 = [strings1 characterAtIndex:0];
        
        int mainstrs = asciiCode+asciiCode2;
        
        [mutables addObject:[NSString stringWithFormat:@"%d",mainstrs]];
        
    }
    
    NSString *ns=[mutables componentsJoinedByString:@","];
    
    NSString* htmls = [ns stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@","] withString:@"_"];
    
    NSString * strit  = [NSString stringWithFormat:@"%@%@%@",qianstr,htmls,houstr];
    
    return strit;
}

// 解密
- (id)QWSDencryption:(NSString *)Dencryption{
    
    NSString * string1 = [Dencryption stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"z"] withString:@""];
    
    NSString * string2 = [string1 stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"m"] withString:@""];
    
    NSString * string3 = [string2 stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_"] withString:@","];
    
    NSMutableArray * stringArray = [string3 componentsSeparatedByString:@","];
    
    NSMutableArray * stringArrays = [[NSMutableArray alloc]init];
    
    NSMutableArray * arrays = [NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"*",@"!",@"/",@"+",@"=",@"#",nil];
    
    for (int i= 0; i<stringArray.count; i++) {
        
        NSString * instrings = [NSString stringWithFormat:@"%@",stringArray[i]];
        
        NSString * contrastArray = [NSString stringWithFormat:@"%@",arrays[(i)%arrays.count]];
        
        int asciiCode  = [instrings intValue];
        
        int asciiCode2 = [contrastArray characterAtIndex:0];
        
        int mainstrs = asciiCode-asciiCode2;
        
        [stringArrays addObject:[NSString stringWithFormat:@"%d",mainstrs]];
        
    }
    
    //NSString * QWmainstr = [stringArrays componentsJoinedByString:@","];
    
    NSMutableArray* man_array = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i<stringArrays.count; i++) {
        
        
        NSString * QWmainstrs = [NSString stringWithFormat:@"%c",[stringArrays[i] intValue]];
        
        [man_array addObject:QWmainstrs];
        
    }
    
    NSString * QWmainstr1 = [man_array componentsJoinedByString:@","];
    
    NSString * QWmainstr2  =[QWmainstr1 stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@","] withString:@""];
    
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:QWmainstr2 options:0];
    
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    
    return base64Decoded;
}



@end

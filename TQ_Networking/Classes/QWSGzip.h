//
//  QWSGzip.h
//  demo
//
//  Created by Yibo Niu on 2016/11/11.
//  Copyright © 2016年 Yibo Niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zlib.h"

@interface QWSGzip : NSObject

/** 单例 */
+ (instancetype)sharedGzip;

// 加压
- (NSData *)gZipDataPressure:(NSData*)pressureData;
// 解压
- (NSData *)gzipDataExtract:(NSData *)extractData;

@end

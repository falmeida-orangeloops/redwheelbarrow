//
//  Downloads.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/22/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadManager.h"

@implementation DownloadManager

+ (void)dataFromURL:(NSURL *)url completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler {
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:completionHandler];
    [task resume];
}

@end

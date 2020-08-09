//
//  DownloadManager.h
//  mynotesapp
//
//  Created by Facundo Almeida on 6/22/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#ifndef DownloadManager_h
#define DownloadManager_h

@interface DownloadManager : NSObject

+ (void)dataFromURL:(NSURL *)url completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *httpError))completionHandler;

@end

#endif /* DownloadManager_h */

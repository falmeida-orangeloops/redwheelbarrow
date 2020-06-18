//
//  JSONParser.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/17/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import "JSONParser.h"
#import <Foundation/Foundation.h>

@implementation JSONParser

+ (NSDictionary<NSString *,NSString *> *)parseJSONFromLocalFile:(void (^)(NSError *))completed {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"note" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary<NSString *,NSString *> *result = nil;
    NSError *parsingError = nil;
    
    if (data == nil)
        parsingError = [NSError errorWithDomain:@"falmeida-orangeloops.mynotesapp" code:-1 userInfo:0];
    
    else
        result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parsingError];
    
    if (parsingError != nil)
        completed(parsingError);
    
    return result;
}

@end

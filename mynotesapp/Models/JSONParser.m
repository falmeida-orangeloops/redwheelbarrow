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

+ (NSDictionary<NSString *,NSString *> *)parseJSONFromData:(NSData *)data error:(NSError **)error {
    
    if (data == nil) {
        return nil;
    }
    
    else {
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
        
        return result;
    }
}

@end

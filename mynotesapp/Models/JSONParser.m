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

+ (id)parseJSONFromLocalFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"notes" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end

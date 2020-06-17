//
//  NSDateFormatter+MyFormats.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/17/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import "NSDateFormatter+MyFormats.h"
#import <Foundation/Foundation.h>

@implementation NSDateFormatter (MyFormats)

+ (NSString *)shortStringFromDate:(NSDate *)date {
    NSDateFormatter *shortStringDateFormatter = nil;
    
    if (shortStringDateFormatter == nil)
        shortStringDateFormatter = [[NSDateFormatter alloc] init];
    
    [shortStringDateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *result = [shortStringDateFormatter stringFromDate:date];
    
    return result;
}

@end

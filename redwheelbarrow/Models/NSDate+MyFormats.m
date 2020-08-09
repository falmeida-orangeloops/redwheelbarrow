//
//  NSDate+MyFormats.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/17/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import "NSDate+MyFormats.h"
#import <Foundation/Foundation.h>

@implementation NSDate (MyFormats)

- (NSString *)shortString {
    NSDateFormatter *shortStringDateFormatter = [[NSDateFormatter alloc] init];
    [shortStringDateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    return [shortStringDateFormatter stringFromDate:self];
}

@end

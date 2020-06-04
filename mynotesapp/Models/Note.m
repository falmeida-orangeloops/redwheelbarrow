//
//  Note.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/4/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@implementation Note

- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    self.id = [[NSString alloc] initWithString:dict[@"id"]];
    self.title = [[NSString alloc] initWithString:dict[@"title"]];
    self.content = [[NSString alloc] initWithString:dict[@"content"]];
    self.createdDate = [NSDate dateWithTimeIntervalSince1970:[dict[@"createdDate"] stringValue].intValue];
    self.categoryId = [[NSString alloc] initWithString:dict[@"categoryId"]];
    
    return self;
}

@end

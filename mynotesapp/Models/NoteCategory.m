//
//  NoteCategory.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/4/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteCategory.h"

@implementation NoteCategory

- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    self.id = [[NSString alloc] initWithString:dict[@"id"]];
    self.title = [[NSString alloc] initWithString:dict[@"title"]];
    self.createdDate = [NSDate dateWithTimeIntervalSince1970:[dict[@"createdDate"] stringValue].intValue];
    
    return self;
}

@end

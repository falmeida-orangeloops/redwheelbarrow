//
//  Note.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/4/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
#import "Repository.h"

@implementation Note

- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    self.identifier = dict[@"id"];
    self.title = dict[@"title"];
    self.content = dict[@"content"];
    self.createdDate = [NSDate dateWithTimeIntervalSince1970:[dict[@"createdDate"] stringValue].intValue];
    self.category = [Repository sharedRepository].categories[dict[@"categoryId"]];
    
    return self;
}

@end

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

- (id)initWithIdentifier:(NSString *)identifier title:(NSString *)title content:(NSString *)content createdDate:(NSDate *)createdDate category:(NoteCategory *)category {
    self = [super init];
    
    self.identifier = identifier;
    self.title = title;
    self.content = content;
    self.createdDate = createdDate;
    self.category = category;
    
    return self;
}

- (id)initWithDict:(NSDictionary *)dict {
    return [self initWithIdentifier:dict[@"id"] title:dict[@"title"] content:dict[@"content"] createdDate:[NSDate dateWithTimeIntervalSince1970:[dict[@"createdDate"] integerValue]] category:((Repository*)[Repository sharedRepository]).categories[dict[@"categoryId"]]];
}

@end

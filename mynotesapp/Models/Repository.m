//
//  Repository.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/17/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import "Repository.h"
#import "JSONParser.h"
#import "Note.h"
#import <Foundation/Foundation.h>

@implementation Repository

- (void)reloadNotesAndCategories:(void (^)(NSError *))completed {
    _categories = [[NSMutableDictionary<NSString*,NoteCategory*> alloc] init];
    _notes = [[NSMutableArray<Note*> alloc] init];
    NSDictionary<NSString*,NSString*> *dict = [JSONParser parseJSONFromLocalFile:completed];
    
    if (dict[@"categories"] == nil) {
        completed(nil);
        return;
    }
    
    for (id item in dict[@"categories"])
        [self.categories setObject:[[NoteCategory alloc] initWithDict:item] forKey:item[@"id"]];
    
    for (id item in dict[@"notes"])
        [self.notes addObject:[[Note alloc] initWithDict:item]];
}

+ (id)sharedRepository {
    static Repository *result = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{result = [[Repository alloc] init];});
    
    return result;
}

@end

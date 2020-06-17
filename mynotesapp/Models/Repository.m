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

- (void)reloadNotesAndCategories {
    self.categories = [[NSMutableDictionary<NSString*,NoteCategory*> alloc] init];
    self.notes = [[NSMutableArray<Note*> alloc] init];
    NSDictionary<NSString*,NSString*> *dict = [JSONParser parseJSONFromLocalFile];
    
    for (id item in dict[@"categories"])
        [self.categories setObject:[[NoteCategory alloc] initWithDict:item] forKey:item[@"id"]];
    
    for (id item in dict[@"notes"])
        [self.notes addObject:[[Note alloc] initWithDict:item]];
}

+ (Repository *)sharedRepository {
    static Repository *result = nil;
    
    if (result == nil)
        result = [[Repository alloc] init];
    
    return result;
}

@end

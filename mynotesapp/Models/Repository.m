//
//  Repository.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/17/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import "Repository.h"
#import "DownloadManager.h"
#import "JSONParser.h"
#import "Note.h"
#import <Foundation/Foundation.h>

NSString *const NOTES_URL = @"https://s3.amazonaws.com/kezmo.assets/sandbox/notes.json";

@implementation Repository

- (void)addCategory:(NoteCategory *)category {
    self.categories[category.identifier] = category;
}

- (void)addNote:(Note *)note atIndex:(int)index {
    [self.notes insertObject:note atIndex:index];
}

- (void)addNote:(Note *)note {
    [self addNote:note atIndex:self.notes.count];
}

- (Note *)addEmptyNote {
    Note *note = [[Note alloc] initWithIdentifier:[[NSUUID UUID] UUIDString]
                                            title:@""
                                          content:@""
                                      createdDate:[NSDate date]
                                         category:nil];
    [self addNote:note atIndex:0];
    
    return note;
}

- (void)removeCategory:(NoteCategory *)category {
    [self.categories removeObjectForKey:category.identifier];
}

- (void)removeNote:(Note *)note {
    for (int i = 0; i < self.notes.count; i++) {
        if (self.notes[i] == note) {
            [self.notes removeObjectAtIndex:i];
            return;
        }
    }
}

- (void)updateNote:(Note *)note with:(Note *)otherNote {
    for (int i = 0; i < self.notes.count; i++) {
        if (self.notes[i].identifier == note.identifier) {
            self.notes[i] = otherNote;
            return;
        }
    }
}

- (void)reloadNotesAndCategories:(void (^)(NSError *))completionHandler {
    _categories = [[NSMutableDictionary<NSString*, NoteCategory*> alloc] init];
    _notes = [[NSMutableArray<Note*> alloc] init];
    
    [DownloadManager dataFromURL:[NSURL URLWithString:NOTES_URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *httpError) {
        
        if (httpError != nil) {
            completionHandler(httpError);
            return;
        }
        
        NSError *parsingError = nil;
        NSDictionary<NSString*, NSString*> *dict = [JSONParser parseJSONFromData:data error:&parsingError];
        
        if (dict[@"categories"] == nil || dict[@"notes"] == nil) {
            completionHandler(nil);
            return;
        }
        
        if (parsingError != nil) {
            completionHandler(parsingError);
            return;
        }
        
        for (id item in dict[@"categories"])
            [self addCategory:[[NoteCategory alloc] initWithDict:item]];
        
        for (id item in dict[@"notes"])
            [self addNote:[[Note alloc] initWithDict:item]];
        
        completionHandler(nil);
    }];
}

+ (instancetype)sharedRepository {
    static Repository *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[Repository alloc] init];});
    
    return instance;
}

@end

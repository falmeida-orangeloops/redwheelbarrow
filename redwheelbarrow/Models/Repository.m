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

- (void)removeCategory:(NoteCategory *)category {
    [self.categories removeObjectForKey:category.identifier];
}

- (void)removeNote:(Note *)note {
    for (int i = 0; i < self.notes.count; i++) {
        if ([self.notes[i].identifier isEqualToString:note.identifier]) {
            [self.notes removeObjectAtIndex:i];
            return;
        }
    }
}

- (void)updateNote:(Note *)note {
    for (int i = 0; i < self.notes.count; i++) {
        if (self.notes[i].identifier == note.identifier) {
            self.notes[i] = note;
            return;
        }
    }
    
    [self addNote:note atIndex:0];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isLoading = false;
    }
    return self;
}

- (void)reloadNotesAndCategories:(void (^)(NSError *))completionHandler {
    _isLoading = true;
    
    _categories = [[NSMutableDictionary<NSString*, NoteCategory*> alloc] init];
    _notes = [[NSMutableArray<Note*> alloc] init];
    
    [DownloadManager dataFromURL:[NSURL URLWithString:NOTES_URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *httpError) {
        
        if (httpError != nil) {
            completionHandler(httpError);
            _isLoading = false;
            return;
        }
        
        NSError *parsingError = nil;
        NSDictionary<NSString*, NSString*> *dict = [JSONParser parseJSONFromData:data error:&parsingError];
        
        if (dict[@"categories"] == nil || dict[@"notes"] == nil) {
            completionHandler(nil);
            _isLoading = false;
            return;
        }
        
        if (parsingError != nil) {
            completionHandler(parsingError);
            _isLoading = false;
            return;
        }
        
        for (id item in dict[@"categories"])
            [self addCategory:[[NoteCategory alloc] initWithDict:item]];
        
        for (id item in dict[@"notes"])
            [self addNote:[[Note alloc] initWithDict:item]];
        
        completionHandler(nil);
        _isLoading = false;
    }];
}

+ (instancetype)sharedRepository {
    static Repository *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[Repository alloc] init];});
    
    return instance;
}

@end

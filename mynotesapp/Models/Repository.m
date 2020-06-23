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

- (void)reloadNotesAndCategories:(void (^)(NSError *))completionHandler {
    _categories = [[NSMutableDictionary<NSString*,NoteCategory*> alloc] init];
    _notes = [[NSMutableArray<Note*> alloc] init];
    
    [DownloadManager dataFromURL:[NSURL URLWithString:NOTES_URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *httpError) {
        if (httpError != nil) {
            completionHandler(httpError);
            return;
        }
        
        NSError *parsingError = nil;
        NSDictionary<NSString*,NSString*> *dict = [JSONParser parseJSONFromData:data error:&parsingError];
        
        if (dict[@"categories"] == nil || dict[@"notes"] == nil) {
            completionHandler(nil);
            return;
        }
        
        if (parsingError != nil) {
            completionHandler(parsingError);
            return;
        }
    
        for (id item in dict[@"categories"])
            [_categories setObject:[[NoteCategory alloc] initWithDict:item] forKey:item[@"id"]];
        
        for (id item in dict[@"notes"])
            [_notes addObject:[[Note alloc] initWithDict:item]];
        
        completionHandler(nil);
    }];
}

+ (id)sharedRepository {
    static Repository *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[Repository alloc] init];});
    
    return instance;
}

@end

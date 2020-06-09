//
//  Note.h
//  mynotesapp
//
//  Created by Facundo Almeida on 6/4/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#ifndef Note_h
#define Note_h

@interface Note : NSObject

@property NSString *id; //todo: change name
@property NSString *title;
@property NSString *content;
@property NSDate *createdDate;
@property NSString *categoryId;

- (id)initWithDict:(NSDictionary *)dict;

@end

#endif /* Note_h */

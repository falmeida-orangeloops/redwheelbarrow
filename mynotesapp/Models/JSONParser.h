//
//  JSONParser.h
//  mynotesapp
//
//  Created by Facundo Almeida on 6/17/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#ifndef JSONParser_h
#define JSONParser_h

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

+(NSDictionary<NSString*,NSString*> *)parseJSONFromLocalFile;

@end

#endif /* JSONParser_h */

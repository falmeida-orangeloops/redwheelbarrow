//
//  AlertController.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/17/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import "AlertController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation AlertController

- (id)initWithTitle:(NSString *)title message:(NSString *)message {
    self = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [self addAction:okAction];
    
    return self;
}

@end

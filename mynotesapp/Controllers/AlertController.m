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

+ (void)showAlertWithTitle:(id)title message:(id)message parent:(UIViewController *)parent {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{[parent presentViewController:alert animated:true completion:nil];});
}

@end

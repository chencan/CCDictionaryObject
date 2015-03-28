//
//  NSString+PropertyName.h
//  tataUFO
//
//  Created by Can on 9/9/14.
//  Copyright (c) 2014 http://chencan.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PropertyName)

- (NSString *)camelCaseName;

- (NSString *)underLineName;

+ (NSDictionary *)formatDicKeyTounderLineName:(NSDictionary *)dic;

@end

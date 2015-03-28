//
//  UTObject.h
//  tataUFO
//
//  Created by Can on 14-8-18.
//  Copyright (c) 2014年 http://chencan.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryObject : NSObject <NSCoding>


@property (nonatomic, readonly, strong) NSString *string;
@property (nonatomic, readonly, strong) NSMutableDictionary *dictionary;

- (id)initWithString:(NSString *)theJsonStr;
- (id)initWithDictionary:(NSDictionary *)theDictionary;

+ (id)objectWithString:(NSString *)theJsonStr;
+ (id)objectWithDictionary:(NSDictionary *)theDictionary;


@end

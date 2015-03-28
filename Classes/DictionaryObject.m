//
//  UTObject.m
//  tataUFO
//
//  Created by Can on 14-8-18.
//  Copyright (c) 2014年 http://chencan.github.io. All rights reserved.
//

#import "DictionaryObject.h"
#import "JSONKit.h"
#import "NSString+PropertyName.h"

@interface DictionaryObject ()


@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSMutableDictionary *dictionary;


@end

@implementation DictionaryObject

@dynamic string;


#pragma mark - Life cycle

- (id)init {
    self = [super init];
    if (self) {
        self.dictionary = [NSMutableDictionary dictionary];
    }
    return  self;
}


- (id)initWithDictionary:(NSDictionary *)theDictionary {
    if (!theDictionary) {
        return nil;
    }
    self = [self init];
    if (self) {
        self.dictionary = [[NSMutableDictionary alloc] initWithDictionary:[NSString formatDicKeyTounderLineName:theDictionary]];
//                self.dictionary = [[NSMutableDictionary alloc] initWithDictionary:theDictionary];
    }
    return self;
}


- (id)initWithString:(NSString *)theJsonStr {
    if (!theJsonStr || [theJsonStr length] <= 0) {
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[theJsonStr objectFromJSONStringWithParseOptions:JKParseOptionValidFlags]];
    
    self = [self initWithDictionary:dic];
    
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSString *selectorName = NSStringFromSelector(selector);
    if ([selectorName rangeOfString:@"set"].location == 0) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    
    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}


- (void)forwardInvocation:(NSInvocation *)invocation {
    
    NSString *selectorName = NSStringFromSelector([invocation selector]);
    
    NSString *key = nil;
    if ([selectorName rangeOfString:@"set"].location == 0) {
        key = [[selectorName substringWithRange:NSMakeRange(3, [selectorName length]-4)] underLineName];
        
        id __unsafe_unretained obj;
        [invocation getArgument:&obj atIndex:2];
        
        [self.dictionary setObject:obj ? obj : [NSNull null] forKey:key];
    } else {
        
        
        key = [selectorName underLineName];
        
        id obj = [self.dictionary objectForKey:key];
        [invocation setReturnValue:&obj];
    }
}


- (NSString *)description {
    return [self.dictionary description];
}
#pragma mark - Interface

+ (id)objectWithString:(NSString *)theJsonStr {
    id newInstance = [[[self class] alloc] initWithString:theJsonStr];
    return newInstance;
}


+ (id)objectWithDictionary:(NSDictionary *)theDictionary {
    id newInstance = [[[self class] alloc] initWithDictionary:theDictionary];
    return newInstance;
}


- (NSString *)string {
    if (self.dictionary) {
        NSString *result = [self.dictionary JSONString];
        return result;
    }
    return nil;
}


- (void)setString:(NSString *)theJsonStr {
    NSMutableDictionary *dic = (NSMutableDictionary *)[theJsonStr objectFromJSONStringWithParseOptions:JKParseOptionValidFlags];
    if (!dic) {
        return ;
    }
    self.dictionary = dic;
}



#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [super init];
    if(self != nil) {
        NSDictionary * dic = [coder decodeObjectForKey:@"dictionary"];
        self.dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    if (self.dictionary) {
        [coder encodeObject:self.dictionary forKey:@"dictionary"];
    } else {
        [coder encodeObject:@[] forKey:@"dictionary"];
    }
}
@end

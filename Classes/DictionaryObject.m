//
//  UTObject.m
//  tataUFO
//
//  Created by Can on 14-8-18.
//  Copyright (c) 2014年 http://chencan.github.io. All rights reserved.
//

#import "DictionaryObject.h"
#import "NSString+PropertyName.h"
#import <objc/runtime.h>

@interface DictionaryObject ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;


@end

@implementation DictionaryObject


#pragma mark - Life cycle

- (id)init
{
    self = [super init];
    if (self) {
        self.dictionary = [NSMutableDictionary dictionary];
    }

    return self;
}

- (id)initWithDictionary:(NSDictionary *)theDictionary formatKey:(BOOL)format
{

    if (!theDictionary) {
        return nil;
    }

    self = [self init];
    if (self) {
        if (format) {
            self.dictionary =
              [[NSMutableDictionary alloc] initWithDictionary:[NSString formatDicKeyToUnderLineName:theDictionary]];
        } else {
            self.dictionary =
              [[NSMutableDictionary alloc] initWithDictionary:theDictionary];
        }

#ifdef DEBUG
//        unsigned int outCount = 0;
//        objc_property_t *props = class_copyPropertyList([self class],
//            &outCount);
//
//        for (int i = 0; i < outCount; i++) {
//            objc_property_t property = props[i];
//            NSString *propertyName = [NSString stringWithCString:property_getName(property)
//                                          encoding:NSUTF8StringEncoding];
//
//            NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property)
//                                                encoding:NSUTF8StringEncoding];
//
//            id propertyValue = [self.dictionary objectForKey:propertyName];
//
//            if (propertyValue &&
//              ![propertyValue isEqual:[NSNull null]]) {
//
//                NSString *propertyAttributesType =
//                  [[propertyAttributes componentsSeparatedByString:@"\""] objectAtIndex:1];
//
//                if (![[propertyValue class] isSubclassOfClass:NSClassFromString(propertyAttributesType)])
//                {
//                    NSLog(@"Type of value for %@ is not ok", propertyName);
//                }
//            }
//        }
#endif /* ifdef DEBUG */

    }

    return self;
}

- (id)initWithDictionary:(NSDictionary *)theDictionary
{
    return [self initWithDictionary:theDictionary formatKey:YES];
}

- (id)initWithString:(NSString *)theJsonStr
{
    if (!theJsonStr || [theJsonStr length] <= 0) {
        return nil;
    }

    NSError *error = nil;
    NSMutableDictionary *dic = nil;

    dic =
      [NSJSONSerialization JSONObjectWithData:[theJsonStr dataUsingEncoding:NSUTF8StringEncoding]
           options:NSJSONReadingMutableContainers
           error:&error];

    if (!dic) {
        NSLog(@"Input string cannot convert to json object");
        if (error) {
            NSLog(@"Error is: %@", error);
        }
    } else {
        self = [self initWithDictionary:dic];
    }

    return self;
}

+ (id)objectWithString:(NSString *)theJsonStr
{
    id newInstance = [[[self class] alloc] initWithString:theJsonStr];

    return newInstance;
}


+ (id)objectWithDictionary:(NSDictionary *)theDictionary
{
    id newInstance = [[[self class] alloc] initWithDictionary:theDictionary];

    return newInstance;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSString *selectorName = NSStringFromSelector(selector);

    if ([selectorName rangeOfString:@"set"].location == 0) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }

    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}


- (void)forwardInvocation:(NSInvocation *)invocation
{

    NSString *selectorName = NSStringFromSelector([invocation selector]);

    NSString *key = nil;

    if ([selectorName rangeOfString:@"set"].location == 0) {
        key =
          [[selectorName substringWithRange:NSMakeRange(3, [selectorName length] -
                4)] underLineName];

        id __unsafe_unretained obj;
        [invocation getArgument:&obj atIndex:2];

        [self.dictionary setObject:obj ? obj : [NSNull null] forKey:key];
    } else {


        key = [selectorName underLineName];

        id obj = [self.dictionary objectForKey:key];
        [invocation setReturnValue:&obj];
    }
}


- (NSString *)description
{
    return [self.dictionary description];
}
#pragma mark - Public

- (NSString *)stringPrettyPrinted:(BOOL)prettyPrinted
{

    NSString *result = nil;

    if (self.dictionary) {
        NSError *error = nil;
        NSData *tempData = nil;
        tempData =
          [NSJSONSerialization dataWithJSONObject:self.dictionary
               options:prettyPrinted ? 0 : NSJSONWritingPrettyPrinted
               error:&error];

        if (!tempData) {
            NSLog(@"Cannot convert to data");
            if (error) {
                NSLog(@"Error is: %@", error);
            }
        } else {
            result =
              [[NSString alloc] initWithData:tempData
                   encoding:NSUTF8StringEncoding];

            return result;
        }

    }

    return result;
}


- (NSString *)string
{
    return [self stringPrettyPrinted:NO];
}

- (NSString *)prettyPrintedString
{

    return [self stringPrettyPrinted:YES];

}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder
{

    self = [super init];
    if (self != nil) {
        NSDictionary *dic = [coder decodeObjectForKey:@"dictionary"];
        self.dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{

    if (self.dictionary) {
        [coder encodeObject:self.dictionary forKey:@"dictionary"];
    } else {
        [coder encodeObject:@[] forKey:@"dictionary"];
    }
}
@end

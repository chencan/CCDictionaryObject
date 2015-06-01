//
//  NSString+PropertyName.m
//  tataUFO
//
//  Created by Can on 9/9/14.
//  Copyright (c) 2014 http://chencan.github.io. All rights reserved.
//

#import "NSString+PropertyName.h"

@implementation NSString (PropertyName)

- (NSString *)camelCaseName {
    NSMutableString *str = [NSMutableString stringWithString:self];
    NSUInteger len = [str length];
    
    for (int i = 0; i < len; i++) {
        char c = [str characterAtIndex:i];
        if (c == '_' && i + 1 < len) {
            char lowercase = [str characterAtIndex:i + 1];
            if (lowercase < 123 && lowercase >= 97) {
                char uppercaseChar = lowercase - 32;
                [str replaceCharactersInRange:NSMakeRange(i + 1, 1) withString:[NSString stringWithFormat:@"%c", uppercaseChar]];
                i++;
            }
        }
    }
    
    [str replaceOccurrencesOfString:@"_" withString:@"" options:0 range:NSMakeRange(0, len)];
    
    if ([str length] > 0) {
        char c = [str characterAtIndex:0];
        if (c < 91 && c >= 65) {
            [str replaceCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%c", c + 32]];
        }
    }
    
    return str;
    
}

- (NSString *)underLineName {
    
//    NSMutableString *str = [NSMutableString stringWithString:self];
//    NSUInteger len = [str length];
//    
//    NSMutableSet *set = [NSMutableSet set];
//    
//    for (int i = 0; i < len; i++) {
//        char c = [str characterAtIndex:i];
//        if (c < 91 && c >= 65) {
//            [set addObject:[NSString stringWithCharacters:(const unichar *)&c length:1]];
//        }
//    }
//    
//    NSEnumerator *enumerator = [set objectEnumerator];
//    id value;
//    
//    while ((value = [enumerator nextObject])) {
//        /* code that acts on the set’s values */
//        [str replaceOccurrencesOfString:value withString:[NSString stringWithFormat:@"_%@", value] options:0 range:NSMakeRange(0, [str length])];
//    }
//    
//    return str;

    NSMutableString *str = [self mutableCopy];

    NSUInteger len = [str length];
    
    NSMutableSet *set = [NSMutableSet set];
    
    for (int i = 0; i < len; i++) {
        char c = [str characterAtIndex:i];
        if (c < 91 && c >= 65) {
            [set addObject:[str substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    
    

    NSEnumerator *enumerator = [set objectEnumerator];
    id value;
    
    while ((value = [enumerator nextObject])) {
        /* code that acts on the set’s values */

        [str replaceOccurrencesOfString:value withString:[NSString stringWithFormat:@"_%@", [value lowercaseString]] options:0 range:NSMakeRange(0, [str length])];
    }
    
    [str replaceOccurrencesOfString:@"_" withString:@"" options:0 range:NSMakeRange(0, 1)];

    return str;
}



+ (NSDictionary *)formatDicKeyToUnderLineName:(NSDictionary *)dic {
    NSArray *allKey = [dic allKeys];
    
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    
    for (id key in allKey) {
        if ([key isKindOfClass:[NSString class]]) {
            [temp setObject:[dic objectForKey:key] forKey:[key underLineName]];
        }
    }
    
    return temp;
}

@end

//
//  DictionaryObjectContainer.m
//  tataUFO
//
//  Created by Can on 9/15/14.
//  Copyright (c) 2014 tataUFO.com. All rights reserved.
//

#import "DictionaryObjectContainer.h"

#import "NSString+PropertyName.h"

@implementation DictionaryObjectContainer

@dynamic start, total, limit, objClassName, objectName;




- (NSArray*)objectArray {
    NSMutableArray *objectArray = [NSMutableArray array];
    
    
    if (self.objectName) {
        NSArray *array = (NSArray *)[self.dictionary objectForKey:self.objectName];
        
        for (id dic in array) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                id object = [NSClassFromString(self.objClassName) objectWithDictionary:dic];
                [objectArray addObject:object];
            } else {
                [objectArray addObject:dic];
            }
        }
    }
    return objectArray;
}

- (id)arrayWithObjectArray:(NSArray *)objArray
              objClassName:(NSString *)objClassName
                objectName:(NSString *)objName
             needFormatKey:(BOOL)flag {
    
    NSMutableArray *newArray = [NSMutableArray array];
    for (id obj in objArray) {
        if ([obj isKindOfClass:[DictionaryObject class]]) {
            NSDictionary *objDic = [(DictionaryObject *)obj dictionary];
            [newArray addObject:objDic];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [newArray addObject:flag ? [NSString formatDicKeyTounderLineName:obj] : obj];
        }
    }
    
    
    return [self initWithDictionary:@{objName: newArray,
                                      @"obj_class_name" : objClassName,
                                      @"object_name" : objName}];
}

- (id)arrayWithObjectArray:(NSArray *)objArray
              objClassName:(NSString *)objClassName
                objectName:(NSString *)objName {
    return [self arrayWithObjectArray:objArray objClassName:objClassName objectName:objName needFormatKey:NO];
}


@end

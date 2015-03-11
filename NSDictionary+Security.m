//
//  NSDictionary+WTUtil.m
//  WeTennis
//
//  Created by alex zou on 13-7-6.
//  Copyright (c) 2013年 mobile. All rights reserved.
//

#import "NSDictionary+Security.h"

@implementation NSDictionary (Security)
- (id)objectForKey:(id)aKey inClass:(Class)classType {
	id object = [self objectForKey:aKey];
	if (object  == [NSNull null] || ![object isKindOfClass:classType]) {
		return nil;
	}
	return object;
}

@end

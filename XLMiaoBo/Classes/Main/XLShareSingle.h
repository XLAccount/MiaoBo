
//
//  XLShareSingle.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#ifndef XLShareSingle_h
#define XLShareSingle_h


#define XLSingletonH(name) + (instancetype)share##name;

#define XLSingletonM(name)\
static id _instance;\
+ (instancetype)share##name\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc] init];\
});\
return _instance;\
}\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
- (id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\



#endif /* XLShareSingle_h */

//
//  NSSafeObject.m
//  MiaowShow
//
//  Created by ALin on 16/6/16.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "NSSafeObject.h"
@interface NSSafeObject()
{
    __weak id _object;
    SEL _sel;
}
@end
@implementation NSSafeObject
- (instancetype)initWithObject:(id)object
{
    if (self = [super init]) {
        _object = object;
        _sel = nil;
    }
    return self;
}

- (instancetype)initWithObject:(id)object withSelector:(SEL)selector
{
    if(self = [super init])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            _object = object;
            _sel = selector;
        });
        
    }
    return self;
}

- (void)excute
{
    if (_object && _sel && [_object respondsToSelector:_sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_object performSelectorInBackground:_sel withObject:nil];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        NSOperation *o =[[NSOperation alloc] init];
        
        [queue addOperation:o];
        [queue addOperationWithBlock:^{
            
            [_object performSelector:_sel withObject:nil];

        }];
        
        
    #pragma clang diagnostic pop
    }
}

@end

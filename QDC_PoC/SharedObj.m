//
//  SharedObj.m
//  QDC_PoC
//
//  Created by Verve Technology Services PTE Ltd. on 20/06/16.
//  Copyright © 2016 Verve Technology Services PTE Ltd. All rights reserved.
//

#import "SharedObj.h"

@implementation SharedObj


+(id)sharedInstance {
    static SharedObj *sharedObj = nil;
    static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    sharedObj = [[self alloc] init];
});
    return sharedObj;
}

@end

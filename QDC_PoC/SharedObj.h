//
//  SharedObj.h
//  QDC_PoC
//
//  Created by Verve Technology Services PTE Ltd. on 20/06/16.
//  Copyright © 2016 Verve Technology Services PTE Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedObj : NSObject

@property (nonatomic, strong) NSString *selectedProject;

+(id)sharedInstance;

@end

//
//  ProjectDetails.h
//  QDC_PoC
//
//  Created by Verve Technology Services PTE Ltd. on 14/06/16.
//  Copyright © 2016 Verve Technology Services PTE Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectDetails : NSObject


@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) NSString *clientName;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *lastUpdatedBy;
@property (nonatomic, strong) NSString *lastUpdatedOn;
@property (nonatomic, strong) NSString *projectStatus;

@end

//
//  ProjectListingTableViewCell.h
//  QDC_PoC
//
//  Created by Verve Technology Services PTE Ltd. on 14/06/16.
//  Copyright © 2016 Verve Technology Services PTE Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectListingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectUpdatedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectStatusLabel;

@end

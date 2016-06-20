//
//  OverallStatusViewController.h
//  QDC_PoC
//
//  Created by Verve Technology Services PTE Ltd. on 16/06/16.
//  Copyright © 2016 Verve Technology Services PTE Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverallStatusViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

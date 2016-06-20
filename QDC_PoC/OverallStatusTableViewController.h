//
//  OverallStatusTableViewController.h
//  QDC_PoC
//
//  Created by Verve Technology Services PTE Ltd. on 17/06/16.
//  Copyright © 2016 Verve Technology Services PTE Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "PNPieChart.h"

@interface OverallStatusTableViewController : UITableViewController <XYPieChartDataSource, XYPieChartDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@property (strong, nonatomic) IBOutlet PNPieChart *pnPieChart;

@property (weak, nonatomic) IBOutlet UILabel *projectStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectCompletionPercLabel;
@property (weak, nonatomic) IBOutlet UITextField *projectCompPercTextField;

@property (weak, nonatomic) IBOutlet UITextField *actualStartDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *plannedStartDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *plannedEndDateTextField;

@property (weak, nonatomic) IBOutlet UITextField *expectedEndDateTextField;


@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *startEndDateDetailsLabel;

@end

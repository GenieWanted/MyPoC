//
//  OverallStatusTableViewController.m
//  QDC_PoC
//
//  Created by Verve Technology Services PTE Ltd. on 17/06/16.
//  Copyright © 2016 Verve Technology Services PTE Ltd. All rights reserved.
//

#import "OverallStatusTableViewController.h"
#import "ProjectInfoTableViewCell.h"
#import "ProjectDetailsTableViewCell.h"
#import "ProInfoTableViewCell.h"
#import "PNPieChart.h"
#import "PNColor.h"
#import "SharedObj.h"
#import "fmdb/FMDatabase.h"

@interface OverallStatusTableViewController () <UITextFieldDelegate> {
    NSArray *items;
    UIDatePicker *commonDatePicker;
    UITextField *currentFocusedTextField;
    NSString *footerNote;
    NSDictionary *projectDetails;
}
@property (weak, nonatomic) IBOutlet UITableViewCell *chartTableViewCell;

@end

@implementation OverallStatusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SharedObj *sharedObj = [SharedObj sharedInstance];
    
    NSLog(@"Selected Project Name is %@", sharedObj.selectedProject);
    footerNote = [NSString stringWithFormat:@"Project delayed by %ld days", (long)[self getNumberOfDaysBetween:self.plannedEndDateTextField.text and:self.expectedEndDateTextField.text]];

    self.projectNameLabel.text = sharedObj.selectedProject;

    self.projectCompPercTextField.delegate = self;
    self.plannedStartDateTextField.delegate = self;
    self.actualStartDateTextField.delegate = self;
    self.plannedEndDateTextField.delegate = self;
    self.expectedEndDateTextField.delegate = self;

    items = @[
                       [PNPieChartDataItem dataItemWithValue:(100 - self.projectCompPercTextField.text.intValue) color:[UIColor orangeColor] description:@"Completed"],
                       [PNPieChartDataItem dataItemWithValue:self.projectCompPercTextField.text.intValue color:PNGreen description:@"Remaining"],
                       ];
    
    
    

    [self.pnPieChart updateChartData:items];
    self.pnPieChart.descriptionTextColor = [UIColor whiteColor];
    self.pnPieChart.descriptionTextFont  = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
    [self.pnPieChart strokeChart];
    self.pnPieChart.center = CGPointMake(self.chartTableViewCell.bounds.size.width /4, self.chartTableViewCell.bounds.size.height/2);
    [self populateProjectDetails];

//    [self.chartTableViewCell.contentView addSubview:self.pnPieChart];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if(motion == UIEventSubtypeMotionShake) {

    }
}

#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 1)
        return footerNote;
    else
        return NULL;
}

#pragma mark - XYPieChart delegate methods

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return 2;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    return 40.0f;
}

-(void)updateTheChartWith:(NSInteger)completedVal {
    
    items = @[
              [PNPieChartDataItem dataItemWithValue:completedVal color:[UIColor orangeColor] description:@"Completed"],
              [PNPieChartDataItem dataItemWithValue:(100 - completedVal) color:PNGreen description:@"Remaining"],
              ];
    [self.pnPieChart updateChartData:items];
    [self.pnPieChart strokeChart];
    
}

-(void)handleInputForTextField:(UITextField *)textField {

    
    
}

- (IBAction)projectStatusLblTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select a Status" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *delayedAction = [UIAlertAction actionWithTitle:@"Delayed" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.projectStatusLabel.text = @"Delayed";
    }];
    UIAlertAction *inProgressAction = [UIAlertAction actionWithTitle:@"In Progress" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.projectStatusLabel.text = @"In Progress";
    }];
    UIAlertAction *completedAction = [UIAlertAction actionWithTitle:@"Completed" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.projectStatusLabel.text = @"Completed";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:delayedAction];
    [alertController addAction:inProgressAction];
    [alertController addAction:completedAction];
    
    [alertController addAction:cancelAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (IBAction)projectCompletionLevelLblTapped:(id)sender {
    
    
}



#pragma mark - UITextField delegate method implementation

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    currentFocusedTextField = textField;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnOnToolBarTapped)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    
    if([textField isEqual:self.projectCompPercTextField]) {      //Handling Done operation when the keyboard appears
        textField.inputAccessoryView = toolbar;
        UIBarButtonItem *doneBtnForPercentageField = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoneBtnOnPercentageField)];
        toolbar.items = @[cancelButton, flexSpace, doneBtnForPercentageField];
    }
    
    if([textField isEqual:self.plannedStartDateTextField] || [textField isEqual:self.actualStartDateTextField] || [textField isEqual:self.expectedEndDateTextField] || [textField isEqual:self.plannedEndDateTextField]) {
        commonDatePicker = [[UIDatePicker alloc] init];
        commonDatePicker.datePickerMode = UIDatePickerModeDate;

        textField.inputView = commonDatePicker;
        textField.inputAccessoryView = toolbar;
        UIBarButtonItem *doneBtnForDatePicker = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoneBtnOnDatePicker)];
        toolbar.items = @[cancelButton, flexSpace, doneBtnForDatePicker];
        }
}

-(NSInteger)getNumberOfDaysBetween:(NSString *)fromDate and:(NSString *)toDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSUInteger unit = NSCalendarUnitDay;
    
    NSDate *plannedStartDate = [dateFormatter dateFromString:fromDate];

    NSDate *plannedEndDate = [dateFormatter dateFromString:toDate];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:unit fromDate:plannedStartDate toDate:plannedEndDate options:0];
    NSInteger numOfDays = labs([comps day])+1;

    return numOfDays;
}


-(void)handleDoneBtnOnDatePicker {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/YYYY";
    NSString *date = [dateFormatter stringFromDate:commonDatePicker.date];
    NSLog(@"Date: %@", date);
    currentFocusedTextField.text = date;
    if([currentFocusedTextField isEqual:self.plannedEndDateTextField] || [currentFocusedTextField isEqual:self.expectedEndDateTextField])
    {
        footerNote = [NSString stringWithFormat:@"Project delayed by %ld days", (long)[self getNumberOfDaysBetween:self.plannedEndDateTextField.text and:self.expectedEndDateTextField.text]];
        [self.tableView reloadData];

    }
    [currentFocusedTextField resignFirstResponder];
    


}
-(NSDate *)getDatePickerValue:(UIDatePicker *)datePicker {
    return datePicker.date;
}

-(void)cancelBtnOnToolBarTapped {
    [self.view endEditing:YES];
}

-(void)doSomething {
    NSLog(@"Print something");
}

-(void)handleDoneBtnOnPercentageField {
    NSInteger enteredVal = [[self.projectCompPercTextField text] intValue];
    if(enteredVal > 100) {
        UIAlertController *maxAlertController = [UIAlertController alertControllerWithTitle:@"Cannot be more than 100%" message:@"This field cannot have value more than 100%" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [maxAlertController addAction:okAction];
        [self presentViewController:maxAlertController animated:YES completion:nil];
    }
    else {
    [self updateTheChartWith:enteredVal];
    [self.view endEditing:YES];
    }
}

-(void)populateProjectDetails {
    SharedObj *sharedObj = [SharedObj sharedInstance];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"UserDatabase" ofType:@"sqlite"]; // Accessing the pre-filled SQLiteDB here
    FMDatabase *database = [FMDatabase databaseWithPath:filePath];
    [database open];
    NSString *selectedProject = sharedObj.selectedProject;
   // NSString *query = [NSString stringWithFormat:@"SELECT * FROM ProjectListings WHERE PROJECTNAME == %@", selectedProject];
    FMResultSet *results = [database executeQuery:[NSString stringWithFormat:@"SELECT * FROM PROJECTLISTINGS WHERE PROJECTNAME = '%@'", selectedProject]];

    while ([results next]) {
        NSLog(@"Results : %@", results.resultDictionary);
        projectDetails = [NSDictionary dictionaryWithDictionary:results.resultDictionary];
        self.projectNameLabel.text = [results.resultDictionary valueForKey:@"projectName"];
        self.clientNameLabel.text = [results.resultDictionary valueForKey:@"clientName"];
        self.startEndDateDetailsLabel.text = [NSString stringWithFormat:@"%@ to %@", [results.resultDictionary valueForKey:@"startDate"], [results.resultDictionary valueForKey:@"endDate"]];
        self.lastUpdatedDetailsLabel.text = [NSString stringWithFormat:@"Last updated by %@ on %@", [results.resultDictionary valueForKey:@"lastUpdatedBy"], [results.resultDictionary valueForKey:@"lastUpdatedOn"]];
        self.projectStatusLabel.text = [results.resultDictionary valueForKey:@"projectHealthStatus"];

    }
    
    [database close];

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/* 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.tableView endEditing:YES];
}
- (IBAction)cancelBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

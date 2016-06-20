//
//  ProjectListingTableViewController.m
//  QDC_PoC
//
//  Created by Verve Technology Services PTE Ltd. on 13/06/16.
//  Copyright © 2016 Verve Technology Services PTE Ltd. All rights reserved.
//

#import "ProjectListingTableViewController.h"
#import "ProjectListingTableViewCell.h"
#import "ProjectDetails.h"
#import "FMDatabase.h"
#import "SharedObj.h"


@interface ProjectListingTableViewController () {
    NSMutableArray *projectDetailsArray;
}

@end

@implementation ProjectListingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    projectDetailsArray = [[NSMutableArray alloc] init];
    [self retrievedDatafromSQLite];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [projectDetailsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectListingTableViewCell *cell = (ProjectListingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProjectListingTableViewCell" forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProjectListingTableViewCell" owner:self options:nil].lastObject;
    }
    cell.projectNameLabel.text = [[projectDetailsArray valueForKey:@"projectName"] objectAtIndex:indexPath.row];
    cell.projectStatusLabel.text = [[projectDetailsArray valueForKey:@"projectStatus"] objectAtIndex:indexPath.row];
    cell.clientNameLabel.text = [[projectDetailsArray valueForKey:@"clientName"] objectAtIndex:indexPath.row];
    cell.projectDateLabel.text = [NSString stringWithFormat:@"%@ to %@", [[projectDetailsArray valueForKey:@"startDate"] objectAtIndex:indexPath.row], [[projectDetailsArray valueForKey:@"endDate"] objectAtIndex:indexPath.row]];
    cell.projectUpdatedByLabel.text = [NSString stringWithFormat:@"Last updated by %@ on %@", [[projectDetailsArray valueForKey:@"lastUpdatedBy"] objectAtIndex:indexPath.row], [[projectDetailsArray valueForKey:@"lastUpdatedOn"] objectAtIndex:indexPath.row]];
    if([cell.projectStatusLabel.text isEqualToString:@"On Going"])
        cell.projectStatusLabel.backgroundColor = [UIColor orangeColor];
    else if ([cell.projectStatusLabel.text isEqualToString:@"Completed"])
        cell.projectStatusLabel.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:191.0/255.0 blue:100.0/255.0 alpha:1.0];
    else if ([cell.projectStatusLabel.text isEqualToString:@"Pending"])
        cell.projectStatusLabel.backgroundColor = [UIColor redColor];
    return cell;
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)retrievedDatafromSQLite {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"UserDatabase" ofType:@"sqlite"]; // Accessing the pre-filled SQLiteDB here
    FMDatabase *database = [FMDatabase databaseWithPath:filePath];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT * FROM ProjectListings ORDER BY projectStatus DESC"]; // Orderby to show On going projects first

    while ([results next]) {
       // NSLog(@"%@", results.resultDictionary);
        ProjectDetails *projectDetails = [[ProjectDetails alloc] init];
        projectDetails.projectName = [results.resultDictionary valueForKey:@"projectName"];
        projectDetails.clientName = [results.resultDictionary valueForKey:@"clientName"];
        projectDetails.startDate = [results.resultDictionary valueForKey:@"startDate"];
        projectDetails.endDate = [results.resultDictionary valueForKey:@"endDate"];
        projectDetails.lastUpdatedBy = [results.resultDictionary valueForKey:@"lastUpdatedBy"];
        projectDetails.lastUpdatedOn = [results.resultDictionary valueForKey:@"lastUpdatedOn"];
        projectDetails.projectStatus = [results.resultDictionary valueForKey:@"projectStatus"];
        [projectDetailsArray addObject:projectDetails];
       // NSLog(@"%@", [projectDetailsArray valueForKey:@"projectName"]);
    }
    
    [database close];
    

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:1.0 animations:^{
        
    }];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Current Projects";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Tap a project to see the status";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectListingTableViewCell *selectedCell = (ProjectListingTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    SharedObj *sharedObj = [SharedObj sharedInstance];
    sharedObj.selectedProject = selectedCell.projectNameLabel.text;
}







@end

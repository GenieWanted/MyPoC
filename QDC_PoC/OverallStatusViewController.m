//
//  OverallStatusViewController.m
//  QDC_PoC
//
//  Created by Verve Technology Services PTE Ltd. on 16/06/16.
//  Copyright © 2016 Verve Technology Services PTE Ltd. All rights reserved.
//

#import "OverallStatusViewController.h"
#import "MainTabBarController.h"
#import "CompletedViewController.h"

@interface OverallStatusViewController ()

@end

@implementation OverallStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)handleSwipeGesture:(id)sender {
    NSLog(@"Swiped");
    
    [self.tabBarController setSelectedIndex:1];
    
}

#pragma mark - Table view related methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverallProjectStatusCell"];
    return cell;
}

@end

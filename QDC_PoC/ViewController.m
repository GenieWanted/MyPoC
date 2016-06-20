//
//  ViewController.m
//  QDC_PoC
//
//  Created by Verve Technology Services PTE Ltd. on 13/06/16.
//  Copyright © 2016 Verve Technology Services PTE Ltd. All rights reserved.
//

#import "ViewController.h"
#import "ProjectListingTableViewController.h"
#import "BIZCircularTransitionAnimator.h"
#import "BIZCircularTransitionHandler.h"
#import "KVNProgress.h"
#import "SharedObj.h"

@interface ViewController () {
    UIAlertController *loginAlertController;
}
@property (weak, nonatomic) IBOutlet UIView *clientView;
@property (weak, nonatomic) IBOutlet UIView *internalTeamView;
@property (nonatomic, strong) BIZCircularTransitionHandler *circularTransitionHandler;



@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UIImageView *titleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    titleImgView.contentMode = UIViewContentModeScaleAspectFit;
    [titleImgView setImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.titleView = titleImgView;
    
    UITapGestureRecognizer *clientTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clientButtonTapped:)];
    [self.clientView addGestureRecognizer:clientTapGesture];
    
    UITapGestureRecognizer *internalTeamTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(internalTeamTapped:)];
    [self.internalTeamView addGestureRecognizer:internalTeamTapGesture];

    self.circularTransitionHandler = [[BIZCircularTransitionHandler alloc] init];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clientButtonTapped:(UITapGestureRecognizer *)gesture {

    [self showLoginAlertWith:@"Client - Login"];
    
}

-(void)internalTeamTapped:(UITapGestureRecognizer *)gesture {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ProjectListingTableViewController *destinationVC = [storyboard instantiateViewControllerWithIdentifier:@"ProjectListingNavVC"];
    
    
    [self.circularTransitionHandler transitionWithDestinationViewController:destinationVC initialTransitionPoint:self.self.view.center];
    [self presentViewController:destinationVC animated:YES completion:nil];


    //[self showLoginAlertWith:@"Internal Team - Login"];
   
}

-(void)showLoginAlertWith:(NSString *)title {
    
    loginAlertController = [UIAlertController alertControllerWithTitle:title message:@"Please enter your login credentials" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([loginAlertController.textFields[0].text isEqualToString:@""] || [loginAlertController.textFields[1].text isEqualToString:@""]) {
            [KVNProgress showErrorWithStatus:@"Username or password cannot be empty"];
        }
        else {
        [KVNProgress showWithStatus:@"Logging in.."];
        [self performSelector:@selector(showSuccessSpinnerAfterDelay) withObject:nil afterDelay:1.5];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    [loginAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Username";
    }];
    
    [loginAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];

    [loginAlertController addAction:cancelAction];
    [loginAlertController addAction:loginAction];
    [self presentViewController:loginAlertController animated:YES completion:nil];
    
}

-(void)showSuccessSpinnerAfterDelay {
    
    NSString *userName = loginAlertController.textFields[0].text;
    NSString *password = loginAlertController.textFields[1].text;
    
    if(([userName isEqualToString:@"client"] && [password isEqualToString:@"client123"]) || ([userName isEqualToString:@"team"] && [password isEqualToString:@"team123"])) {
        
        // Success
            [KVNProgress showSuccessWithStatus:@"Login successfull!" completion:^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                ProjectListingTableViewController *destinationVC = [storyboard instantiateViewControllerWithIdentifier:@"ProjectListingNavVC"];
        
        
                [self.circularTransitionHandler transitionWithDestinationViewController:destinationVC initialTransitionPoint:self.self.view.center];
                [self presentViewController:destinationVC animated:YES completion:nil];
            }];
    }
    else {
        // Failure
        [KVNProgress showErrorWithStatus:@"Invalid credentials. Please check the username or password"];
    }
}

@end

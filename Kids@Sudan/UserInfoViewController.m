//
//  UserInfoViewController.m
//  Kids@Sudan
//
//  Created by Karthikeya Udupa K M on 21/11/2013.
//
//

#import "UserInfoViewController.h"
#import "ViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    for(UIView *v in self.view.subviews){
        if([v isKindOfClass:[UILabel class]]){
            [(UILabel *)v setFont:[UIFont fontWithName:@"KristenITC-Regular" size:18]];
        }
        
        if([v isKindOfClass:[UITextField class]]){
            [(UITextField *)v setFont:[UIFont fontWithName:@"KristenITC-Regular" size:16]];
        }
        
        if([v isKindOfClass:[UIButton class]]){
            [[(UIButton *)v titleLabel] setFont:[UIFont fontWithName:@"NewUnicodeFont" size:22]];
            [[(UIButton *)v layer] setCornerRadius:5];
        }

    }
    
    self.title = @"Kids@Sudan";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Go Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backButton;

    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitName:(id)sender {
    
    [userNameTextBox resignFirstResponder];
    if([[userNameTextBox text] length]){
        
        [[NSUserDefaults standardUserDefaults] setObject:userNameTextBox.text forKey:@"USER_NAME"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        ViewController *view = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        [self.navigationController pushViewController:view animated:YES];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Please enter your name.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil] show];
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
    
    
}
@end

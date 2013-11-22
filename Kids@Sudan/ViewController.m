//
//  ViewController.m
//  Kids@Sudan
//
//  Created by Karthikeya Udupa K M on 21/11/2013.
//
//

#import "ViewController.h"
#import "SubjectsViewController.h"
#import "AskMeViewController.h"
#import "QuizPageViewController.h"
#import "QuizListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    self.navigationController.navigationBar.translucent = NO;
    userNameLabel.text = [NSString stringWithFormat:@"Hi %@!",[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_NAME"]];
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Go Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backButton;
    
    for(UIView *v in self.view.subviews){
        if([v isKindOfClass:[UILabel class]]){
            [(UILabel *)v setFont:[UIFont fontWithName:@"NewUnicodeFont" size:30]];
        }
        
        if([v isKindOfClass:[UITextField class]]){
            [(UITextField *)v setFont:[UIFont fontWithName:@"KristenITC-Regular" size:16]];
        }
        
        if([v isKindOfClass:[UIButton class]]){
            [[(UIButton *)v titleLabel] setFont:[UIFont fontWithName:@"NewUnicodeFont" size:35]];
        }
        
    }
    
	// Do any additional setup after loading the view, typically from a nib.
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

- (IBAction)openSubjectSection:(id)sender {
    SubjectsViewController *subjects = [[SubjectsViewController alloc] initWithNibName:@"SubjectsViewController" bundle:nil];
    [self.navigationController pushViewController:subjects animated:YES];
    
}


- (IBAction)openAskMe:(id)sender {
    AskMeViewController *ask  = [[AskMeViewController alloc] initWithNibName:@"AskMeViewController" bundle:nil];
    [self.navigationController pushViewController:ask animated:YES];
    
}


- (IBAction)openQuiz:(id)sender {
    QuizListViewController *quiz  = [[QuizListViewController alloc] initWithNibName:@"QuizListViewController" bundle:nil];
    [self.navigationController pushViewController:quiz animated:YES];
    
}
@end

//
//  QuizViewerViewController.m
//  Kids@Sudan
//
//  Created by Karthikeya Udupa K M on 21/11/2013.
//
//

#import "QuizViewerViewController.h"

@interface QuizViewerViewController ()

@end

@implementation QuizViewerViewController

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
    [super viewDidLoad];
    currentQuestion = 0;
    score = 0;
    self.title = self.quiz.Quiz_name;
    [self updateUI];
    
    
    for(UIView *v in self.view.subviews){
        if([v isKindOfClass:[UILabel class]]){
            [(UILabel *)v setFont:[UIFont fontWithName:@"KristenITC-Regular" size:22]];
        }
        
        if([v isKindOfClass:[UITextField class]]){
            [(UITextField *)v setFont:[UIFont fontWithName:@"KristenITC-Regular" size:16]];
        }
        
        if([v isKindOfClass:[UIButton class]]){
            [[(UIButton *)v titleLabel] setFont:[UIFont fontWithName:@"NewUnicodeFont" size:22]];
        }
        
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)updateUI {
    
    questionLabel.text = [[self.quiz.Questions objectAtIndex:currentQuestion] Question];
    [opt1 setTitle:[[(MQuestion *)[self.quiz.Questions objectAtIndex:currentQuestion] Options] objectAtIndex:0] forState:UIControlStateNormal];
    [opt2 setTitle:[[(MQuestion *)[self.quiz.Questions objectAtIndex:currentQuestion] Options] objectAtIndex:1] forState:UIControlStateNormal];
    [opt3 setTitle:[[(MQuestion *)[self.quiz.Questions objectAtIndex:currentQuestion] Options] objectAtIndex:2] forState:UIControlStateNormal];
    [op4 setTitle:[[(MQuestion *)[self.quiz.Questions objectAtIndex:currentQuestion] Options] objectAtIndex:3] forState:UIControlStateNormal];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextQuestion:(id)sender {
    
    if(currentQuestion < [self.quiz.Questions count]-1){
        currentQuestion++;
        [self updateUI];
    }
    
}

- (IBAction)previousQuestion:(id)sender {
    if(currentQuestion > 0){
        currentQuestion--;
        [self updateUI];
    }
}

- (IBAction)answerSelected:(id)sender {
    
    NSInteger selected_answer = [sender tag];
    
    NSInteger correct_answer = [[[self.quiz.Questions objectAtIndex:currentQuestion] Correct_answer] integerValue];
    
    if(selected_answer==correct_answer-1){
        [[[UIAlertView alloc] initWithTitle:@"Your answer is correct!" message:@"" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        score++;
    }else{
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Sorry, the correct answer was %@",[[(MQuestion *)[self.quiz.Questions objectAtIndex:currentQuestion] Options] objectAtIndex:correct_answer-1]] message:@"" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    }
    
    if(currentQuestion < [self.quiz.Questions count]-1){
        currentQuestion++;
        [self updateUI];
    }else{
         [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You scored %d out of %d.",score,[self.quiz.Questions count]] message:@"" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        [self.navigationController popViewControllerAnimated:YES];
        ;    }

    
}




@end

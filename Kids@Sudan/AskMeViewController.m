//
//  AskMeViewController.m
//  Kids@Sudan
//
//  Created by Karthikeya Udupa K M on 21/11/2013.
//
//

#import "AskMeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "XMLReader.h"
#import "Reachability.h"
#import <MessageUI/MessageUI.h>

@interface AskMeViewController (){
    Reachability *internetReachableFoo;
}

@end

@implementation AskMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (IBAction)sendASKFeature:(id)sender {
    
    [askTextField resignFirstResponder];
    
    if([askTextField.text length]){
        
        
        
        internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        // Internet is reachable
        internetReachableFoo.reachableBlock = ^(Reachability*reach)
        {
            // Update the UI on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [askResponseTextView setText:@""];
                
                NSString *newString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)askTextField.text, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSISOLatin1StringEncoding)));
                NSString *url = [NSString stringWithFormat:@"http://api.wolframalpha.com/v2/query?appid=4EU37Y-TX9WJG3JH3&input=%@&format=plaintext",newString];
                
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                                     initWithRequest:request];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation
                                                           , id ro) {
                    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                    
                    //   NSString *content = [[NSString alloc] initWithData:ro encoding:NSUTF8StringEncoding];
                    NSInteger count = 0;
                    id parsedData = [XMLReader dictionaryForXMLData:ro error:nil];
                    if([parsedData valueForKey:@"queryresult"]){
                        if([[parsedData valueForKey:@"queryresult"] valueForKey:@"pod"]){
                            for(NSDictionary *d in [[parsedData valueForKey:@"queryresult"] valueForKey:@"pod"]){
                                if([d valueForKey:@"subpod"]){
                                    if([[d valueForKey:@"subpod"] valueForKey:@"plaintext"]){
                                        
                                        NSString *s  = [[d valueForKey:@"subpod"] valueForKey:@"plaintext"];
                                        if([s isKindOfClass:[NSString class]]){
                                            if(count>=2){
                                                [askResponseTextView setHidden:NO];
                                                [searchDetailButton setHidden:NO];
                                                return;
                                                
                                            }
                                            askResponseTextView.text = [[askResponseTextView text] stringByAppendingFormat:@"\n%@",[[s stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                                            count++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    // askResponseTextView.text = [[NSString alloc] initWithData:ro encoding:NSUTF8StringEncoding];
                    [askResponseTextView setHidden:NO];
                    [searchDetailButton setHidden:NO];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                    [[[UIAlertView alloc] initWithTitle:@"" message:@"Could not connect to the server." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                 ];
                [operation start];
                
            });
        };
        
        // Internet is not reachable
        internetReachableFoo.unreachableBlock = ^(Reachability*reach)
        {
            // Update the UI on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
                if([MFMessageComposeViewController canSendText])
                {
                    controller.body = askTextField.text;
                    controller.recipients = [NSArray arrayWithObjects:@"+441827231039", nil];
                    controller.messageComposeDelegate = self;
                    [self presentModalViewController:controller animated:YES];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
                }
                
            });
        };
        
        [internetReachableFoo startNotifier];
        
        
        
        

    
    }else{
         [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Please enter your question.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil] show];
    }
    
    //
}

- (IBAction)detailedHelp:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"" message:@"Your question has been sent to a tutor. You will be answered soon." delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    
}
- (void)viewDidLoad
{
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Ask Me";
    [super viewDidLoad];
    
    [[askResponseTextView layer] setBorderWidth:0.5];
    [[askResponseTextView layer] setBorderColor:[UIColor colorWithRed:.96 green:.55 blue:.09 alpha:0.5].CGColor];
    [[askResponseTextView layer] setCornerRadius:5.0];
    
    [[askTextField layer] setBorderWidth:0.5];
    [[askTextField layer] setBorderColor:[UIColor colorWithRed:.96 green:.55 blue:.09 alpha:0.5].CGColor];
    [[askTextField layer] setCornerRadius:5.0];
    
    
    for(UIView *v in self.view.subviews){
        if([v isKindOfClass:[UILabel class]]){
            [(UILabel *)v setFont:[UIFont fontWithName:@"KristenITC-Regular" size:18]];
        }
        
        if([v isKindOfClass:[UITextField class]]){
            [(UITextField *)v setFont:[UIFont fontWithName:@"KristenITC-Regular" size:16]];
        }
        
        if([v isKindOfClass:[UITextView class]] && [v tag]==101){
            [(UITextView *)v setFont:[UIFont fontWithName:@"KristenITC-Regular" size:18]];
        }
        
        if([v isKindOfClass:[UIButton class]]){
            [[(UIButton *)v titleLabel] setFont:[UIFont fontWithName:@"NewUnicodeFont" size:22]];
            [[(UIButton *)v layer] setCornerRadius:5];
        }
        
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end

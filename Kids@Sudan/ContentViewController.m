//
//  ContentViewController.m
//  Kids@Sudan
//
//  Created by Karthikeya Udupa K M on 21/11/2013.
//
//

#import "ContentViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "LessonList.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

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
    self.title = self.lesson.Lesson_name;
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[self.lesson.Lesson_URL lastPathComponent]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    [self.webView setScalesPageToFit:YES];
    if(!fileExists){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"Loading";
       
        
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.lesson.Lesson_URL]];
    AFURLConnectionOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[self.lesson.Lesson_URL lastPathComponent]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
         hud.progress = (float)totalBytesRead / totalBytesExpectedToRead;
    }];
    
    [operation setCompletionBlock:^{
        NSLog(@"downloadComplete!");
        [hud hide:YES];
        
        [self loadFile];
    }];
    [operation start];
    }else{
        [self loadFile];
    }
    
}

- (void)loadFile {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[self.lesson.Lesson_URL lastPathComponent]];


    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webView loadRequest:request];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Lesson 1";
    
    
        
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

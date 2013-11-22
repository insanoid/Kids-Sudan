//
//  ClassesViewController.m
//  Kids@Sudan
//
//  Created by Karthikeya Udupa K M on 21/11/2013.
//
//

#import "ClassesViewController.h"
#import "ContentViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface ClassesViewController ()

@end

@implementation ClassesViewController

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
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Classes";
    
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Go Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    // Do any additional setup after loading the view from its nib.
    [self loadSectionContent];
}

- (void)loadSectionContent {
    
    DataManager *dbManager = [[DataManager alloc] init];
    NSString *articleJSON = [dbManager getSectionJSON:self.subject_id];
    [dbManager destoryDatabase];
    
    if(articleJSON){
        NSDictionary *JSON =
        [NSJSONSerialization JSONObjectWithData: [articleJSON dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: nil];
        
        lessonList = [LessonList objectWithDictionary:JSON];
         [subjectsTableView reloadData];
    }else{
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://insanoid.apiary.io/lessons?subject_id=%d",self.subject_id]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation
                                               , id ro) {
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:ro options:NSJSONReadingAllowFragments error:nil];
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        lessonList = [LessonList objectWithDictionary:responseObject];
        [self handleCategorySuccess:responseObject];
        [subjectsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Could not connect to the server." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
     ];
    [operation start];
    
}

- (void)handleCategorySuccess:(id)object {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        DataManager *dbManager = [[DataManager alloc] init];
        [dbManager putSectionJSON:jsonString forSectionId:self.subject_id];
        [dbManager destoryDatabase];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [tableView setSeparatorColor:[UIColor colorWithRed:.96 green:.55 blue:.09 alpha:0.5]];
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [lessonList.Lessons count];
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ContentCell";
    UITableViewCell *cell = [[UITableViewCell
                              alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ContentCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:2];
    }
    
    cell.textLabel.text = [(MLesson *)[lessonList.Lessons objectAtIndex:indexPath.row] Lesson_name];
    cell.textLabel.font = [UIFont fontWithName:@"NewUnicodeFont" size:22];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowRight~iPhone.png"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContentViewController *content = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    [content setLesson:[lessonList.Lessons objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:content animated:YES];
}

@end

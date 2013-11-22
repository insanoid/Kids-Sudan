//
//  SubjectsViewController.m
//  Kids@Sudan
//
//  Created by Karthikeya Udupa K M on 21/11/2013.
//
//

#import "SubjectsViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

@interface SubjectsViewController ()

@end

@implementation SubjectsViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Subjects";
    
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Go Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [self loadSectionContent];
}

- (void)loadSectionContent {
    
    DataManager *dbManager = [[DataManager alloc] init];
    NSString *articleJSON = [dbManager getSectionJSON:-99];
    [dbManager destoryDatabase];
   
    if(articleJSON){
        NSDictionary *JSON =
        [NSJSONSerialization JSONObjectWithData: [articleJSON dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: nil];
        
        subjects = [SubjectList objectWithDictionary:JSON];
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://insanoid.apiary.io/subjects"]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation
                                               , id ro) {
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:ro options:NSJSONReadingAllowFragments error:nil];
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        subjects = [SubjectList objectWithDictionary:responseObject];
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
            [dbManager putSectionJSON:jsonString forSectionId:-99];
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
    
    return [subjects.Subjects count];
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
    
    cell.textLabel.font = [UIFont fontWithName:@"NewUnicodeFont" size:22];
    cell.textLabel.text = [(Subject *)[subjects.Subjects objectAtIndex:indexPath.row] Subject_name];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowRight~iPhone.png"]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassesViewController *class = [[ClassesViewController alloc] initWithNibName:@"ClassesViewController" bundle:nil];
    class.subject_id = [[(Subject *)[subjects.Subjects objectAtIndex:indexPath.row] Subject_id] integerValue];
    [self.navigationController pushViewController:class animated:YES];
}

@end

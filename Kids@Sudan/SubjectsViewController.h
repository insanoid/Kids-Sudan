//
//  SubjectsViewController.h
//  Kids@Sudan
//
//  Created by Karthikeya Udupa K M on 21/11/2013.
//
//

#import <UIKit/UIKit.h>
#import "ClassesViewController.h"
#import "DatabaseHandler.h"
#import "DataManager.h"
#import "Subjects.h"

@interface SubjectsViewController : UIViewController {
    
    SubjectList *subjects;
    IBOutlet __weak UITableView *subjectsTableView;
    
}

@end

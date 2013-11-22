//
//  ClassesViewController.h
//  Kids@Sudan
//
//  Created by Karthikeya Udupa K M on 21/11/2013.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "DatabaseHandler.h"
#import "LessonList.h"

@interface ClassesViewController : UIViewController
{
    LessonList *lessonList;
    IBOutlet __weak UITableView *subjectsTableView;
}
@property(nonatomic,assign) NSInteger subject_id;
@end

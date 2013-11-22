//
//  QuizListViewController.h
//  Kids@Sudan
//
//  Created by Karthikeya Udupa K M on 21/11/2013.
//
//

#import <UIKit/UIKit.h>
#import "QuizList.h"

@interface QuizListViewController : UIViewController
{
    
    QuizList *quizList;
    IBOutlet __weak UITableView *subjectsTableView;
}
@end

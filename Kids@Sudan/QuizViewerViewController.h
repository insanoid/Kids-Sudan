//
//  QuizViewerViewController.h
//  Kids@Sudan
//
//  Created by Karthikeya Udupa K M on 21/11/2013.
//
//

#import <UIKit/UIKit.h>
#import "QuizList.h"

@interface QuizViewerViewController : UIViewController
{
    IBOutlet UIButton *opt1, *opt2, *opt3, *op4;
    IBOutlet UILabel *questionLabel;
    int currentQuestion;
    int score;
}

@property (nonatomic, retain) MQuize *quiz;
@end

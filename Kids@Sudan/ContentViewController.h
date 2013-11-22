//
//  ContentViewController.h
//  Kids@Sudan
//
//  Created by Karthikeya Udupa K M on 21/11/2013.
//
//

#import <UIKit/UIKit.h>
#import "LessonList.h"

@interface ContentViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) MLesson* lesson;

@end

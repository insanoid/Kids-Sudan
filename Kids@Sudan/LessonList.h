
#import <Foundation/Foundation.h>


@class MLesson;

@interface LessonList : NSObject
{
    NSMutableArray * Lessons;
}

@property(nonatomic,retain) NSMutableArray * Lessons;

+ (id) objectWithDictionary:(NSDictionary*)dictionary;
- (id) initWithDictionary:(NSDictionary*)dictionary;

@end


@interface MLesson : NSObject
{
    NSString * Lesson_name;
    NSString * Lesson_URL;
    NSNumber * Lesson_id;
}
@property(nonatomic,retain) NSString * Lesson_URL;
@property(nonatomic,retain) NSString * Lesson_name;
@property(nonatomic,retain) NSNumber * Lesson_id;

+ (id) objectWithDictionary:(NSDictionary*)dictionary;
- (id) initWithDictionary:(NSDictionary*)dictionary;

@end

//JsonModel.h End

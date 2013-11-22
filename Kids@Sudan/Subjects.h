
#import <Foundation/Foundation.h>


@class Subject;

@interface SubjectList : NSObject
{
    NSMutableArray * Subjects;
}

@property(nonatomic,retain) NSMutableArray * Subjects;

+ (id) objectWithDictionary:(NSDictionary*)dictionary;
- (id) initWithDictionary:(NSDictionary*)dictionary;

@end


@interface Subject : NSObject
{
    NSString * Subject_name;
    NSNumber * Subject_id;
}

@property(nonatomic,retain) NSString * Subject_name;
@property(nonatomic,retain) NSNumber * Subject_id;

+ (id) objectWithDictionary:(NSDictionary*)dictionary;
- (id) initWithDictionary:(NSDictionary*)dictionary;

@end

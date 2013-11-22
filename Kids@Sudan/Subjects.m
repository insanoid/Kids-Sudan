//
// JsonModel.m


#import "Subjects.h"



@implementation SubjectList

@synthesize Subjects;

+ (id) objectWithDictionary:(NSDictionary*)dictionary
{
    id obj = [[SubjectList alloc] initWithDictionary:dictionary];
    return obj;
}

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    self=[super init];
    if(self)
    {
        
        NSArray* temp =  [dictionary objectForKey:@"subjects"];
        Subjects =  [[NSMutableArray alloc] init];
        for (NSDictionary *d in temp) {
            [Subjects addObject:[Subject objectWithDictionary:d]];
        }
    }
    return self;
}


@end


@implementation Subject

@synthesize Subject_name;
@synthesize Subject_id;


+ (id) objectWithDictionary:(NSDictionary*)dictionary
{
    id obj = [[Subject alloc] initWithDictionary:dictionary];
    return obj;
}

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    self=[super init];
    if(self)
    {
        Subject_name = [dictionary objectForKey:@"subject_name"];
        Subject_id = [dictionary objectForKey:@"subject_id"];
    }
    return self;
}


@end

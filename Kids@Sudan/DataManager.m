#import "DataManager.h"

@implementation DataManager
@synthesize databaseHandler;

// Initalizes the datamanager.
- (id)init {
	if ((self = [super init])) {
		databaseHandler = [[DatabaseHandler alloc] initWithDynamicFile:@"Local_DB"];
	}
	return self;
}

#pragma mark -

- (NSString *)getSectionJSON:(NSInteger)articleId {
    
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT Section_JSON FROM Sections WHERE Section_ID='%d'",articleId];
	NSArray *returnArray  = [[NSArray alloc] initWithArray:[databaseHandler lookupAllForSQL:sql]];
    if([returnArray count]){
        return [[returnArray objectAtIndex:0] valueForKey:@"Section_JSON"];
    }else{
        return nil;
    }
    
}


- (void)putSectionJSON:(NSString *)contentJSON forSectionId:(NSInteger)articleId {
    
    [databaseHandler runDynamicSQL:[NSString stringWithFormat:@"DELETE FROM Sections WHERE Section_ID='%d'",articleId] forTable:@"Sections"];
    [databaseHandler insertDictionary:@{@"Section_JSON":contentJSON,@"Section_ID":[NSString stringWithFormat:@"%d",articleId]} forTable:@"Sections"];
    
}


#pragma mark -

- (void)destoryDatabase {
    
   [databaseHandler close]; 
}

- (void)destroyConnection {
    [databaseHandler close];
}

@end
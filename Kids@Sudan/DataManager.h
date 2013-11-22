//
//  DataManager.h
//
//
//  Created by User on 04/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseHandler.h"


//Class to handle database queries.
@interface DataManager : NSObject {
	
	DatabaseHandler *databaseHandler;
}

@property(nonatomic, retain) DatabaseHandler *databaseHandler;

- (void)destroyConnection;
- (void)destoryDatabase;
- (NSString *)getArticleJSON:(NSInteger)articleId;
- (void)putArticleJSON:(NSString *)contentJSON forArticleId:(NSInteger)articleId;
- (void)putHomeJSON:(NSString *)contentJSON forHomeId:(NSInteger)articleId;
- (NSString *)getHomeJSON:(NSInteger)HomeId;
- (void)putSectionJSON:(NSString *)contentJSON forSectionId:(NSInteger)articleId;
- (NSString *)getSectionJSON:(NSInteger)articleId;
@end
//
//  Video.h
//  Delicious
//
//  Created by Vinh Nguyen on 7/16/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Video : NSManagedObject

@property (nonatomic, retain) NSString * channelVideo;
@property (nonatomic, retain) NSString * idVideo;
@property (nonatomic, retain) NSString * thumbnailVideo;
@property (nonatomic, retain) NSString * timeVideo;
@property (nonatomic, retain) NSString * titleVideo;

@end

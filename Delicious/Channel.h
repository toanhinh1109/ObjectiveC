//
//  Channel.h
//  Delicious
//
//  Created by Vinh Nguyen on 7/15/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Channel : NSManagedObject

@property (nonatomic, retain) NSString * timeChannel;
@property (nonatomic, retain) NSString * idChannel;
@property (nonatomic, retain) NSString * titleChannel;
@property (nonatomic, retain) NSString * thumbnailChannel;

//- (id)initChannelWithidChannel:(NSString*)idChannel titleChannel:(NSString*)titleChannel thumbnailChannel:(NSString*)thumbnailChannel timeChannel:(NSString*)timeChannel managedObjectContext:(NSManagedObjectContext*)context;

@end

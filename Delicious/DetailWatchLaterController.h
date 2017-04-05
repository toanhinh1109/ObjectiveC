//
//  DetailWatchLaterController.h
//  Delicious
//
//  Created by Vinh Nguyen on 7/16/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import <Social/Social.h>
#import <CoreData/CoreData.h>

@interface DetailWatchLaterController : UIViewController<YTPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet YTPlayerView *playerWatchLaterVideo;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *remainTime;
@property (weak, nonatomic) IBOutlet UISlider *slider;
- (IBAction)onSliderChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailVideo;
@property (weak, nonatomic) IBOutlet UILabel *titleVideo;
@property (weak, nonatomic) IBOutlet UILabel *channelVideo;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)playVideo:(id)sender;
- (IBAction)shareFB:(id)sender;
- (IBAction)favoriteVideo:(id)sender;

@property BOOL played;

@property (strong,nonatomic) NSString *thumbnailVD;
@property (strong,nonatomic) NSString *titleVD;
@property (strong,nonatomic) NSString *channelVD;
@property (strong,nonatomic) NSString *idVD;
@property (strong,nonatomic) NSString *timeVD;

@end

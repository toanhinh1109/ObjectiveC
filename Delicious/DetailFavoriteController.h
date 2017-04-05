//
//  DetailFavoriteController.h
//  Delicious
//
//  Created by Vinh Nguyen on 7/16/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import <Social/Social.h>
#import <CoreData/CoreData.h>

@interface DetailFavoriteController : UIViewController<YTPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *remainTime;
@property (weak, nonatomic) IBOutlet UISlider *slider;
- (IBAction)onSliderChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *watchLaterButton;
@property (weak, nonatomic) IBOutlet YTPlayerView *playerFavoriteVideo;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailVideo;
@property (weak, nonatomic) IBOutlet UILabel *titleVideo;
@property (weak, nonatomic) IBOutlet UILabel *channelVideo;

- (IBAction)playVideo:(id)sender;
- (IBAction)watchLaerVideo:(id)sender;
- (IBAction)shareFB:(id)sender;

@property BOOL played;

@property (strong,nonatomic) NSString *thumbnailVD;
@property (strong,nonatomic) NSString *titleVD;
@property (strong,nonatomic) NSString *channelVD;
@property (strong,nonatomic) NSString *idVD;
@property (strong,nonatomic) NSString *timeVD;

@end

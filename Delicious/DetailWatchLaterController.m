//
//  DetailWatchLaterController.m
//  Delicious
//
//  Created by Vinh Nguyen on 7/16/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import "DetailWatchLaterController.h"

@interface DetailWatchLaterController ()

@end

@implementation DetailWatchLaterController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateSelected];
    [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"disFavorite.png"] forState:UIControlStateSelected];
    
    self.playerWatchLaterVideo.delegate = self;
    NSDictionary *playerVars = @{
                                 @"controls" : @0,
                                 @"playsinline" : @1,
                                 @"autohide" : @1,
                                 @"showinfo" : @0,
                                 @"modestbranding" : @1                                 };
    [self.playerWatchLaterVideo loadWithVideoId:self.idVD playerVars:playerVars];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view .backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black.jpg"]];
    [self.thumbnailVideo setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbnailVD]]]];
    [self.titleVideo setText:self.titleVD];
    [self.channelVideo setText:self.channelVD];
    self.slider.value = 0;
    [self.currentTime setText:@"0:00"];
    [self.remainTime setText:@"-0:00"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleNetworkStatusNotification" object:nil];

}

-(void)viewDidDisappear:(BOOL)animated{
    [self.playerWatchLaterVideo pauseVideo];
}

-(void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime{
    float progress = playTime/self.playerWatchLaterVideo.duration;
    [self.slider setValue:progress];
    float remainTime = self.playerWatchLaterVideo.duration - self.playerWatchLaterVideo.currentTime ;
    self.currentTime.text = [NSString stringWithFormat:@"%@",[self timeFormat:self.playerWatchLaterVideo.currentTime]];
    self.remainTime.text = [NSString stringWithFormat:@"-%@",[self timeFormat:remainTime]];
    float timeCount = self.playerWatchLaterVideo.duration - playTime;
    NSLog(@"%f",timeCount);
    
    if (timeCount<1&& timeCount>0) {
        timeCount = 0.0f;
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSManagedObject *newVideo = [NSEntityDescription insertNewObjectForEntityForName:@"VideoHistory" inManagedObjectContext:context];
        
        [newVideo setValue:self.titleVD forKey:@"titleVideo"];
        [newVideo setValue:self.idVD forKey:@"idVideo"];
        [newVideo setValue:self.thumbnailVD forKey:@"thumbnailVideo"];
        [newVideo setValue:self.timeVD forKey:@"timeVideo"];
        [newVideo setValue:self.channelVD forKey:@"channelVideo"];
        [newVideo setValue:[NSDate date] forKey:@"timeStamp"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        NSLog(@"Save Video History successful!!!!");
        [self.playerWatchLaterVideo pauseVideo];
        self.slider.value=0;
        [self.remainTime setText:@"-0:00"];
    }
    
}

- (NSString *)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = (int)lroundf(seconds);
    int roundedMinutes = (int)lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%02d:%02d",
                      roundedMinutes, roundedSeconds];
    return time;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}- (IBAction)playVideo:(id)sender {
    if(!self.played){
        [self.playButton setSelected:NO];
        [self.playerWatchLaterVideo playVideo];
        self.played = YES;
    }
    else
    {
        [self.playButton setSelected:YES];
        [self.playerWatchLaterVideo pauseVideo];
        self.played = NO;
    }
    

}

- (IBAction)shareFB:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *controller =
        [SLComposeViewController
         composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:@"Các món ăn ngon đây"];
        [controller addURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",self.idVD]]];
        controller.completionHandler = ^(SLComposeViewControllerResult result){
            NSLog(@"Completed");
        };
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        NSLog(@"The FB service is not available");
    }
    

}

- (IBAction)favoriteVideo:(id)sender {
    [self.favoriteButton setSelected:NO];
    NSLog(@"FAVORITE");
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *newVideo = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:context];
    
    [newVideo setValue:self.titleVD forKey:@"titleVideo"];
    [newVideo setValue:self.idVD forKey:@"idVideo"];
    [newVideo setValue:self.thumbnailVD forKey:@"thumbnailVideo"];
    [newVideo setValue:self.timeVD forKey:@"timeVideo"];
    [newVideo setValue:self.channelVD forKey:@"channelVideo"];
    
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    NSLog(@"Save video Watch later successful");

}
- (IBAction)onSliderChanged:(id)sender {
    float seekToTime = self.playerWatchLaterVideo.duration * self.slider.value;
    [self.playerWatchLaterVideo seekToSeconds:seekToTime allowSeekAhead:YES];
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            [self.playButton setSelected:NO];
            self.played = YES;
            NSLog(@"%f",self.playerWatchLaterVideo.currentTime );
            NSLog(@"%f",self.playerWatchLaterVideo.duration);
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            [self.playButton setSelected:YES];
            self.played = NO;
            //            NSLog(@"%f",self.playerView.currentTime );
            //            NSLog(@"%f",self.playerView.duration);
            break;
        default:
            break;
    }
}

@end

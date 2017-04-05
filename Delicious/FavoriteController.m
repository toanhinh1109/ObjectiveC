//
//  FavoriteController.m
//  Delicious
//
//  Created by Vinh Nguyen on 7/16/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import "FavoriteController.h"
static NSString *cellChannelID=@"cellChannelID";

@interface FavoriteController ()
{
    NSString *idVD;
    NSString *thumbnailVD;
    NSString *titleVD;
    NSString *channelVD;
    NSString *timeVD;
}
@property (strong) NSMutableArray *videos;

@end

@implementation FavoriteController

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
     [self.favoriteTableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:cellChannelID];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.favoriteTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black.jpg"]];
    self.view.backgroundColor = [UIColor yellowColor];
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Video"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"titleVideo" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];

    self.videos = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleNetworkStatusNotification" object:nil];

    [self.favoriteTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Datasource tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.videos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCell *cell= [tableView dequeueReusableCellWithIdentifier:cellChannelID];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:cellChannelID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellChannelID];
    }
    NSManagedObject *videos = [self.videos objectAtIndex:indexPath.row];
    
    cell.channelTitle.text = [NSString stringWithFormat:@"%@",[videos valueForKey:@"titleVideo" ]];
    cell.channelID.text = [NSString stringWithFormat:@"%@",[videos  valueForKey:@"timeVideo"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[videos valueForKey:@"thumbnailVideo"]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.channelImage.image = [UIImage imageWithData:imageData];
            
        });
    });
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

#pragma Delegate tableView

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.videos objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.videos removeObjectAtIndex:indexPath.row];
        [self.favoriteTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSManagedObject *videos = [self.videos objectAtIndex:indexPath.row];
    idVD= [videos valueForKey:@"idVideo"];
    titleVD= [videos valueForKey:@"titleVideo"];
    thumbnailVD= [videos valueForKey:@"thumbnailVideo"];
    channelVD= [videos valueForKey:@"channelVideo"];
    timeVD=[videos valueForKey:@"timeVideo"];
//    NSLog(@"%@",[videos valueForKey:@"idChannel"]);
    [self performSegueWithIdentifier:@"segueFavorite" sender:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    
    if ([segue.identifier isEqualToString:@"segueFavorite"]) {
        DetailFavoriteController *detailFavorite = [segue destinationViewController];
        detailFavorite.idVD=idVD;
        detailFavorite.thumbnailVD= thumbnailVD;
        detailFavorite.titleVD= titleVD;
        detailFavorite.channelVD= channelVD;
        detailFavorite.timeVD=timeVD;
           }
    
}

@end

//
//  DHAddedAnimationsTableViewController.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 28/09/2016.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAddedAnimationsTableViewController.h"
#import "DHAnimation.h"
#import "DHObjectAnimationSettingsTableViewController.h"
@interface DHAddedAnimationsTableViewController ()
@property (nonatomic, strong) DHObjectAnimationSettingsTableViewController *settingsController;
@end

@implementation DHAddedAnimationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.addedAnimations count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddedAnimationsCell" forIndexPath:indexPath];
    DHAnimation *animation = self.addedAnimations[indexPath.row];
    cell.textLabel.text = [animation description];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DHAnimation *animation = self.addedAnimations[indexPath.row];
    self.settingsController.settings = animation.settings;
    [self.navigationController pushViewController:self.settingsController animated:YES];
}

- (DHObjectAnimationSettingsTableViewController *) settingsController
{
    if (!_settingsController) {
        _settingsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"DHObjectAnimationSettingsTableViewController"];
    }
    return _settingsController;
}
@end

//
//  DHBuiltOutAnimationTypeChooseTableViewController.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/19/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHBuiltOutAnimationTypeChooseTableViewController.h"
#import "DHAnimationFactory.h"
#import "DHObjectAnimationSettingsTableViewController.h"
@interface DHBuiltOutAnimationTypeChooseTableViewController ()
@property (nonatomic) DHObjectAnimationType selectedAnimation;

@end

@implementation DHBuiltOutAnimationTypeChooseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[DHAnimationFactory builtOutAnimations] count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuitOutAnimationsCell" forIndexPath:indexPath];
    cell.textLabel.text = [DHAnimationFactory builtInAnimations][indexPath.row];
    return cell;
    
}

//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    self.selectedAnimation = [DHAnimationFactory animationTypeForName:cell.textLabel.text];
//    DHObjectAnimationPresentationViewController *presentationViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DHObjectAnimationPresentationViewController"];
//    presentationViewController.animations = [@[@(self.selectedAnimation)] mutableCopy];
//    presentationViewController.event = DHAnimationEventBuiltOut;
//    [self.navigationController pushViewController:presentationViewController animated:YES];
//}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"settingsSegue"]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
        self.selectedAnimation = [DHAnimationFactory animationTypeForName:cell.textLabel.text];
        DHObjectAnimationSettingsTableViewController *settingsController = (DHObjectAnimationSettingsTableViewController *)segue.destinationViewController;
    }
}
@end

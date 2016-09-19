//
//  DHBuiltInAnimationTypeChooseTableViewController.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/13/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHBuiltInAnimationTypeChooseTableViewController.h"
#import "DHAnimationFactory.h"
#import "DHObjectAnimationPresentationViewController.h"
@interface DHBuiltInAnimationTypeChooseTableViewController ()
@property (nonatomic) DHObjectAnimationType selectedAnimation;
@end

@implementation DHBuiltInAnimationTypeChooseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[DHAnimationFactory builtInAnimations] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuitInAnimationsCell" forIndexPath:indexPath];
    cell.textLabel.text = [DHAnimationFactory builtInAnimations][indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedAnimation = [DHAnimationFactory animationTypeForName:cell.textLabel.text];
    DHObjectAnimationPresentationViewController *presentationViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DHObjectAnimationPresentationViewController"];
    presentationViewController.animations = [@[@(self.selectedAnimation)] mutableCopy];
    [self.navigationController pushViewController:presentationViewController animated:YES];
}

@end
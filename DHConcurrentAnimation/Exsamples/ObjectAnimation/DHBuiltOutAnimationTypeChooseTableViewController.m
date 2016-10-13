//
//  DHBuiltOutAnimationTypeChooseTableViewController.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/19/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHBuiltOutAnimationTypeChooseTableViewController.h"
#import "DHAnimationFactory.h"
#import "DHObjectAnimationPresentationViewController.h"
#import "DHAddedAnimationsTableViewController.h"

@interface DHBuiltOutAnimationTypeChooseTableViewController ()
@property (nonatomic) DHObjectAnimationType selectedAnimation;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *addedAnimations;
@property (nonatomic, strong) UINavigationController *addedAnimationNavigationViewController;
@property (nonatomic, strong) DHAddedAnimationsTableViewController *addedAnimationsTableViewController;

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
    cell.textLabel.text = [DHAnimationFactory builtOutAnimations][indexPath.row];
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *animationName = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    DHObjectAnimationType animationType = [DHAnimationFactory animationTypeForName:animationName];
    DHAnimation *animation = [DHAnimationFactory animationOfType:animationType event:DHAnimationEventBuiltOut forTarget:nil animationView:nil];
    [self.addedAnimations addObject:animation];
}

- (NSMutableArray *) addedAnimations
{
    if (!_addedAnimations) {
        _addedAnimations = [NSMutableArray array];
    }
    return _addedAnimations;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PlayAnimation"]) {
        DHObjectAnimationPresentationViewController *presentationViewController = (DHObjectAnimationPresentationViewController *)segue.destinationViewController;
        presentationViewController.animations = self.addedAnimations;
    }
}

- (IBAction)showAddedAnimations:(id)sender {
    self.addedAnimationsTableViewController.addedAnimations = self.addedAnimations;
    [self presentViewController:self.addedAnimationNavigationViewController animated:YES completion:nil];
}

- (UINavigationController *) addedAnimationNavigationViewController
{
    if (!_addedAnimationNavigationViewController) {
        _addedAnimationNavigationViewController = [[UINavigationController alloc] initWithRootViewController:self.addedAnimationsTableViewController];
    }
    return _addedAnimationNavigationViewController;
}

- (DHAddedAnimationsTableViewController *) addedAnimationsTableViewController
{
    if (!_addedAnimationsTableViewController) {
        _addedAnimationsTableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DHAddedAnimationsTableViewController"];
        _addedAnimationsTableViewController.title = @"Added Animations";
        _addedAnimationsTableViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAddedAnimationViewController)];
        _addedAnimationsTableViewController.addedAnimations = self.addedAnimations;
    }
    return _addedAnimationsTableViewController;
}

- (void) dismissAddedAnimationViewController
{
    [self.addedAnimationNavigationViewController dismissViewControllerAnimated:YES completion:nil];
}
@end

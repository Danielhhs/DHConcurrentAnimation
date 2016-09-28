//
//  DHObjectAnimationSettingsTableViewController.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationSettingsTableViewController.h"
#import "DHAnimationSettings.h"
@interface DHObjectAnimationSettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UISlider *durationSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *directionSegment;
@property (weak, nonatomic) IBOutlet UISlider *columnCountSlider;
@property (weak, nonatomic) IBOutlet UISlider *rowCountSlider;
@property (nonatomic, strong) DHAnimationSettings *settings;
@end

@implementation DHObjectAnimationSettingsTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.settings = [DHAnimationSettings defaultSettingsForAnimationType:self.type event:self.event];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateValues];
}

- (void) setSettings:(DHAnimationSettings *)settings
{
    _settings = settings;
    [self updateValues];
}

- (void) updateValues
{
    self.durationSlider.value = self.settings.duration;
    self.directionSegment.selectedSegmentIndex = self.settings.direction;
    self.columnCountSlider.value = self.settings.columnCount;
    self.rowCountSlider.value = self.settings.rowCount;
}

- (IBAction)durationSliderChanged:(UISlider *)sender {
    self.settings.duration = sender.value;
}

- (IBAction)directionSegmentChanged:(UISegmentedControl *)sender {
    self.settings.direction = sender.selectedSegmentIndex;
}

- (IBAction)columnCountSliderChanged:(UISlider *)sender {
    self.settings.columnCount = (NSInteger)floor(sender.value);
}

- (IBAction)rowCountSliderChanged:(UISlider *)sender {
    self.settings.rowCount = (NSInteger)floor(sender.value);
}

@end

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
@property (weak, nonatomic) IBOutlet UISegmentedControl *triggerEventSegment;
@property (weak, nonatomic) IBOutlet UISlider *triggerTimeSlider;
@property (weak, nonatomic) IBOutlet UITableViewCell *triggerTimeCell;
@property (weak, nonatomic) IBOutlet UISlider *rowCountSlider;
@end

@implementation DHObjectAnimationSettingsTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
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
    self.triggerEventSegment.selectedSegmentIndex = self.settings.triggerEvent;
    self.triggerTimeSlider.value = self.settings.triggerTime;
    self.triggerTimeCell.hidden = !(self.settings.triggerEvent == DHAnimationTriggerEventByTime);
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

- (IBAction)triggerTimeSliderChanged:(UISlider *)sender {
    self.settings.triggerTime = sender.value;
}

- (IBAction)triggerEventChanged:(UISegmentedControl *)sender {
    self.settings.triggerEvent = sender.selectedSegmentIndex;
    if (self.settings.triggerEvent == DHAnimationTriggerEventByTime) {
        self.triggerTimeCell.hidden = NO;
    } else {
        self.triggerTimeCell.hidden = YES;
    }
}


@end

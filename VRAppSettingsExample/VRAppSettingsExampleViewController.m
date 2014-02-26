//
//  IRViewController.m
//  IRAppSettingsExample
//
//  Created by Ivan Rublev on 11/25/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me . All rights reserved.
//

#import "VRAppSettingsExampleViewController.h"
#import "VRMySettings.h"

@interface VRAppSettingsExampleViewController ()

@end

@implementation VRAppSettingsExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [VRMySettings sharedInstance].constTitle = @"Unchangable heh?";
    [self updateAll];
}

#pragma mark -
#pragma mark Output
- (void)updateAll
{
    [self updateControlsFromMySettings];
    [self dumpMySettingsAndUserDefaults];
}

- (void)updateControlsFromMySettings
{
    self.valueSwitch.on = [VRMySettings sharedInstance].value;
    self.titleTextField.text = [VRMySettings sharedInstance].title;
    self.numberStepper.value = [[VRMySettings sharedInstance].number doubleValue];
}

- (void)dumpMySettingsAndUserDefaults
{
    self.mySettingsTextView.text = [[VRMySettings sharedInstance] descriptionWithPropertiesValues];
    NSData * setObjData = [[NSUserDefaults standardUserDefaults] objectForKey:[[VRMySettings sharedInstance] userDefaultsKey]];
    if ([setObjData isKindOfClass:[NSData class]]) {
        self.userDefaultsTextView.text = [NSString stringWithFormat:@"key %@ =\n%@",
                                          [[VRMySettings sharedInstance] userDefaultsKey],
                                          [[NSKeyedUnarchiver unarchiveObjectWithData:setObjData] descriptionWithPropertiesValues]];
    } else {
        self.userDefaultsTextView.text = @"";
    }
}

#pragma mark -
#pragma mark Input
- (IBAction)viewTapped:(UITapGestureRecognizer *)sender {
    [self.titleTextField resignFirstResponder];
}

- (IBAction)valueSwitchChanged:(UISwitch *)sender {
    [VRMySettings sharedInstance].value = sender.on;
    [self dumpMySettingsAndUserDefaults];
}

- (IBAction)titleTextFieldChanged:(UITextField *)sender {
    [VRMySettings sharedInstance].title = sender.text;
    [self dumpMySettingsAndUserDefaults];
}

- (IBAction)numberStepperChanged:(UIStepper *)sender {
    [VRMySettings sharedInstance].number = @(sender.value);
    [self dumpMySettingsAndUserDefaults];
}

#pragma mark -
#pragma mark Save / Load
- (IBAction)syncToUD:(id)sender {
    [[VRMySettings sharedInstance] synchronizeToUserDefaults];
    [self dumpMySettingsAndUserDefaults];
}

- (IBAction)resetToUD:(id)sender {
    [[VRMySettings sharedInstance] resetToUserDefaults];
    [self updateAll];
}

- (IBAction)resetToDEV:(id)sender {
    [[VRMySettings sharedInstance] resetToDeveloperDefaults];
    [self updateAll];
}

- (IBAction)clearUD:(id)sender {
    // Well, it seems that registered defaults keeped can't be cleared during app's run, so do this hack to clear.
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:[[VRMySettings sharedInstance] userDefaultsKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dumpMySettingsAndUserDefaults];
}

@end

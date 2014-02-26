//
//  IRViewController.h
//  IRAppSettingsExample
//
//  Created by Ivan Rublev on 11/25/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VRAppSettingsExampleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *mySettingsTextView;
@property (weak, nonatomic) IBOutlet UITextView *userDefaultsTextView;
@property (weak, nonatomic) IBOutlet UISwitch *valueSwitch;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIStepper *numberStepper;
- (IBAction)valueSwitchChanged:(UISwitch *)sender;
- (IBAction)titleTextFieldChanged:(UITextField *)sender;
- (IBAction)numberStepperChanged:(UIStepper *)sender;

- (IBAction)syncToUD:(id)sender;
- (IBAction)resetToUD:(id)sender;
- (IBAction)resetToDEV:(id)sender;
- (IBAction)clearUD:(id)sender;

@end

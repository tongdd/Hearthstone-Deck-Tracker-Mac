//
//  SettingsBuilderController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/16.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "ImportWindowController.h"
#import "NetEaseCardBuilderImporter.h"
#import "AppDelegate.h"
#import "Configuration.h"
#import "DeckModel.h"

@interface ImportWindowController ()

@property IBOutlet NSTextField *status;
@property IBOutlet NSProgressIndicator *indicator;

@property IBOutlet NSButton *cancelButton;
@property IBOutlet NSButton *updateButton;

@property IBOutlet NSTextField *inputField;
@property IBOutlet NSComboBox *siteChooser;

@end

@implementation ImportWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    // Do view setup here.
    [self.indicator setHidden:YES];
    [self.status setHidden:YES];
}

- (IBAction)cancel:(id)sender {    
    [self.window orderOut:nil];
}

- (IBAction)update:(id)sender {
    if ([[self.inputField stringValue] length] == 0) {
        NSLog(@"Please input builder Id");
    }
    else if (![self.siteChooser objectValueOfSelectedItem]) {
        NSLog(@"Should select site");
    }
    else if (![Configuration instance].countryLanguage) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.alertStyle = NSWarningAlertStyle;
        alert.informativeText = @"Game language is not configured in the Preferences panel";
        [alert runModal];
    }
    else {
        [self.indicator setHidden:NO];
        [self.indicator startAnimation:self];
        [self.status setHidden:NO];
        [self.status setStringValue:@"querying"];

        [NetEaseCardBuilderImporter importDocker:[self.siteChooser objectValueOfSelectedItem]
                                          withId:[self.inputField stringValue]
                                         success:^(DeckModel *deck) {
            [self.indicator setHidden:YES];
            [self.status setStringValue:@"success"];

            AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
            [appDelegate updateWithDeck:deck];

            [self.window orderOut:nil];

        }                                   fail:^(NSString *failReason) {
            [self.indicator setHidden:YES];
            [self.status setStringValue:failReason];
        }];
    }
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSLog(@"Hello");
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Hello");
}

@end

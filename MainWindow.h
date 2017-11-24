//
//  MainWindow.h
//  Chaos Starter
//
//  Created by Peter Kendall on 1/6/08.
//  Copyright 2008 @PAK software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MainWindow : NSObject
{
	IBOutlet NSTextField* UTpath;
	IBOutlet NSButton* noShow;
	IBOutlet NSButton* startButton;
}
-(MainWindow*)init;
-(IBAction)browse: (id)sender;
-(IBAction)start: (id)sender;
-(void)textChange: (NSNotification*)notification;
-(void)applicationDidFinishLaunching: (NSNotification*)notification;
-(void)applicationWillTerminate: (NSNotification*)notification;
-(void)runUT2k4;
-(void)dealloc;
@end

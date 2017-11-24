//
//  MainWindow.m
//  Chaos Starter
//
//  Created by Peter Kendall on 1/6/08.
//  Copyright 2008 @PAK software. All rights reserved.
//

#import "MainWindow.h"


@implementation MainWindow

-(MainWindow*)init
{
	if(self=[super init])
	{
		//get notification if one of the text boxes contents changes and set it to textChange:
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(textChange:) name: @"NSControlTextDidChangeNotification" object: UTpath];
	}
	return self;
}

-(IBAction)browse: (id)sender
{
	NSString *path=[NSString stringWithString: @"-1"];
	//setup and display the open dialog box
	NSArray *fileTypes=[NSArray arrayWithObject: @"app"];
	NSOpenPanel *oPanel=[NSOpenPanel openPanel];
	int result=[oPanel runModalForDirectory: nil file: nil types: fileTypes];
	if(result==NSOKButton)
	{
		NSArray *file=[oPanel filenames];
		path=[file objectAtIndex: 0];
		//set the UT2k4 location text box to the path
		[UTpath setStringValue: path];
		//send a notification that the text changed b/c the text box doesn't do it
		[[NSNotificationCenter defaultCenter] postNotificationName: @"NSControlTextDidChangeNotification" object: UTpath];
	}
}

-(IBAction)start: (id)sender
{
	[self runUT2k4];
}

-(void)textChange: (NSNotification*)notification
{
	if([[UTpath stringValue] length]!=0)
	{
		[startButton setEnabled: YES];
	}
	else
	{
		[startButton setEnabled: NO];
	}
}

-(void)applicationDidFinishLaunching: (NSNotification*)notification
{
	//read in from the preferences
	NSFileManager *prefs=[NSFileManager defaultManager];
	
	//add in some code that checks if the .plist file exists first before any of these bottom 2
	if([prefs fileExistsAtPath: [NSHomeDirectory() stringByAppendingString: @"/Library/Preferences/com.atPAK.Chaos Starter.plist"]]==YES)  //The new prefs exist
	{
		NSDictionary *root=[NSDictionary dictionaryWithContentsOfFile: [NSHomeDirectory() stringByAppendingString: @"/Library/Preferences/com.atPAK.Chaos Starter.plist"]];
		NSString *path=[root valueForKey: @"UTpath"];
		if(path!=nil)
		{
			[UTpath setStringValue: path];
			[[NSNotificationCenter defaultCenter] postNotificationName: @"NSControlTextDidChangeNotification" object: UTpath];
		}
		//are we to not show anything and automaticly open UT2k4?
		NSNumber *checked=[root valueForKey: @"noShow"];
		if(checked!=nil)
		{
			if([checked intValue]==NSOnState)
			{
				[noShow setState: NSOnState];
				//don't show, but do we want to force it to show?
				CGEventRef event=CGEventCreate(NULL);
				CGEventFlags mods=CGEventGetFlags(event);
				if(!(mods & kCGEventFlagMaskCommand))
				{
					//we don't want to show
					[self runUT2k4];
				}
				CFRelease(event);
			}
		}
	}
}

-(void)applicationWillTerminate: (NSNotification*)notification
{
	NSMutableDictionary *root=[NSMutableDictionary dictionary];
	[root setValue: [UTpath stringValue] forKey: @"UTpath"];
	[root setValue: [NSNumber numberWithInt: [noShow state]] forKey: @"noShow"];
	[root writeToFile: [NSHomeDirectory() stringByAppendingString: @"/Library/Preferences/com.atPAK.Chaos Starter.plist"] atomically: YES];
}

-(void)runUT2k4
{
	NSTask* task=[[NSTask alloc] init];
	[task setLaunchPath: [[UTpath stringValue] stringByAppendingString: @"/Contents/MacOS/Unreal Tournament 2004"]];
	[task setArguments: [NSArray arrayWithObjects: @"-mod=ChaosUT2", @"-userlogo=../ChaosUT2/Help/ChaosUT2Logo.bmp", @"&", nil]];
	[task launch];
	
	[task autorelease];
	//kill the application
	[NSApp terminate: self];
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[super dealloc];
}

@end

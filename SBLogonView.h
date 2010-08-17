//
//  SBLogonView.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 09/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBViewController.h"

@interface SBLogonView : SBViewController {
     
    UITextField *textUsername;
	UITextField *textPassword;
	UISwitch *checkRememberMe;
    UIButton *buttonLogon;
    NSString *loggingOnUser;
    
}

@property (nonatomic, retain) IBOutlet UITextField *textUsername;
@property (nonatomic, retain) IBOutlet UITextField *textPassword;
@property (nonatomic, retain) IBOutlet UISwitch *checkRememberMe;
@property (nonatomic, retain) IBOutlet UIButton *buttonLogon;
@property (nonatomic, retain) NSString *loggingOnUser;

-(IBAction)handleLogonClick:(id)sender;

@end

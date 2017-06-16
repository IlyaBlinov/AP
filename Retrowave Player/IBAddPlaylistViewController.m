//
//  IBAddPlaylistViewController.m
//  Retrowave Player
//
//  Created by Илья Блинов on 02.05.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBAddPlaylistViewController.h"
#import "IBTransitionViewController.h"
#import "IBFontAttributes.h"

@interface IBAddPlaylistViewController ()<UITextFieldDelegate>

@end

@implementation IBAddPlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playlistNameTextChange:) name:UITextFieldTextDidChangeNotification object:self.playlistName];
    
    self.playlistName.delegate = self;
    NSDictionary *attributes = [IBFontAttributes attributesOfButtons];
    
    NSMutableAttributedString *addTitle = [[NSMutableAttributedString alloc] initWithString:@"Add"];
    [addTitle setAttributes:attributes range:NSMakeRange(0, [addTitle length])];
    

    NSMutableAttributedString *cancelTitle = [[NSMutableAttributedString alloc] initWithString:@"Cancel"];
    [cancelTitle setAttributes:attributes range:NSMakeRange(0, [cancelTitle length])];
    
    [self.addPlaylist.titleLabel sizeToFit];
    [self.addPlaylist setAttributedTitle:addTitle forState:UIControlStateNormal];
   
    [self.cancel.titleLabel sizeToFit];
    [self.cancel setAttributedTitle:cancelTitle forState:UIControlStateNormal];
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"New Playlist"];
    [self.navigationController.navigationBar setBarTintColor:[UIColor darkGrayColor]];
    //[self.playlistName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Actions


- (IBAction)addPlaylistAction  :(UIButton*) button{
    [self.playlistName resignFirstResponder];

    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)cancelNewPlaylistAction:(UIButton*) button{
    [self.playlistName resignFirstResponder];

   self.playlistName.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

#pragma mark - Notifications

- (void) playlistNameTextChange:(NSNotification*) notification{
    
    NSDictionary *attributes = [IBFontAttributes attributesOfMainTitle];
    
    
    UITextField *textField = (UITextField*)[notification object];
    NSLog(@"text = %@",textField);
    
    NSString *str = textField.text;
    
    NSMutableAttributedString *newString = [[NSMutableAttributedString alloc] initWithString:str];
    [newString addAttributes:attributes range:NSMakeRange(0, [newString length])];
    
    self.playlistName.attributedText = newString;
    
    
}




#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    return YES;
    
}







@end

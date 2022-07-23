//
//  WHPopUpController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/12.
//

#import "WHPopUpController.h"

@interface WHPopUpController ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end

@implementation WHPopUpController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.messageLabel.text = self.message;
}

- (IBAction)confirm
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

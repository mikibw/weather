//
//  WHLifeIndexPopUpController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import "WHLifeIndexPopUpController.h"
#import "WHLifeIndexModel.h"

@interface WHLifeIndexPopUpController ()
@property (weak, nonatomic) IBOutlet UIView *wrappedView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@end

@implementation WHLifeIndexPopUpController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.wrappedView.layer.borderWidth = 1;
    self.wrappedView.layer.borderColor = UIColor.lightBorderColor.CGColor;
    
    self.wrappedView.layer.shadowRadius = 8;
    self.wrappedView.layer.shadowOpacity = 0.2;
    self.wrappedView.layer.shadowOffset = CGSizeMake(0, 4);
    self.wrappedView.layer.shadowColor = UIColor.blackColor.CGColor;
    
    self.nameLabel.text = self.item.name;
    self.icon.image = [UIImage lifeIndexWithName:self.item.name];
    self.briefLabel.text = self.item.brief;
    self.detailsLabel.text = self.item.details;
}

- (IBAction)confirm
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

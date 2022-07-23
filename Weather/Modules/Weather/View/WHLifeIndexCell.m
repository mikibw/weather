//
//  WHLifeIndexCell.m
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import "WHLifeIndexCell.h"
#import "WHLifeIndexModel.h"

@interface WHLifeIndexCell ()
@property (weak, nonatomic) IBOutlet UIView *wrappedView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;
@end

@implementation WHLifeIndexCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.wrappedView.layer.borderWidth = 1;
    self.wrappedView.layer.borderColor = UIColor.lightBorderColor.CGColor;
}

- (void)setLifeIndexItem:(WHLifeIndexItemModel *)item
{
    self.nameLabel.text = item.name;
    self.icon.image = [UIImage lifeIndexWithName:item.name];
    self.briefLabel.text = [NSString stringWithFormat:@"%@>", item.brief];;
}

@end

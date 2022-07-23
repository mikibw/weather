//
//  WHSearchTableViewCell.h
//  Weather
//
//  Created by shoujian on 2021/3/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationIgvWidth;
@property (weak, nonatomic) IBOutlet UILabel *pathLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *temoeratureLabel;

@end

NS_ASSUME_NONNULL_END

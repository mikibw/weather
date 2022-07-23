//
//  WHSearchFieldView.h
//  Weather
//
//  Created by Liang Tang on 2021/3/15.
//

#import "WHNibView.h"

@interface WHSearchFieldView : WHNibView
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@end

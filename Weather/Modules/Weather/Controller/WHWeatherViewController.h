//
//  WHWeatherViewController.h
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import "WHViewController.h"
#import "WHWeatherViewModel.h"

@interface WHWeatherViewController : WHViewController
@property (nonatomic, strong) WHWeatherViewModel *viewModel;
@end

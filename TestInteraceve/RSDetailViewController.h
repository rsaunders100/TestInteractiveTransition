//
//  RSDetailViewController.h
//  TestInteraceve
//
//  Created by Robert Saunders on 23/03/2014.
//  Copyright (c) 2014 Robert Saunders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

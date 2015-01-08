//
//  NameInfoTableViewController.m
//  Peyar
//
//  Created by Kishore Kumar on 11/23/14.
//  Copyright (c) 2014 com.kishorek. All rights reserved.
//

#import "NameInfoTableViewController.h"
#import "Peyar.h"
#import "FavDBUtil.h"

@interface NameInfoTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (weak, nonatomic) IBOutlet UILabel *lblPrefix;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblSource;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;

@property(nonatomic, assign, getter=isFavorite) BOOL favorite;

@end

@implementation NameInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnFavorite.layer.cornerRadius = 6.0;
    self.btnFavorite.layer.borderWidth = 1.0;
    self.btnFavorite.layer.borderColor = [UIColor colorWithRed:0.176 green:0.443 blue:0.525 alpha:1].CGColor;
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadData {
    self.lblName.text   = self.peyar.name;
    self.lblPrefix.text = self.peyar.prefix;
    self.lblSource.text = [NSString stringWithFormat:@"source: %@",self.peyar.source];
    self.lblGender.text = self.peyar.gender==1?@"பெண்":@"ஆண்";
    
    self.favorite = [[FavDBUtil util] isFavorite:self.peyar.peyarId];
}

-(void)setFavorite:(BOOL)favorite {
    _favorite = favorite;
    
    if (!_favorite) {
        [self.btnFavorite setTitle:@"விருப்பத்தில் சேர்" forState:UIControlStateNormal];
    } else {
        [self.btnFavorite setTitle:@"விருப்பத்திலிருந்து நீக்கு" forState:UIControlStateNormal];
    }
}
- (IBAction)favoriteTapped:(id)sender {
    self.favorite = !self.favorite;
    
    if (self.isFavorite) {
        [[FavDBUtil util] saveFavorite:self.peyar];
    } else {
        [[FavDBUtil util] removeFavorite:self.peyar.peyarId];
    }
}

@end

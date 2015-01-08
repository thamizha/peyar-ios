//
//  FavoritesListViewController.m
//  Peyar
//
//  Created by Kishore Kumar on 11/23/14.
//  Copyright (c) 2014 com.kishorek. All rights reserved.
//

#import "FavoritesListViewController.h"
#import "NameInfoTableViewController.h"
#import "Peyar.h"
#import "FavDBUtil.h"

@interface FavoritesListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSArray *names;
@property(nonatomic, strong) Peyar *selectedPeyar;

@end

@implementation FavoritesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
}

-(void) loadData {
    
    self.names = [[FavDBUtil util] fetchFavorites];
    [self.tableView reloadData];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.names.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"FavNameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    Peyar *peyar = self.names[indexPath.row];
    cell.textLabel.text = peyar.name;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Peyar *peyar = self.names[indexPath.row];
    self.selectedPeyar = peyar;
    
    [self performSegueWithIdentifier:@"OpenFavNameDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OpenFavNameDetail"]) {
        NameInfoTableViewController *dest = segue.destinationViewController;
        dest.peyar = self.selectedPeyar;
    }
}

@end

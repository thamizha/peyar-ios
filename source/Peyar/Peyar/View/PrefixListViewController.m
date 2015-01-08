//
//  ViewController.m
//  Peyar
//
//  Created by Kishore Kumar on 11/18/14.
//  Copyright (c) 2014 com.kishorek. All rights reserved.
//

#import "PrefixListViewController.h"
#import "NamesListViewController.h"
#import "PeyarDBUtil.h"

@interface PrefixListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *prefices;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;

@property (nonatomic, strong) NSString *selectedPrefix;

@end

@implementation PrefixListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OpenNamesList"]) {
        NamesListViewController *dest = [segue destinationViewController];
        dest.gender = self.genderSegment.selectedSegmentIndex+1;
        dest.prefix = self.selectedPrefix;
    }
}

#pragma mark - Custom
-(void) loadData {
    self.prefices = [[PeyarDBUtil util] listOfLettersWithGender:self.genderSegment.selectedSegmentIndex+1];
    [self.tableView reloadData];
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.prefices.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"PrefixCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = self.prefices[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedPrefix = self.prefices[indexPath.row];
    [self performSegueWithIdentifier:@"OpenNamesList" sender:self];
}

@end

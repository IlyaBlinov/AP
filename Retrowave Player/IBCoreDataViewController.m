//
//  IBCoreDataViewController.m
//  Retrowave Player
//
//  Created by eastwood on 06/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBCoreDataViewController.h"

@interface IBCoreDataViewController ()

@end

@implementation IBCoreDataViewController

@synthesize persistentContainer = _persistentContainer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSPersistentContainer*) persistentContainer{
    if (!_persistentContainer) {
        _persistentContainer = [[IBCoreDataManager sharedManager] persistentContainer];
    }
    
    return _persistentContainer;

}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *indentifier = @"cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier] ;
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}




#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    
    return nil;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;

    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Edit Delete Button Of Cell

- (UIImage*) imageForTableViewRowActionWithTitle:(NSString*) title textAttributes:(NSDictionary*) attributes backgroundColor:(UIColor*) color cellHeight:(CGFloat) cellHeight{
    
    
    NSString *titleString = title;
    NSDictionary *originalAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize originalSize = [titleString  sizeWithAttributes:originalAttributes];
    
    CGSize newSize = CGSizeMake(originalSize.width * 2.5, originalSize.height * 2);
    
    CGRect drawingRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, YES, [UIScreen mainScreen].nativeScale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, color.CGColor);
    CGContextFillRect(contextRef, drawingRect);
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:drawingRect];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:[IBFontAttributes attributesOfMainTitle]];
    
    [label drawTextInRect:drawingRect];
    
    UIImage *returningImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return returningImage;
    
}


- (NSString *) whitespaceReplacementString:(NSString*) string WithSystemAttributes:(NSDictionary *)systemAttributes newAttributes:(NSDictionary *)newAttributes
{
    NSString *stringTitle = string;
    NSMutableString *stringTitleWS = [[NSMutableString alloc] initWithString:@""];
    
    CGFloat diff = 0;
    CGSize  stringTitleSize = [stringTitle sizeWithAttributes:newAttributes];
    CGSize stringTitleWSSize;
    NSDictionary *originalAttributes = systemAttributes;
    do {
        [stringTitleWS appendString:@" "];
        stringTitleWSSize = [stringTitleWS sizeWithAttributes:originalAttributes];
        diff = (stringTitleSize.width - stringTitleWSSize.width);
        if (diff <= 1.5) {
            break;
        }
    }
    while (diff > 0);
    
    return stringTitleWS;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    
}
@end

//
//  VenueDetailViewController.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-13.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "VenueDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "VenueMapAnnotation.h"

typedef enum {
	VenueDetailViewControllerSectionLocation,
	CountVenueDetailViewControllerSections
} VenueDetailViewControllerSection;

@interface VenueDetailViewController (Private)

- (void)updateVenueObject;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation VenueDetailViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize venueObject = _venueObject;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
		[self addObserver:self
			   forKeyPath:@"venueObject"
				  options:NSKeyValueObservingOptionNew
				  context:nil];
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self updateVenueObject];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"venueObject"]) {
		[self updateVenueObject];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)viewDidUnload {
	[_mapView release];
	[super viewDidUnload];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	self.managedObjectContext = nil;
	[self removeObserver:self forKeyPath:@"venueObject"];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Private methods

- (void)updateVenueObject {
	if (!self.view)
		return;
	
	if ([self.venueObject.longitude floatValue] != 0 && [self.venueObject.latitude floatValue] != 0) {
		CGFloat radius = 10;
		CGRect mapRect = CGRectMake(0, 0, 300, 119.0);
		_mapView = [[MKMapView alloc] initWithFrame:mapRect];
		_mapView.userInteractionEnabled = NO;
		_mapView.delegate = self;
		
		CLLocationDistance viewDistance = 500.0;
		CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.venueObject.latitude floatValue],
																	 [self.venueObject.longitude floatValue]);
		_mapView.region = MKCoordinateRegionMakeWithDistance(location, viewDistance, viewDistance);
		
		VenueMapAnnotation *mapAnnotation = [[[VenueMapAnnotation alloc] init] autorelease];
		[mapAnnotation setCoordinate:location];
		[_mapView addAnnotation:mapAnnotation];
		
		// Set a corner path to make the map fit with the grouped table view
		if (self.tableView.style == UITableViewStyleGrouped) {
			UIBezierPath *path = [UIBezierPath bezierPath];
			[path moveToPoint:CGPointMake(0, mapRect.size.height)];
			[path addLineToPoint:CGPointMake(0, radius)];
			[path addQuadCurveToPoint:CGPointMake(radius, 0)
						 controlPoint:CGPointMake(0, 0)];
			[path addLineToPoint:CGPointMake(mapRect.size.width - radius, 0)];
			[path addQuadCurveToPoint:CGPointMake(mapRect.size.width, radius)
						 controlPoint:CGPointMake(mapRect.size.width, 0)];
			[path addLineToPoint:CGPointMake(mapRect.size.width, mapRect.size.height)];
			[path closePath];
			
			CAShapeLayer *mask = [CAShapeLayer layer];
			mask.path = [path CGPath];
			_mapView.layer.mask = mask;
			_mapView.layer.masksToBounds = YES;
		}
	}
		
	self.navigationItem.title = self.venueObject.title;
	[self.tableView reloadData];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = indexPath.row;

	switch (indexPath.section) {
		case VenueDetailViewControllerSectionLocation:
			// If we don't have a map view, there isn't a first row
			if (!_mapView)
				row++;

			switch (row) {
				case 0:
					[_mapView removeFromSuperview];
					[cell.contentView addSubview:_mapView];
					break;
					
				case 1:
					cell.textLabel.text = NSLocalizedString(@"Address", nil);
					cell.detailTextLabel.text = self.venueObject.address;
					break;
					
				default:
					break;
			}
			break;

		default:
			break;
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return CountVenueDetailViewControllerSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = indexPath.row;

	switch (indexPath.section) {
		case VenueDetailViewControllerSectionLocation: {
			if (!_mapView)
				row++;

			switch (row) {
				case 0:
					return 120;

				case 1:
					return [self.venueObject.address sizeWithFont:[UIFont systemFontOfSize:14.0]
												constrainedToSize:CGSizeMake(self.view.frame.size.width - 20, MAXFLOAT)
													lineBreakMode:UILineBreakModeWordWrap].height + 20;
			}			
		}
	}
	
	return 44.0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case VenueDetailViewControllerSectionLocation:
			return self.venueObject.title;
		
		default:
			return nil;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int rowCount = 0;
	
	switch (section) {
		case VenueDetailViewControllerSectionLocation: {
			rowCount = 1;
			if (self.venueObject.latitude && self.venueObject.longitude)
				rowCount++;
			
			return rowCount;
		}
			
		default:
			return rowCount;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
	UITableViewCellStyle cellStyle;
	
	switch (indexPath.section) {
		case VenueDetailViewControllerSectionLocation:
			cellIdentifier = @"DetailVenueLocation";
			cellStyle = UITableViewCellStyleValue2;
			break;
			
		default:
			cellIdentifier = @"DetailVenueDescription";
			cellStyle = UITableViewCellStyleDefault;
			break;
	}
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier] autorelease];
		
		if (indexPath.section == VenueDetailViewControllerSectionLocation) {
			cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.detailTextLabel.numberOfLines = 0;
			cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
		}
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark -
#pragma mark Map view delegate

- (MKAnnotationView *)viewForAnnotation:(id<MKAnnotation>)annotation {
	static NSString *ReuseIdentifier = @"VenueMapAnnotation";
	
	if ([annotation isKindOfClass:[VenueMapAnnotation class]]) {
		MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
																			   reuseIdentifier:ReuseIdentifier] autorelease];
		annotationView.pinColor = MKPinAnnotationColorRed;
		annotationView.userInteractionEnabled = NO;
		return annotationView;
	}
	
	return nil;
}

@end


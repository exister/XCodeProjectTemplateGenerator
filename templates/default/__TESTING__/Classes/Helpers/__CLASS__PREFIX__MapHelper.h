#import <Foundation/Foundation.h>


@interface __CLASS__PREFIX__MapHelper : NSObject
+ (NSUInteger)zoomLevelForPlaceType:(NSString *)placeType;

+ (void)setCenterCoordinate:(MKMapView *)mapToCenter centerCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

+ (double)longitudeToPixelSpaceX:(double)longitude;

+ (double)latitudeToPixelSpaceY:(double)latitude;

+ (double)pixelSpaceXToLongitude:(double)pixelX;

+ (double)pixelSpaceYToLatitude:(double)pixelY;

+ (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView centerCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel;


@end
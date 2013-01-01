#import <Foundation/Foundation.h>

@interface __CLASS_PREFIX__MapHelper : NSObject

+ (void)setCenterCoordinate:(MKMapView *)mapToCenter centerCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

+ (double)longitudeToPixelSpaceX:(double)longitude;

+ (double)latitudeToPixelSpaceY:(double)latitude;

+ (double)pixelSpaceXToLongitude:(double)pixelX;

+ (double)pixelSpaceYToLatitude:(double)pixelY;

+ (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView centerCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel;


@end

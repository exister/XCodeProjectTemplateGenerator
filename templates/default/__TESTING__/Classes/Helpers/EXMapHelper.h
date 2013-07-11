#import <Foundation/Foundation.h>


@interface EXMapHelper : NSObject
+ (NSString *)locationToString:(CLLocation *)location;

+ (NSString *)coordinateToString:(CLLocationCoordinate2D)coordinate;

+ (CLLocation *)locationFromString:(NSString *)locationString;

+ (NSUInteger)zoomLevelForPlaceType:(NSString *)placeType;

+ (NSString *)boundingBox:(MKMapView *)mapView;

+ (void)setCenterCoordinate:(MKMapView *)mapToCenter centerCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

+ (double)longitudeToPixelSpaceX:(double)longitude;

+ (double)latitudeToPixelSpaceY:(double)latitude;

+ (double)pixelSpaceXToLongitude:(double)pixelX;

+ (double)pixelSpaceYToLatitude:(double)pixelY;

+ (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView centerCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel;


+ (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated;
@end
#import <MapKit/MapKit.h>
#import "EXMapHelper.h"

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

static double MERCATOR_OFFSET = 268435456;
static double MERCATOR_RADIUS = 85445659.44705395;

@implementation EXMapHelper
{

}

+ (NSString *)locationToString:(CLLocation *)location {
    return [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
}

+ (NSString *)coordinateToString:(CLLocationCoordinate2D)coordinate {
    return [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
}

+ (CLLocation *)locationFromString:(NSString *)locationString
{
    NSArray *coords = [locationString componentsSeparatedByString:@","];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[(NSString *)coords[0] doubleValue] longitude:[(NSString *)coords[1] doubleValue]];
    return location;
}

+ (NSUInteger)zoomLevelForPlaceType:(NSString *)placeType
{
    NSUInteger zoom;

    if ([placeType isEqualToString:@"house"]) {
        zoom = 15;
    }
    else if ([placeType isEqualToString:@"street"]) {
        zoom = 13;
    }
    else if ([placeType isEqualToString:@"metro"]) {
        zoom = 13;
    }
    else if ([placeType isEqualToString:@"district"]) {
        zoom = 12;
    }
    else if ([placeType isEqualToString:@"locality"]) {
        zoom = 10;
    }
    else {
        zoom = 15;
    }

    return zoom;
}

+ (NSString *)boundingBox:(MKMapView *)mapView {
    MKMapRect mRect = mapView.visibleMapRect;
    MKMapPoint neMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), mRect.origin.y);
    MKMapPoint swMapPoint = MKMapPointMake(mRect.origin.x, MKMapRectGetMaxY(mRect));
    CLLocationCoordinate2D neCoord = MKCoordinateForMapPoint(neMapPoint);
    CLLocationCoordinate2D swCoord = MKCoordinateForMapPoint(swMapPoint);
    NSString *bbox = [NSString stringWithFormat:@"%@,%@", [EXMapHelper coordinateToString:swCoord], [EXMapHelper coordinateToString:neCoord]];
    return bbox;
}

+ (void)setCenterCoordinate:(MKMapView *)mapToCenter centerCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated
{
    // clamp large numbers to 28
    zoomLevel = MIN(zoomLevel, 28);

    // use the zoom level to compute the region
    MKCoordinateSpan span = [EXMapHelper coordinateSpanWithMapView:mapToCenter centerCoordinate:centerCoordinate zoomLevel:zoomLevel];
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);

    // set the region like normal
    [mapToCenter setRegion:region animated:animated];
}

+ (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

+ (double)latitudeToPixelSpaceY:(double)latitude
{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * log((1 + sin(latitude * M_PI / 180.0)) / (1 - sin(latitude * M_PI / 180.0))) / 2.0);
}

+ (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

+ (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * tan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

+ (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView centerCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel
{
    // convert center coordiate to pixel space
    double centerPixelX = [EXMapHelper longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [EXMapHelper latitudeToPixelSpaceY:centerCoordinate.latitude];

    // determine the scale value from the zoom level
    int zoomExponent = 20 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);

    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height;

    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);

    // find delta between left and right longitudes
    double minLng = [EXMapHelper pixelSpaceXToLongitude:topLeftPixelX];
    double maxLng = [EXMapHelper pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    double longitudeDelta = maxLng - minLng;

    // find delta between top and bottom latitudes
    double minLat = [EXMapHelper pixelSpaceYToLatitude:topLeftPixelY];
    double maxLat = [EXMapHelper pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    double latitudeDelta = -1 * (maxLat - minLat);

    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);

    return span;
}

//size the mapView region to fit its annotations
+ (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    int count = [mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations

    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);

    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }

    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

@end
#import <MapKit/MapKit.h>
#import "__CLASS__PREFIX__MapHelper.h"

static double MERCATOR_OFFSET = 268435456;
static double MERCATOR_RADIUS = 85445659.44705395;

@implementation __CLASS__PREFIX__MapHelper
{

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

+ (void)setCenterCoordinate:(MKMapView *)mapToCenter centerCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated
{
    // clamp large numbers to 28
    zoomLevel = MIN(zoomLevel, 28);

    // use the zoom level to compute the region
    MKCoordinateSpan span = [__CLASS__PREFIX__MapHelper coordinateSpanWithMapView:mapToCenter centerCoordinate:centerCoordinate zoomLevel:zoomLevel];
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
    double centerPixelX = [__CLASS__PREFIX__MapHelper longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [__CLASS__PREFIX__MapHelper latitudeToPixelSpaceY:centerCoordinate.latitude];

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
    double minLng = [__CLASS__PREFIX__MapHelper pixelSpaceXToLongitude:topLeftPixelX];
    double maxLng = [__CLASS__PREFIX__MapHelper pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    double longitudeDelta = maxLng - minLng;

    // find delta between top and bottom latitudes
    double minLat = [__CLASS__PREFIX__MapHelper pixelSpaceYToLatitude:topLeftPixelY];
    double maxLat = [__CLASS__PREFIX__MapHelper pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    double latitudeDelta = -1 * (maxLat - minLat);

    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);

    return span;
}

@end
import UIKit
import MapboxCoreNavigation
import MapboxDirections
import Mapbox
import Solar

/**
 The `NavigationViewControllerDelegate` provides methods for configuring the map view shown by a `NavigationViewController` and responding to the cancellation of a navigation session.
 */
@objc(MBNavigationViewControllerDelegate)
public protocol NavigationViewControllerDelegate {
    /**
     Called when the user exits a route and dismisses the navigation view controller by tapping the Cancel button.
     */
    @objc optional func navigationViewControllerDidCancelNavigation(_ navigationViewController : NavigationViewController)
    
    /**
     Called when the user arrives at the destination.
     */
    @objc optional func navigationViewController(_ navigationViewController : NavigationViewController, didArriveAt waypoint: Waypoint)

    /**
     Returns whether the navigation view controller should be allowed to calculate a new route.
     
     If implemented, this method is called as soon as the navigation view controller detects that the user is off the predetermined route. Implement this method to conditionally prevent rerouting. If this method returns `true`, `navigationViewController(_:willRerouteFrom:)` will be called immediately afterwards.
     
     - parameter navigationViewController: The navigation view controller that has detected the need to calculate a new route.
     - parameter location: The user’s current location.
     - returns: True to allow the navigation view controller to calculate a new route; false to keep tracking the current route.
    */
    @objc(navigationViewController:shouldRerouteFromLocation:)
    optional func navigationViewController(_ navigationViewController: NavigationViewController, shouldRerouteFrom location: CLLocation) -> Bool
    
    @objc(navigationViewController:shouldIncrementLegWhenArrivingAtWaypoint:)
    optional func navigationViewController(_ navigationViewController: NavigationViewController, shouldIncrementLegWhenArrivingAtWaypoint waypoint: Waypoint) -> Bool
    
    /**
     Called immediately before the navigation view controller calculates a new route.
     
     This method is called after `navigationViewController(_:shouldRerouteFrom:)` is called, simultaneously with the `RouteControllerWillReroute` notification being posted, and before `navigationViewController(_:didRerouteAlong:)` is called.
     
     - parameter navigationViewController: The navigation view controller that will calculate a new route.
     - parameter location: The user’s current location.
     */
    @objc(navigationViewController:willRerouteFromLocation:)
    optional func navigationViewController(_ navigationViewController: NavigationViewController, willRerouteFrom location: CLLocation)
    
    /**
     Called immediately after the navigation view controller receives a new route.
     
     This method is called after `navigationViewController(_:willRerouteFrom:)` and simultaneously with the `RouteControllerDidReroute` notification being posted.
     
     - parameter navigationViewController: The navigation view controller that has calculated a new route.
     - parameter route: The new route.
     */
    @objc(navigationViewController:didRerouteAlongRoute:)
    optional func navigationViewController(_ navigationViewController: NavigationViewController, didRerouteAlong route: Route)
    
    /**
     Called when the navigation view controller fails to receive a new route.
     
     This method is called after `navigationViewController(_:willRerouteFrom:)` and simultaneously with the `RouteControllerDidFailToReroute` notification being posted.
     
     - parameter navigationViewController: The navigation view controller that has calculated a new route.
     - parameter error: An error raised during the process of obtaining a new route.
     */
    @objc(navigationViewController:didFailToRerouteWithError:)
    optional func navigationViewController(_ navigationViewController: NavigationViewController, didFailToRerouteWith error: Error)
    
    /**
     Returns an `MGLStyleLayer` that determines the appearance of the route line.
     
     If this method is unimplemented, the navigation map view draws the route line using an `MGLLineStyleLayer`.
     */
    @objc optional func navigationMapView(_ mapView: NavigationMapView, routeStyleLayerWithIdentifier identifier: String, source: MGLSource) -> MGLStyleLayer?
    
    /**
     Returns an `MGLStyleLayer` that determines the appearance of the route line’s casing.
     
     If this method is unimplemented, the navigation map view draws the route line’s casing using an `MGLLineStyleLayer` whose width is greater than that of the style layer returned by `navigationMapView(_:routeStyleLayerWithIdentifier:source:)`.
     */
    @objc optional func navigationMapView(_ mapView: NavigationMapView, routeCasingStyleLayerWithIdentifier identifier: String, source: MGLSource) -> MGLStyleLayer?
    
    /**
     Returns an `MGLShape` that represents the path of the route line.
     
     If this method is unimplemented, the navigation map view represents the route line using an `MGLPolylineFeature` based on `route`’s `coordinates` property.
     */
    @objc optional func navigationMapView(_ mapView: NavigationMapView, shapeDescribing route: Route) -> MGLShape?
    
    /**
     Returns an `MGLShape` that represents the path of the route line’s casing.
     
     If this method is unimplemented, the navigation map view represents the route line’s casing using an `MGLPolylineFeature` identical to the one returned by `navigationMapView(_:shapeDescribing:)`.
     */
    @objc optional func navigationMapView(_ mapView: NavigationMapView, simplifiedShapeDescribing route: Route) -> MGLShape?
    
    /*
     Returns an `MGLStyleLayer` that marks the location of each destination along the route when there are multiple destinations. The returned layer is added to the map below the layer returned by `navigationMapView(_:waypointSymbolStyleLayerWithIdentifier:source:)`.
     
     If this method is unimplemented, the navigation map view marks each destination waypoint with a circle.
     */
    @objc optional func navigationMapView(_ mapView: NavigationMapView, waypointStyleLayerWithIdentifier identifier: String, source: MGLSource) -> MGLStyleLayer?
    
    /*
     Returns an `MGLStyleLayer` that places an identifying symbol on each destination along the route when there are multiple destinations. The returned layer is added to the map above the layer returned by `navigationMapView(_:waypointStyleLayerWithIdentifier:source:)`.
     
     If this method is unimplemented, the navigation map view labels each destination waypoint with a number, starting with 1 at the first destination, 2 at the second destination, and so on.
     */
    @objc optional func navigationMapView(_ mapView: NavigationMapView, waypointSymbolStyleLayerWithIdentifier identifier: String, source: MGLSource) -> MGLStyleLayer?
    
    /**
     Returns an `MGLShape` that represents the destination waypoints along the route (that is, excluding the origin).
     
     If this method is unimplemented, the navigation map view represents the route waypoints using `navigationMapView(_:shapeFor:)`.
     */
    @objc optional func navigationMapView(_ mapView: NavigationMapView, shapeFor waypoints: [Waypoint]) -> MGLShape?
    
    @objc optional func navigationMapView(_ mapView: NavigationMapView, didTap route: Route)
    
    /**
     Return an `MGLAnnotationImage` that represents the destination marker.
     
     If this method is unimplemented, the navigation map view will represent the destination annotation with the default marker.
     */
    @objc optional func navigationMapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage?
    
    /**
     Returns a view object to mark the given point annotation object on the map.
     
     The user location annotation view can also be customized via this method. When annotation is an instance of `MGLUserLocation`, return an instance of `MGLUserLocationAnnotationView` (or a subclass thereof). Note that, when `NavigationMapView.tracksUserCourse` is set to `true`, the map view uses a distinct user course view; to customize it, set the `NavigationMapView.userCourseView` property of the map view returned by this view controller’s `mapView` property.
     */
    @objc optional func navigationMapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView?
    
    /**
     Called when the user opens the feedback form.
     */
    @objc optional func navigationViewControllerDidOpenFeedback(_ viewController: NavigationViewController)
    
    /**
     Called when the user dismisses the feedback form.
     */
    @objc optional func navigationViewControllerDidCancelFeedback(_ viewController: NavigationViewController)
    
    /**
     Called when the user sends feedback.
     
     - parameter viewController: The navigation view controller that reported the feedback.
     - parameter feedbackId: A UUID string used to identify the feedback event.
     - parameter feedbackType: The type of feedback event that was sent.
     */
    @objc optional func navigationViewController(_ viewController: NavigationViewController, didSend feedbackId: String, feedbackType: FeedbackType)
    
    /**
     Returns the center point of the user course view in screen coordinates relative to the map view.
     */
    @objc optional func navigationViewController(_ navigationViewController: NavigationViewController, mapViewUserAnchorPoint mapView: NavigationMapView) -> CGPoint
}

/**
 `NavigationViewController` is fully featured, turn by turn navigation UI.
 
 It provides step by step instructions, an overview of all steps for the given route and support for basic styling.
 */
@objc(MBNavigationViewController)
public class NavigationViewController: UIViewController, RouteMapViewControllerDelegate {
    
    /** 
     A `Route` object constructed by [MapboxDirections](https://mapbox.github.io/mapbox-navigation-ios/directions/).
     
     In cases where you need to update the route after navigation has started you can set a new `route` here and `NavigationViewController` will update its UI accordingly.
     */
    public var route: Route! {
        didSet {
            if routeController == nil {
                routeController = RouteController(along: route, directions: directions, locationManager: NavigationLocationManager())
                routeController.delegate = self
            } else {
                routeController.routeProgress = RouteProgress(route: route)
            }
            mapViewController?.notifyDidReroute(route: route)
        }
    }
    
    /** 
     An instance of `MGLAnnotation` that will be shown on on the destination of your route. The last coordinate of the route will be used if no destination is given.
    */
    @available(*, deprecated, message: "Destination is no longer supported. A destination annotation will automatically be added to map given the route.")
    public var destination: MGLAnnotation!
    
    
    /**
     An instance of `Directions` need for rerouting. See [Mapbox Directions](https://mapbox.github.io/mapbox-navigation-ios/directions/) for further information.
     */
    public var directions: Directions!
    
    /**
     An optional `MGLMapCamera` you can use to improve the initial transition from a previous viewport and prevent a trigger from an excessive significant location update.
     */
    public var pendingCamera: MGLMapCamera?
    
    /**
     An instance of `MGLAnnotation` representing the origin of your route.
     */
    public var origin: MGLAnnotation?
    
    /**
     The receiver’s delegate.
     */
    public weak var delegate: NavigationViewControllerDelegate?
    
    /**
     Provides access to various speech synthesizer options.
     
     See `RouteVoiceController` for more information.
     */
    public var voiceController: RouteVoiceController? = RouteVoiceController()
    
    /**
     Provides all routing logic for the user.

     See `RouteController` for more information.
     */
    public var routeController: RouteController!
    
    /**
     Styles that will be used for various system traits.
     
     See `Style` and `DefaultStyle` for more information.
     */
    public var styles: [Style]? {
        didSet {
            applyStyle()
        }
    }
    
    /**
     The main map view displayed inside the view controller.
     
     - note: Do not change this map view’s delegate.
     */
    public var mapView: NavigationMapView? {
        get {
            return mapViewController?.mapView
        }
    }
    
    /**
     Determines whether the user location annotation is moved from the raw user location reported by the device to the nearest location along the route.
     
     By default, this property is set to `true`, causing the user location annotation to be snapped to the route.
     */
    public var snapsUserLocationAnnotationToRoute = true
    
    /**
     Toggles sending of UILocalNotification upon upcoming steps when application is in the background. Defaults to `true`.
     */
    public var sendNotifications: Bool = true
    
    /**
     Shows a button that allows drivers to report feedback such as accidents, closed roads,  poor instructions, etc. Defaults to `false`.
     */
    public var showsReportFeedback: Bool = true {
        didSet {
            mapViewController?.reportButton.isHidden = !showsReportFeedback
        }
    }
    
    /**
     If true, the map style and UI will automatically be updated given the time of day.
     */
    public var automaticallyAdjustsStyleForTimeOfDay = true
    
    var currentStyleType: StyleType?
    
    var styleTypeForTimeOfDay: StyleType {
        guard automaticallyAdjustsStyleForTimeOfDay else { return .dayStyle }

        guard let location = routeController.location,
            let solar = Solar(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
            let sunrise = solar.sunrise, let sunset = solar.sunset else {
                return .dayStyle
        }

        return isNighttime(date: solar.date, sunrise: sunrise, sunset: sunset) ? .nightStyle : .dayStyle
    }
    
    func isNighttime(date: Date, sunrise: Date, sunset: Date) -> Bool {
        let calendar = Calendar.current
        let currentMinutesFromMidnight = calendar.component(.hour, from: date) * 60 + calendar.component(.minute, from: date)
        let sunriseMinutesFromMidnight = calendar.component(.hour, from: sunrise) * 60 + calendar.component(.minute, from: sunrise)
        let sunsetMinutesFromMidnight = calendar.component(.hour, from: sunset) * 60 + calendar.component(.minute, from: sunset)
        return currentMinutesFromMidnight < sunriseMinutesFromMidnight || currentMinutesFromMidnight > sunsetMinutesFromMidnight
    }
    
    var mapViewController: RouteMapViewController?
    
    /**
     A Boolean value that determines whether the map annotates the locations at which instructions are spoken for debugging purposes.
     */
    public var annotatesSpokenInstructions = false
    
    /**
     A Boolean value that determines whether the user can long-press a feedback item to dictate feedback.
     */
    public var recordsAudioFeedback = false
    
    let progressBar = ProgressBar()
    let routeStepFormatter = RouteStepFormatter()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Initializes a `NavigationViewController` that provides turn by turn navigation for the given route. A optional `direction` object is needed for  potential rerouting.

     See [Mapbox Directions](https://mapbox.github.io/mapbox-navigation-ios/directions/) for further information.
     */
    @objc(initWithRoute:directions:style:locationManager:)
    required public init(for route: Route,
                         directions: Directions = Directions.shared,
                         styles: [Style]? = [DayStyle(), NightStyle()],
                         locationManager: NavigationLocationManager? = NavigationLocationManager()) {
        
        let storyboard = UIStoryboard(name: "Navigation", bundle: .mapboxNavigation)
        let mapViewController = storyboard.instantiateViewController(withIdentifier: "RouteMapViewController") as! RouteMapViewController
        
        self.mapViewController = mapViewController
        
        super.init(nibName: nil, bundle: nil)
        
        self.styles = styles ?? [DayStyle(), NightStyle()]
        
        addChildViewController(mapViewController)
        mapViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapViewController.view)
        
        let v = mapViewController.view!
        v.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        v.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        v.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        v.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        self.directions = directions
        self.route = route
        
        self.routeController = RouteController(along: route, directions: directions, locationManager: locationManager ?? NavigationLocationManager())
        self.routeController.usesDefaultUserInterface = true
        self.routeController.delegate = self

        mapViewController.delegate = self
        mapViewController.routeController = routeController
        mapViewController.reportButton.isHidden = !showsReportFeedback

        self.currentStyleType = styleTypeForTimeOfDay
        
        if !(route.routeOptions is NavigationRouteOptions) {
            print("`Route` was created using `RouteOptions` and not `NavigationRouteOptions`. Although not required, this may lead to a suboptimal navigation experience. Without `NavigationRouteOptions`, it is not guaranteed you will get congestion along the route line, better ETAs and ETA label color dependent on congestion.")
        }
    }
    
    deinit {
        suspendNotifications()
        voiceController?.announcementTimer?.invalidate()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        resumeNotifications()
        progressBar.dock(on: view)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        routeController.resume()
        
        applyStyle()
        
        if routeController.locationManager is SimulatedLocationManager {
            let title = NSLocalizedString("USER_IN_SIMULATION_MODE", bundle: .mapboxNavigation, value: "Simulating Navigation", comment: "The text of a banner that appears during turn-by-turn navigation when route simulation is enabled.")
            mapViewController?.statusView.show(title, showSpinner: false)
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        routeController.suspendLocationUpdates()
    }
    
    // MARK: Route controller notifications
    
    func resumeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(progressDidChange(notification:)), name: RouteControllerProgressDidChange, object: routeController)
        NotificationCenter.default.addObserver(self, selector: #selector(didPassInstructionPoint(notification:)), name: RouteControllerDidPassSpokenInstructionPoint, object: routeController)
    }
    
    func suspendNotifications() {
        NotificationCenter.default.removeObserver(self, name: RouteControllerProgressDidChange, object: routeController)
        NotificationCenter.default.removeObserver(self, name: RouteControllerDidPassSpokenInstructionPoint, object: routeController)
    }
    
    @objc func progressDidChange(notification: NSNotification) {
        let routeProgress = notification.userInfo![MBRouteControllerDidPassSpokenInstructionPointRouteProgressKey] as! RouteProgress
        let location = notification.userInfo![RouteControllerProgressDidChangeNotificationLocationKey] as! CLLocation
        let secondsRemaining = notification.userInfo![RouteControllerProgressDidChangeNotificationSecondsRemainingOnStepKey] as! TimeInterval

        mapViewController?.notifyDidChange(routeProgress: routeProgress, location: location, secondsRemaining: secondsRemaining)
        
        progressBar.setProgress(routeProgress.currentLegProgress.userHasArrivedAtWaypoint ? 1 : CGFloat(routeProgress.fractionTraveled), animated: true)
    }
    
    @objc func didPassInstructionPoint(notification: NSNotification) {
        let routeProgress = notification.userInfo![MBRouteControllerDidPassSpokenInstructionPointRouteProgressKey] as! RouteProgress
        
        mapViewController?.updateMapOverlays(for: routeProgress)
        mapViewController?.updateCameraAltitude(for: routeProgress)
        
        clearStaleNotifications()
        
        if let upComingStep = routeProgress.currentLegProgress.upComingStep, routeProgress.currentLegProgress.currentStepProgress.durationRemaining < RouteControllerHighAlertInterval {
            scheduleLocalNotification(about: upComingStep, legIndex: routeProgress.legIndex, numberOfLegs: routeProgress.route.legs.count)
        }
        
        if routeProgress.currentLegProgress.userHasArrivedAtWaypoint {
            delegate?.navigationViewController?(self, didArriveAt: routeProgress.currentLegProgress.leg.destination)
        }
        
        forceRefreshAppearanceIfNeeded()
    }
    
    func applyStyle() {
        guard let styles = styles else { return }
        
        for style in styles {
            if style.styleType == styleTypeForTimeOfDay {
                style.apply()
                
                if mapView?.styleURL != style.mapStyleURL {
                    mapView?.style?.transition = MGLTransition(duration: 0.5, delay: 0)
                    mapView?.styleURL = style.mapStyleURL
                }
            }
        }
    }
    
    func forceRefreshAppearanceIfNeeded() {
        // Don't update the style if they are equal
        guard currentStyleType != styleTypeForTimeOfDay else {
            currentStyleType = styleTypeForTimeOfDay
            return
        }
        
        styles?.forEach {
            if $0.styleType == styleTypeForTimeOfDay {
                $0.apply()
                mapView?.style?.transition = MGLTransition(duration: 0.5, delay: 0)
                mapView?.styleURL = $0.mapStyleURL
                currentStyleType = $0.styleType
            }
        }
        
        for window in UIApplication.shared.windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
        
        mapView?.reloadStyle(self)
    }
    
    func scheduleLocalNotification(about step: RouteStep, legIndex: Int?, numberOfLegs: Int?) {
        guard sendNotifications else { return }
        guard UIApplication.shared.applicationState == .background else { return }
        
        let notification = UILocalNotification()
        notification.alertBody = routeStepFormatter.string(for: step, legIndex: legIndex, numberOfLegs: numberOfLegs, markUpWithSSML: false)
        notification.fireDate = Date()
        
        clearStaleNotifications()
        
        UIApplication.shared.cancelAllLocalNotifications()
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func clearStaleNotifications() {
        guard sendNotifications else { return }
        // Remove all outstanding notifications from notification center.
        // This will only work if it's set to 1 and then back to 0.
        // This way, there is always just one notification.
        UIApplication.shared.applicationIconBadgeNumber = 1
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func navigationMapView(_ mapView: NavigationMapView, routeCasingStyleLayerWithIdentifier identifier: String, source: MGLSource) -> MGLStyleLayer? {
        return delegate?.navigationMapView?(mapView, routeCasingStyleLayerWithIdentifier: identifier, source: source)
    }
    
    func navigationMapView(_ mapView: NavigationMapView, routeStyleLayerWithIdentifier identifier: String, source: MGLSource) -> MGLStyleLayer? {
        return delegate?.navigationMapView?(mapView, routeStyleLayerWithIdentifier: identifier, source: source)
    }
    
    func navigationMapView(_ mapView: NavigationMapView, didTap route: Route) {
        delegate?.navigationMapView?(mapView, didTap: route)
    }
    
    func navigationMapView(_ mapView: NavigationMapView, shapeDescribing route: Route) -> MGLShape? {
        return delegate?.navigationMapView?(mapView, shapeDescribing: route)
    }
    
    func navigationMapView(_ mapView: NavigationMapView, simplifiedShapeDescribing route: Route) -> MGLShape? {
        return delegate?.navigationMapView?(mapView, shapeDescribing: route)
    }
    
    func navigationMapView(_ mapView: NavigationMapView, waypointStyleLayerWithIdentifier identifier: String, source: MGLSource) -> MGLStyleLayer? {
        return delegate?.navigationMapView?(mapView, waypointStyleLayerWithIdentifier: identifier, source: source)
    }
    
    func navigationMapView(_ mapView: NavigationMapView, waypointSymbolStyleLayerWithIdentifier identifier: String, source: MGLSource) -> MGLStyleLayer? {
        return delegate?.navigationMapView?(mapView, waypointSymbolStyleLayerWithIdentifier: identifier, source: source)
    }
    
    func navigationMapView(_ mapView: NavigationMapView, shapeFor waypoints: [Waypoint]) -> MGLShape? {
        return delegate?.navigationMapView?(mapView, shapeFor: waypoints)
    }
    
    func navigationMapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        return delegate?.navigationMapView?(mapView, imageFor: annotation)
    }
    
    func navigationMapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return delegate?.navigationMapView?(mapView, viewFor: annotation)
    }
    
    func mapViewControllerDidOpenFeedback(_ mapViewController: RouteMapViewController) {
        delegate?.navigationViewControllerDidOpenFeedback?(self)
    }
    
    func mapViewControllerDidCancelFeedback(_ mapViewController: RouteMapViewController) {
        delegate?.navigationViewControllerDidCancelFeedback?(self)
    }
    
    func mapViewControllerDidCancelNavigation(_ mapViewController: RouteMapViewController) {
        if delegate?.navigationViewControllerDidCancelNavigation?(self) != nil {
            // The receiver should handle dismissal of the NavigationViewController
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func mapViewController(_ mapViewController: RouteMapViewController, didSend feedbackId: String, feedbackType: FeedbackType) {
        delegate?.navigationViewController?(self, didSend: feedbackId, feedbackType: feedbackType)
    }
    
    func mapViewController(_ mapViewController: RouteMapViewController, mapViewUserAnchorPoint mapView: NavigationMapView) -> CGPoint? {
        return delegate?.navigationViewController?(self, mapViewUserAnchorPoint: mapView)
    }
    
    func mapViewControllerShouldAnnotateSpokenInstructions(_ routeMapViewController: RouteMapViewController) -> Bool {
        return annotatesSpokenInstructions
    }
    
    func mapViewControllerShouldRecordAudioFeedback(_ routeMapViewController: RouteMapViewController) -> Bool {
        return recordsAudioFeedback
    }
}

extension NavigationViewController: RouteControllerDelegate {
    public func routeController(_ routeController: RouteController, shouldRerouteFrom location: CLLocation) -> Bool {
        return delegate?.navigationViewController?(self, shouldRerouteFrom: location) ?? true
    }
    
    public func routeController(_ routeController: RouteController, shouldIncrementLegWhenArrivingAtWaypoint waypoint: Waypoint) -> Bool {
        return delegate?.navigationViewController?(self, shouldIncrementLegWhenArrivingAtWaypoint: waypoint) ?? true
    }
    
    public func routeController(_ routeController: RouteController, willRerouteFrom location: CLLocation) {
        delegate?.navigationViewController?(self, willRerouteFrom: location)
    }
    
    public func routeController(_ routeController: RouteController, didRerouteAlong route: Route) {
        mapViewController?.notifyDidReroute(route: route)
        delegate?.navigationViewController?(self, didRerouteAlong: route)
    }
    
    public func routeController(_ routeController: RouteController, didFailToRerouteWith error: Error) {
        delegate?.navigationViewController?(self, didFailToRerouteWith: error)
    }
    
    public func routeController(_ routeController: RouteController, didUpdate locations: [CLLocation]) {
        if snapsUserLocationAnnotationToRoute, let location = routeController.location ?? locations.last {
            mapViewController?.mapView.updateCourseTracking(location: location, animated: true)
            mapViewController?.labelCurrentRoad(at: location)
        } else if let location = locations.last {
            mapViewController?.mapView.updateCourseTracking(location: location, animated: true)
            mapViewController?.labelCurrentRoad(at: location)
        }
    
        if !(routeController.locationManager is SimulatedLocationManager) {
            mapViewController?.statusView.hide(delay: 3, animated: true)
        }
    }
    
    public func routeController(_ routeController: RouteController, didDiscard location: CLLocation) {
        let title = NSLocalizedString("WEAK_GPS", bundle: .mapboxNavigation, value: "Weak GPS signal", comment: "Inform user about weak GPS signal")
        mapViewController?.statusView.show(title, showSpinner: false)
    }
}

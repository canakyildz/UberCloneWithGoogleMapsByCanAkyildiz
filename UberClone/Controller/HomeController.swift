//
//  HomeController.swift
//  UberClone
//
//  Created by Apple on 2.06.2021.
//

import UIKit
import Firebase
import MapKit
import GoogleMaps
import GooglePlaces

private let reuseIdentifier = "LocationCell"
private let annotationIdentifier = "DriverAnnotation"

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            locationInputView.user = user
            if user?.accountType == .passenger {
                fetchDrivers()
                configureLocationInputActivationView()
                
            } else {
                fetchTrips()
            }
        }
    }
    
    private let placesClient = GMSPlacesClient()
    private let geoCoder = CLGeocoder()
    var markers = [GMSMarker]()
    
    private var animatePolyline: AnimatePolyline?
    
    private var trip: Trip? {
        didSet {
            guard let trip = trip else { return }
            let controller = PickupController(trip: trip)
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    private var gmapView = GMSMapView()
    
    private let headerView = MainHeaderView()
    private let locationManager = LocationHandler.shared.locationManager
    private let rideActionView = RideActionView()
    private let locationInputActivatorView = LocationInputActivatorView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    
    private var searchResults = [GMSPlace]()
    
    
    private final let locationInputViewHeight: CGFloat = 160 // final means it cant be changed later on
    private final let rideActionViewHeight: CGFloat = 296
    private var actionButtonConfig = ActionButtonConfiguration()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let mapTitleLabel: UILabel = {
        let label = UILabel()
        label.defineLabelDetails(pText: "Yakınınızda", pColor: .darkGray, fontName: "OpenSans-SemiBold", fontSize: 18)
        return label
    }()
    

    
    private let gestureRecognizingButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleMainMapTapped), for: .touchUpInside)
        return button
    }()
    
    private let pinImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "pinidle").withRenderingMode(.alwaysOriginal))
        return iv
    }()
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signOut()
        checkIfUserIsLoggedIn()
        enableLocationServices()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let trip = trip else { return }
        print("DEBUG: Trip state is \(String(describing: trip.state))")
    }
    
    
    // MARK: - Selectors
    @objc func actionButtonPressed() {
        switch actionButtonConfig {
        
        case .showMenu:
            print("showmenu")
        case .dismissActionView:
            
            DispatchQueue.main.async {
                self.configureMapView(config: .homeMapView)
                self.removeAnnotationsAndOverlays()
                
                self.dismissLocationInputView { _ in
                    UIView.animate(withDuration: 0.5) {
                        self.locationInputActivatorView.alpha = 1
                        self.mapTitleLabel.alpha = 1
                        self.headerView.alpha = 1
                        self.configureActionButton(config: .showMenu)
                        self.animateRideActionView(shouldShow: false)
                    }}}
        }
    }
    
    @objc func handleMainMapTapped() {
        locationInputActivatorView.alpha = 0
        headerView.alpha = 0
        mapTitleLabel.alpha = 0
        configureMapView(config: .exceptMapView)
        gmapView.alpha = 0
        configureLocationInputView()
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG: User is not logged in")
            DispatchQueue.main.async {
                
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        } else {
            configure()
        }
    }
    
    func signOut() {
        
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Error signing out \(error.localizedDescription)")
        }
    }
    
    func fetchTrips() {
        Service.observeTrips { (trip) in
            self.trip = trip
        }
    }
    
    func fetchUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Service.fetchUserData(withUid: currentUid) { (user) in
            self.user = user
        }
    }
    
    func fetchDrivers() {
        guard let location = locationManager?.location else { return }
        Service.fetchDrivers(location: location) { (driver) in
            guard let coordinate = driver.location?.coordinate else { return }
            let marker = DriverMarker(uid: driver.uid, coordinate: coordinate)
            
            var driverIsVisible: Bool {
                return self.markers.contains { marker -> Bool in
                    
                    guard let driverMarker = marker as? DriverMarker else { return false }
                    if driverMarker.uid == driver.uid {
                        driverMarker.updateAnnotationPosition(withCoordinate: coordinate)
                        return true
                    }
                    
                    return false
                }
            }
            if driverIsVisible == false {
                self.addMarker(marker: marker, position: coordinate, isDriver: true)
                if coordinate.latitude == location.coordinate.latitude && coordinate.longitude == location.coordinate.longitude {
                    self.removeMarker(marker: marker)
                }
            }
        }
    }
    
    
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        configureMapView()
        configureRideActionView()
        
        view.addSubview(actionButton)
        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 20, width: 30, height: 30)
        configureTableView()
        
        view.addSubview(headerView)
        headerView.delegate = self
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 290)
    }
    
    func configureMapView() {
        view.addSubview(gmapView)
        configureMapView(config: .homeMapView)
        
        view.addSubview(gestureRecognizingButton)
        gestureRecognizingButton.alpha = 1
        gestureRecognizingButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 24, paddingBottom: 70, paddingRight: 24, height: 200)
        
        
        gmapView.delegate = self
        gmapView.isMyLocationEnabled = true
        gmapView.mapStyle(withFilename: "uberMapStyle", andType: "json")
        
    }
    
    func configureLocationInputView() {
        locationInputView.delegate = self
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor,left: view.leftAnchor, right: view.rightAnchor, height: locationInputViewHeight)
        locationInputView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        } completion: { (_) in
            
            UIView.animate(withDuration: 0.5) {
                self.tableView.frame.origin.y = self.locationInputViewHeight
            }}
    }
    
    func configureRideActionView() {
        
        view.addSubview(rideActionView)
        rideActionView.delegate = self
        rideActionView.backgroundColor = .white
        rideActionView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: rideActionViewHeight)
    }
    
    func configure() {
        fetchUserData()
        configureUI()
    }
    
    func configureLocationInputActivationView() {
        
        view.addSubview(locationInputActivatorView)
        locationInputActivatorView.centerX(inView: view)
        locationInputActivatorView.setDimensions(height: 240, width: view.frame.width)
        locationInputActivatorView.anchor(top: headerView.bottomAnchor)
        locationInputActivatorView.alpha = 0
        locationInputActivatorView.delegate = self
        
        UIView.animate(withDuration: 0.6) {
            self.locationInputActivatorView.alpha = 1
            self.locationInputActivatorView.frame.origin.x = +200
        }
    }
    
    func configureActionButton(config: ActionButtonConfiguration) {
        switch config {
        
        case .showMenu:
            actionButton.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
            actionButtonConfig = .showMenu
        case .dismissActionView:
            actionButton.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
            actionButtonConfig = .dismissActionView
        }
    }
    
    func configureMapView(config: MapViewConfiguration) {
        
        switch config {
        
        case .homeMapView:
            if gmapView.frame.height > 200 {
                gmapView.removeFromSuperview()
                mapTitleLabel.removeFromSuperview()
                
            }
            
            DispatchQueue.main.async {
                guard let view = self.view else { return }
                let gmapView = self.gmapView
                
                view.addSubview(gmapView)
                gmapView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 24, paddingBottom: 70, paddingRight: 24, height: 200)
                gmapView.isMyLocationEnabled = true
                
                view.addSubview(self.mapTitleLabel)
                self.mapTitleLabel.anchor(left: view.leftAnchor, bottom: gmapView.topAnchor,paddingLeft: 24, paddingBottom: 18)
                
                view.bringSubviewToFront(self.gestureRecognizingButton)
                self.gestureRecognizingButton.alpha = 1
                self.markerConfiguration()
            }
            
            guard let location = locationManager?.location?.coordinate else { return }
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15)
            gmapView = GMSMapView.map(withFrame: .zero, camera: camera)
            
            
            
        case .exceptMapView:
            gestureRecognizingButton.alpha = 0
            
            if gmapView.frame.height == 200 {
                gmapView.removeFromSuperview()
                mapTitleLabel.removeFromSuperview()
            }
            
            view.addSubview(gmapView)
            gmapView.anchor(top: view.topAnchor,left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
            
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
    }
    
    func dismissLocationInputView(completion: ((Bool) -> Void)? = nil) {
        //completion handler is ? because not always we will be using it & reason nil is there we dont want to call it all the time then remove it ve bazen dismiss'in nedeni seçilen trip ve map ekranına dönmemiz. sonucu lazım bize yani 
        UIView.animate(withDuration: 0.5, animations: {
            self.locationInputView.alpha = 0
            //            self.mapView.frame = self.view.frame
            self.tableView.frame.origin.y = self.view.frame.height
            self.locationInputView.removeFromSuperview()
            
        }, completion: completion)
    }
    
    func animateRideActionView(shouldShow: Bool, destination: GMSPlace? = nil) {
        
        let yOrigin = shouldShow ? self.view.frame.height - self.rideActionViewHeight : self.view.frame.height
        
        if shouldShow {
            guard let destination = destination else { return }
            rideActionView.destination = destination
        }
        
        UIView.animate(withDuration: 0.3) {
            self.rideActionView.frame.origin.y = yOrigin
            
        }}
    
}
// MARK: - LocationServices

extension HomeController {
    func enableLocationServices() {
        
        
        switch locationManager?.authorizationStatus {
        
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            locationManager?.requestAlwaysAuthorization()
            
        @unknown default:
            break
        }}
    
    func addMarker(marker: GMSMarker, image: UIImage? = nil, position: CLLocationCoordinate2D, isDriver: Bool) -> Void {
        DispatchQueue.main.async {
            let position = position
            marker.map = self.gmapView
            marker.iconView?.setDimensions(height: 15, width: 13.75)
            marker.appearAnimation = .pop
            marker.position = position
            
            if isDriver == true {
                marker.icon = #imageLiteral(resourceName: "icons8-taxi-48")
            } else {
                marker.icon = image
            }
            
            self.markers.append(marker)
            
            
        }
    }
    
    func removeMarker(marker: GMSMarker) {
        DispatchQueue.main.async {
            self.markers.removeAll(where: {$0 == marker})
            marker.map = nil
            
        }
    }
    
    
    func markerConfiguration() {
        markers.forEach { (marker) in
            
            if let marker = marker as? DriverMarker {
                marker.map = self.gmapView
            }
            
            let markerLat = marker.position.latitude
            let markerLon = marker.position.longitude
            let currentUserLat = self.gmapView.myLocation?.coordinate.latitude
            let currentUserLong = self.gmapView.myLocation?.coordinate.longitude
            
            if markerLat == currentUserLat && markerLon == currentUserLong {
                self.removeMarker(marker: marker)
            }
        }
    }
    
}


// MARK: - LocationInputActivatorViewDelegate

extension HomeController: LocationInputActivatorViewDelegate {
    func showLocationInputView() {
        
        locationInputActivatorView.alpha = 0
        headerView.alpha = 0
        mapTitleLabel.alpha = 0
        configureMapView(config: .exceptMapView)
        gmapView.alpha = 0
        configureLocationInputView()
        
    }
}

// MARK: - LocationInputViewDelegate

extension HomeController: LocationInputViewDelegate {
    func executeSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { (places) in
            
            self.searchResults = places
            self.tableView.reloadData()
        }
    }
    
    func handleLocationInputViewDismissal() {
        
        DispatchQueue.main.async {
            self.configureMapView(config: .homeMapView)
            self.removeAnnotationsAndOverlays()
            self.gmapView.isMyLocationEnabled = true
            
            self.dismissLocationInputView { _ in
                UIView.animate(withDuration: 0.5) {
                    self.locationInputActivatorView.alpha = 1
                    self.mapTitleLabel.alpha = 1
                    self.headerView.alpha = 1
                    
                }}
        }
    }
    
}


// MARK: - GMSMapViewDelegate

extension HomeController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let marker = marker as? DriverMarker {
            let markerView = marker
            markerView.icon = #imageLiteral(resourceName: "icons8-taxi-48")
            markerView.iconView?.setDimensions(height: 13, width: 6.5)
            return markerView.iconView
        }
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        guard let currentLocationLat = mapView.myLocation?.coordinate.latitude else { return }
        guard let currentLocationLong = mapView.myLocation?.coordinate.longitude else { return }
        
        let pinLocation = CLLocation(latitude: currentLocationLat, longitude: currentLocationLong)
        
        geoCoder.reverseGeocodeLocation(pinLocation) { (places, err) in
            if let places = places {
                if let location = places.first?.location {
                    let place = places.first
                    // add textfield text here
                    
                }
            }
        }
    }
    
    
}


// MARK: - UITableViewDelegate, UITableViewDatasource

extension HomeController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        cell.place = searchResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = self.searchResults[indexPath.row]
        guard let pickupCoordinates = locationManager?.location?.coordinate else { return }
        
        configureMapView(config: .exceptMapView)
        view.bringSubviewToFront(actionButton)
        view.bringSubviewToFront(rideActionView)
        gmapView.alpha = 1
        configureActionButton(config: .dismissActionView)
        
        DispatchQueue.main.async {
            self.dismissLocationInputView { _ in
                self.markerConfiguration()
                self.findRouteOnMap(pickup: pickupCoordinates, destination: selectedPlace.coordinate) { (route) in
                    self.makePolylineAnimation(route: route ?? [])
                
                    self.createCustomMarkerInfoWindow(infoWindowText: selectedPlace.name ?? "Formatted adress", timeLabelText: "5", infoWindowWidth: 70 , isStartMarkerIW: false, markerLocation: selectedPlace.coordinate)
                    
                    self.placesClient.currentPlace { (placeList, er) in
                        
                        guard let place = placeList?.likelihoods.first?.place else { return }
                        self.createCustomMarkerInfoWindow(infoWindowText: place.name!, timeLabelText: "7", infoWindowWidth: 70, isStartMarkerIW: true, markerLocation: place.coordinate)
                    }
                                                            
                    self.animateRideActionView(shouldShow: true, destination: selectedPlace)
                }
            }
        }
        
        
    }
}

// MARK: - Map Helper Functions

extension HomeController {
    func searchBy(naturalLanguageQuery: String, completion: @escaping([GMSPlace]) -> Void) {
        
        var searchResults = [GMSPlace]()
        let token = GMSAutocompleteSessionToken.init()
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.countries = ["TR"]
        placesClient.findAutocompletePredictions(fromQuery: naturalLanguageQuery, filter: filter, sessionToken: token, callback: { (results, err) in
            
            if let results = results {
                for result in results {
                    
                    let placeId = result.placeID
                    self.placesClient.lookUpPlaceID(placeId) { (place, err) in
                        guard let place = place else { return }
                        searchResults.append(place)
                        completion(searchResults)
                    }
                }
            }
        })
    }
    
    func findRouteOnMap(pickup: CLLocationCoordinate2D,
                        destination: CLLocationCoordinate2D,
                        onCompleted: @escaping ([CLLocationCoordinate2D]?)->()) {
        
        let sourcePlacePoint = MKPlacemark(coordinate: pickup, addressDictionary: nil)
        let destinationPlacePoint = MKPlacemark(coordinate: destination, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacePoint)
        let destinationMapItem = MKMapItem(placemark: destinationPlacePoint)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            onCompleted(response?.routes.first?.polyline.coordinates)
        }
    }
    
    
    func makePolylineAnimation(route: [CLLocationCoordinate2D]) {
        self.animatePolyline = AnimatePolyline(mapView: self.gmapView)
        self.animatePolyline?.route = route
        self.animatePolyline?.startAnimation()
        //        self.gmapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: route.path), withPadding: 50.0))
        let insets = UIEdgeInsets(top: 100, left: 70, bottom: 320, right: 70)
        self.gmapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: route.path), with: insets))
        
    }
    
    func removeAnnotationsAndOverlays() {
        if markers.contains(where: {!$0.isKind(of: DriverMarker.self)}) {
            markers.removeAll(where: { !$0.isKind(of: DriverMarker.self)})
            self.animatePolyline?.pauseAnimation()
            self.animatePolyline?.disregardEvents()
        }
    }
    
    func createCustomMarkerInfoWindow(infoWindowText: String, timeLabelText: String, infoWindowWidth: CGFloat, isStartMarkerIW: Bool, markerLocation: CLLocationCoordinate2D) {
        
        
        let biggerInfoWindow = UIView()
        biggerInfoWindow.backgroundColor = .clear
        
        let infoWindowHeight = isStartMarkerIW ? 60 : 45
        
        let frame = CGRect(x: infoWindowWidth + 5, y: 0, width: infoWindowWidth, height: CGFloat(infoWindowHeight))
        let infoWindowView = InfoWindowView(frame: frame, isStartMarkerIW: isStartMarkerIW, timeLabelText: timeLabelText, infoWindowText: infoWindowText)
        infoWindowView.locationLabel.text = infoWindowText
        infoWindowView.layoutIfNeeded()
        
        let targetSize = CGSize(width: 170, height: 60)
        let estimatedSize = infoWindowView.systemLayoutSizeFitting(targetSize)
        infoWindowView.frame.size = CGSize(width: estimatedSize.width, height: estimatedSize.height)
        
        biggerInfoWindow.addSubview(infoWindowView)
        infoWindowView.translatesAutoresizingMaskIntoConstraints = false

        infoWindowView.addShadow(shadowColor: .black, offSet: CGSize(width: 0.5, height: 0.5), opacity: 0.65, shadowRadius: 1)
        
        let marker = GMSMarker()
        marker.iconView = biggerInfoWindow
        marker.iconView?.setDimensions(height: CGFloat(estimatedSize.height + 5) , width: CGFloat((estimatedSize.width * 2) + 5))

        marker.map = self.gmapView
        marker.position = markerLocation
        self.markers.append(marker)
    }
}


// MARK: - RideActionViewDelegate

extension HomeController: RideActionViewDelegate {
    func handleConfirmRidePressed(_ view: RideActionView) {
        guard let pickupCoordinates = locationManager?.location?.coordinate else { return }
        guard let destionationCoordinates = view.destination?.coordinate else { return }
        
        Service.uploadTrip(pickupCoordinates, destionationCoordinates) { (err, ref) in
            
        }
        enableLocationServices()
    }
}

// MARK: - MainHeaderViewDelegate

extension HomeController: MainHeaderViewDelegate {
    func handleStartTripButtonPressed() {
        locationInputActivatorView.alpha = 0
        headerView.alpha = 0
        mapTitleLabel.alpha = 0
        configureMapView(config: .exceptMapView)
        gmapView.alpha = 0
        configureLocationInputView()
        
    }
}

// MARK: - PickupControllerDelegate

extension HomeController: PickupControllerDelegate {
    func didAcceptTrip(_ trip: Trip) {
        self.trip?.state = .accepted
        self.dismiss(animated: true, completion: nil)
    }
}

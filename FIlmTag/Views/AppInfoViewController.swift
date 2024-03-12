//
//  AppInfoViewController.swift
//  FilmTag
//
//  Created by br3nd4nt on 12.03.2024.
//
import MapKit
import CoreLocation
import UIKit

class AppInfoViewController: UIViewController {
    
    private let developedTitle: UILabel = UILabel()
    private let developedText: UILabel = UILabel()
    private let mapTitle: UILabel = UILabel()
    private let map: MKMapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    private func configureUI() {
        view.addSubview(developedTitle)
        developedTitle.text = "Developed by: "
        developedTitle.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        developedTitle.pinLeft(to: view, 20)
        developedTitle.font = UIFont.boldSystemFont(ofSize: 50)
        
        view.addSubview(developedText)
        developedText.text = "Belov Vladislav\nGroup BSE 225 of HSE FCS"
        developedText.pinTop(to: developedTitle.bottomAnchor, 20)
        developedText.pinLeft(to: view, 20)
        developedText.font = UIFont.systemFont(ofSize: 30)
        developedText.numberOfLines = 0
        
        view.addSubview(mapTitle)
        mapTitle.text = "HSE FCS: 11 Pokrovsky Boulevard, Moscow, Russia"
        mapTitle.numberOfLines = 0
        mapTitle.pinTop(to: developedText.bottomAnchor, 20)
        mapTitle.pinLeft(to: view, 20)
        mapTitle.pinRight(to: view, 20)
        mapTitle.font = UIFont.systemFont(ofSize: 30)
        
        view.addSubview(map)
        map.pinTop(to: mapTitle.bottomAnchor, 10)
        map.pinLeft(to: view, 20)
        map.pinRight(to: view, 20)
        map.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 20)
//        let center = CLLocationCoordinate2D(latitude: 37.649439, longitude: 55.753994)
        let center = CLLocationCoordinate2D(latitude: 55.753994, longitude: 37.649439)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: true)

        // Create an annotation for the given location
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        map.addAnnotation(annotation)

        // Disable user interaction on the map
        map.isUserInteractionEnabled = false
    }
}

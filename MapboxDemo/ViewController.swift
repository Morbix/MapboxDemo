//
//  ViewController.swift
//  MapboxDemo
//
//  Created by Henrique Morbin on 22/12/15.
//  Copyright © 2015 Henrique Morbin. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController {

    var mapView: MGLMapView!
    let brasilLocation = CLLocationCoordinate2D(latitude: -30.10185,
        longitude: -51.2963472)
    
    var coordinates = [CLLocationCoordinate2D]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUpMapbox()
        addMockPoint()
        drawShape()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUpMapbox(){
        // initialize the map view
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURL())
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // set the map's center coordinate
        mapView.setCenterCoordinate(brasilLocation,
            zoomLevel: 12, animated: false)
        view.addSubview(mapView)
        
        mapView.delegate = self
        
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("mapTapped:")))
    }

    func mapTapped(tap: UITapGestureRecognizer){
        let point = tap.locationInView(tap.view)
        
        fire(point)
    }
    
    func addMockPoint(){
        // Declare the annotation `point` and set its coordinates, title, and subtitle
        let point = MGLPointAnnotation()
        point.coordinate = brasilLocation
        point.title = "Brasil"
        point.subtitle = "Welcome to The Jungle."
        
        // Add annotation `point` to the map
        mapView.addAnnotation(point)
    }
    
    func drawShape() {
        // Create a coordinates array to hold all of the coordinates for our shape.
        coordinates = [
            CLLocationCoordinate2D(latitude: -30.10185, longitude: -51.2963472),
            CLLocationCoordinate2D(latitude: -31.10185, longitude: -50.2963472),
            CLLocationCoordinate2D(latitude: -32.10185, longitude: -51.7963472),
            CLLocationCoordinate2D(latitude: -31.41385, longitude: -49.6963472),
            CLLocationCoordinate2D(latitude: -31.20185, longitude: -50.1963472),
            CLLocationCoordinate2D(latitude: -30.65185, longitude: -50.2963472),
            CLLocationCoordinate2D(latitude: -30.1185, longitude: -50.2463472),
            CLLocationCoordinate2D(latitude: -31.90185, longitude: -50.8963472),
        ]
        
        //drawPath()
        
        let shape = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
        shape.title = "Estrela da morte"
        
        mapView.addAnnotation(shape)
    }

    
    func drawPath(){
        
        let shape = CAShapeLayer()
        view.layer.addSublayer(shape)
        shape.opacity = 0.5
        shape.lineWidth = 2
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = UIColor(hue: 0.786, saturation: 0.79, brightness: 0.53, alpha: 1.0).CGColor
        shape.fillColor = UIColor(hue: 0.786, saturation: 0.15, brightness: 0.89, alpha: 1.0).CGColor
        
        let points = coordinates.map { (location) -> CGPoint in
            return mapView.convertCoordinate(location, toPointToView: mapView)
        }
        
        let path = UIBezierPath()
        
        for (index, point) in points.enumerate(){
            
            if index == 0 {
                path.moveToPoint(point)
            }else{
                path.addLineToPoint(point)
            }
        }
        path.closePath()
        shape.path = path.CGPath
    }
    
    func fire(touched : CGPoint){
        let points = coordinates.map { (location) -> CGPoint in
            return mapView.convertCoordinate(location, toPointToView: mapView)
        }
        
        let path = UIBezierPath()
        
        for (index, point) in points.enumerate(){
            if index == 0 {
                path.moveToPoint(point)
            }else{
                path.addLineToPoint(point)
            }
        }
        
        path.closePath()
        
        if path.containsPoint(touched){
            print("Vc acertou a estrela da morte")
        }else{
            print("agua")
        }
    }
}

extension ViewController : MGLMapViewDelegate {
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        print("touched")
        return true
    }
    
    func mapView(mapView: MGLMapView, didSelectAnnotation annotation: MGLAnnotation) {
        print("touch annotation")
    }
    
    func mapView(mapView: MGLMapView, tapOnCalloutForAnnotation annotation: MGLAnnotation) {
        print("touch callout")
    }
    
    func mapView(mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.5
    }
    func mapView(mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return UIColor.whiteColor()
    }
    
    func mapView(mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return UIColor(red: 59/255, green: 178/255, blue: 208/255, alpha: 1)
    }
}


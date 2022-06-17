//
//  Coordinator.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 30.5.22..
//
import UIKit
import Foundation

//At this point we’ve created a Coordinator protocol defining what each coordinator needs to be able to do, a Storyboarded protocol to make it easier to create view controllers from a storyboard
protocol Coordinator: AnyObject{
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}//A property to store the navigation controller that’s being used to present view controllers. Even if you don’t show the navigation bar at the top, using a navigation controller is the easiest way to present view controllers.
    
    func start()//A start() method to make the coordinator take control. This allows us to create a coordinator fully and activate it only when we’re ready.
}

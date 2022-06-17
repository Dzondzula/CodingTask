//
//  MainCoordinator.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 30.5.22..
//

import Foundation
import UIKit
//The next step is to create our first coordinator, which will be responsible for taking control over the app as soon as it launches.
class MainCoordinator: NSObject, Coordinator,UINavigationControllerDelegate{
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    //The AppCoordinator class will be responsible for navigating the application, which implies that it needs access to a UINavigationController instance
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {return}
        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController){
            return
        }
        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a detail view controller
        if let detailViewController = fromViewController as? DetailViewController{
            // We're popping a detail view controller; end its coordinator

            childDidFinish(detailViewController.coordinator)

            //As you've seen, the reason the Back button is tricky is because it's not triggered by our coordinator. Fortunately, using the UINavigationControllerDelegate protocol can help us monitor those events cleanly.
        }
    }
    
    func start() {
        //we need to ask our navigation controller to tell us whenever a view controller is shown, by making our main coordinator its delegate.
        navigationController.delegate = self
        //Now we can detect when a view controller is shown. This means implementing the didShow method of UINavigationControllerDelegate, reading the view controller we’re moving from, making sure that we’re popping controllers rather than pushing them, then finally removing the child coordinator.
        
        let vc = ViewController.instantiate()
        //ethod to create an instance of our ViewController class, then pushes it onto the navigation controller.
        vc.coordinator = self
        vc.title = "Github Repos"
        navigationController.pushViewController(vc, animated: false)
    }
    func detailVC(to repo : GitInfo){
//        let child = DetailCoordinator(navigationController: navigationController)
//        childCoordinators.append(child)
//        child.parentCoordinator = self//wee need to set parent Coordinator
//        child.start()//It calls this↓
        let vc = DetailViewController.instantiate()
        vc.detailItem = repo
        //That sets the coordinator property of our initial view controller, so it’s able to send messages when its buttons are tapped.
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?){
        for (index, coordinator) in childCoordinators.enumerated(){
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

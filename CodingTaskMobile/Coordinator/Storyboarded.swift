//
//  Storyboarded.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 30.5.22..
//
import UIKit
import Foundation

protocol Storyboarded{//protocol that lets me create view controllers from a storyboard. As much as I like using storyboards, I don’t like scattering storyboard code through my project – getting all that out into a separate protocol makes my code cleaner and gives you the flexibility to change your mind later.
    static func instantiate() -> Self// returns an instance of whatever class you call it on.
}

extension Storyboarded where Self: UIViewController{
    static func instantiate() -> Self{
        let id = String(describing: self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }// finds the class name of the view controller you used it with, then uses that to find a storyboard identifier inside Main.storyboard.
}

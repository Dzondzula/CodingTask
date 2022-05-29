//
//  Extensions.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 29.5.22..
//

import UIKit

extension UIImageView{
    func loadImage(url : URL){
        DispatchQueue.global().async {
            [self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
            
        }
    }
}

typealias Dispatch = DispatchQueue

extension Dispatch {
    
    static func background(_ task: @escaping () -> ()) {
        Dispatch.global(qos: .background).async {
            task()
        }
    }
    
    static func main(_ task: @escaping () -> ()) {
        Dispatch.main.async {
            task()
        }
    }
}


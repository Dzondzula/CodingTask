//
//  TestHelpers.swift
//  ViewControllerTests
//
//  Created by Nikola Andrijasevic on 18.3.22..
//

import Foundation
import UIKit

func executeRunLoop() {
    RunLoop.current.run(until: Date())
}
func tap(_ button: UIButton){
    button.sendActions(for: .touchUpInside)
}



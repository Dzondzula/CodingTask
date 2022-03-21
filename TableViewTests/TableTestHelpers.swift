//
//  TableTestHelpers.swift
//  TableViewTests
//
//  Created by Nikola Andrijasevic on 20.3.22..
//

import Foundation
import UIKit


func executeRunLoop() {
    RunLoop.current.run(until: Date())
}
func putInWindow(_ vc: UIViewController){
    let window = UIWindow()
    window.rootViewController = vc
    window.isHidden = false
}
//section is 0 because our tableViewContains only one section so we dont bother to type 0 every time
func numberOfRows(in tableView: UITableView,section:Int = 0) -> Int? {
    tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section)
}
func cellForRow(in tableView: UITableView, row: Int, section: Int = 0)-> UITableViewCell?{
    tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: row, section: section))
}
func didSelect(in tableView: UITableView,row: Int,section:Int = 0){
    tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: row, section: section))
}

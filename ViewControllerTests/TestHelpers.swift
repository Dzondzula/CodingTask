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

func numberOfRows(in tableView: UITableView, section: Int = 0)-> Int?{
    tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section)
}
func numberOfSections(in tableView: UITableView) -> Int?{
    tableView.dataSource?.numberOfSections?(in: tableView)
}

func cellForRow(in tableView: UITableView, row:Int, section: Int = 0) -> UITableViewCell?{
    tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: row, section: section))
}
func didSelectRow(in tableView: UITableView, row:Int,section:Int = 0){
    tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: row, section: section))
}


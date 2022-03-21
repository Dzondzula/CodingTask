//
//  TableViewCell.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 16.3.22..
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var starCount: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    
    
  
    func config(with item: GitInfo){
        name.text = item.fullName
       starCount.text = "\(item.stargazersCount)"
       descriptions.text = item.description
    }

}

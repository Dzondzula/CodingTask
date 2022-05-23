//
//  CommitTableViewCell.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 23.5.22..
//

import UIKit

class CommitTableCell: UITableViewCell{
    let commitMessage : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: .current)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let comitterName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let commiterPicture: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(commiterPicture)
        addSubview(commitMessage)
        addSubview(comitterName)
        
        commiterPicture.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5).isActive = true
        commiterPicture.topAnchor.constraint(equalTo: topAnchor).isActive = true
        commiterPicture.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        commiterPicture.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 1/5).isActive = true
        
        commitMessage.topAnchor.constraint(equalTo: topAnchor,constant: 10).isActive = true
        commitMessage.leadingAnchor.constraint(equalTo: commiterPicture.trailingAnchor,constant: 5).isActive = true
        commitMessage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        comitterName.topAnchor.constraint(equalTo: commitMessage.bottomAnchor,constant: 20).isActive = true
        comitterName.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5).isActive = true
        comitterName.leadingAnchor.constraint(equalTo: commiterPicture.trailingAnchor,constant: 10).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func config(with item: Commit){
        comitterName.text = item.commit.author.name
        commitMessage.text = item.commit.message
        commiterPicture.loadImage(url: URL(string: item.committer.avatarUrl)!)
    }
}

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

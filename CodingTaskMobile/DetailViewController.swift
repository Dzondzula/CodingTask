//
//  DetailViewController.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 16.3.22..
//
import WebKit
import UIKit

class DetailViewController: UIViewController,WKNavigationDelegate {
    var detailItem: GitInfo?
   


    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var starForkView: RectangleBoxView!
    @IBOutlet weak var webView: WKWebView!
    var spinner = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        guard let detailItem = detailItem else {
            return
        }
      
        webView.navigationDelegate = self
        webView.addSubview(spinner)
        spinner.center = CGPoint(x: webView.bounds.width / 2, y: webView.bounds.height / 2)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        
        navigationItem.title = detailItem.fullName
        descriptionLabel.text = "\(String(describing: detailItem.description))"
        forksCountLabel.text = "\(detailItem.openIssues)"
        starsCountLabel.text = "\(detailItem.stargazersCount)"
        
        if let pictureUrl = URL(string: "\(detailItem.owner.avatarUrl)"){
            webView.load(URLRequest(url: pictureUrl))
        }
        
    }

}

extension DetailViewController{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        print("Unable to load flag")
    }
}

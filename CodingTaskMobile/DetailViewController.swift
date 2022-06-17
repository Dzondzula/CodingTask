//
//  DetailViewController.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 16.3.22..
//
import WebKit
import UIKit


class DetailViewController: UIViewController,WKNavigationDelegate,Storyboarded {
    weak var coordinator: MainCoordinator?
    var detailItem: GitInfo?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var starForkView: RectangleBoxView!
    @IBOutlet weak var webView: WKWebView!
    var session : URLSession
    var spinner = UIActivityIndicatorView()
    var gitCommits : [Commit] = []
    
    var tableViewModel: DetailTableViewModel!
    
    var viewModel: DetailVCViewModel!
    
    
    init(urlSession: URLSession = URLSession.shared){
        self.session = urlSession
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        session = URLSession.shared
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpOutlets()
        Dispatch.global(qos: .userInitiated).async{ [weak self] in
            
            if let detailItem = self?.detailItem {
                self?.viewModel = DetailVCViewModel(name: detailItem.fullName)
                self?.viewModel.getCommits{ result in
                    switch result{
                        
                    case .success(let commits):
                        self?.gitCommits = commits
                        Dispatch.main.async {
                            self?.tableView.reloadData()
                        }
                    case .failure(let error):
                        self?.showError(error.errorDescription!)
                    }
                }
            }
        }
    }
    
    //we need a way for DetailViewController to report back when its work has finished.we’re going to use this view controller being dismissed as our signal that the detailVC process has finished.
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        coordinator?.workFinished()//if your main coordinator needs to respond specifically to buying finishing – perhaps to synchronize user data, or cause some UI to refresh 
    //}
    
    private func showError(_ message: String) {
        let title = "Network problem"
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        present(alert, animated: true)
    }
    
    fileprivate func setUpOutlets() {
        guard let detailItem = detailItem else {
            return
        }
        tableView.register(CommitTableCell.self, forCellReuseIdentifier: "Commit")
        
        webView.navigationDelegate = self
        webView.addSubview(spinner)
        spinner.center = CGPoint(x: webView.bounds.width / 2, y: webView.bounds.height / 2)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        
        navigationItem.title = detailItem.fullName
        descriptionLabel.text = "Recent commits:"
        forksCountLabel.text = "\(detailItem.openIssues)"
        starsCountLabel.text = "\(detailItem.stargazersCount)"
        
        if let pictureUrl = URL(string: "\(detailItem.owner.avatarUrl)"){
            webView.load(URLRequest(url: pictureUrl))
        }
    }
}

extension DetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitCommits.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Commit",for: indexPath) as? CommitTableCell else {return UITableViewCell()}
        tableViewModel = DetailTableViewModel(committer: gitCommits)
        let model = tableViewModel.viewModel(for: indexPath.row)
        cell.config(withViewModel: model)
        
        return cell
        
    }
    
    
}
extension DetailViewController{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        print(error.localizedDescription)
    }
}


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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var starForkView: RectangleBoxView!
    @IBOutlet weak var webView: WKWebView!
    var session : URLSession
    var spinner = UIActivityIndicatorView()
    var gitCommits : [Commit] = []
    
    
    init(urlSession: URLSession = URLSession.shared){
        self.session = urlSession
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        session = URLSession.shared
        super.init(coder: coder)
    }
    
  
    
    fileprivate func extractedFunc(_ detailItem: GitInfo) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        guard let detailItem = detailItem else {
            return
        }
        extractedFunc(detailItem)
        
        getCommits(){ result in
            switch result{
                
            case .success(let commits):
                self.gitCommits = commits
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func getCommits(completion: @escaping (Result<[Commit],MyError>)-> Void){
        let resourceUrl = "https://api.github.com/repos/\(detailItem!.fullName)/commits"
        let url = URL(string: resourceUrl)!
        session.dataTask(with: url){ data, _, error in
            if let error = error {
                completion(.failure(MyError(message: error.localizedDescription)))
            }
            guard let data = data else {
                completion(.failure(MyError(message: "No data available")))
                return
            }
            do {
                let decoder = JSONDecoder()
               decoder.keyDecodingStrategy = .convertFromSnakeCase
                let gitCommit = try decoder.decode([Commit].self, from: data)
                let commitDetails = gitCommit
                print(commitDetails)
                completion(.success(commitDetails))
            } catch{
                completion(.failure(MyError(message: "Error while trying to fetch data")))
            }
      

            
        }.resume()
    }
    
    }

extension DetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitCommits.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Commit",for: indexPath) as? CommitTableCell else {return UITableViewCell()}
        cell.config(with: gitCommits[indexPath.row])
        
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
        print("Unable to load flag")
    }
}

//
//  ViewController.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 16.3.22..
//

import UIKit

protocol URLSessionProtocol{
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

class ViewController: UITableViewController,UISearchBarDelegate {

    @IBOutlet var search: UITableView!
    var git : [GitInfo] = [] {
        didSet{
            handleResults(git)
        }
    }
    var git2 = [GitInfo]()
    var handleResults: ([GitInfo]) -> Void = { print($0) }
    
    
    var isSorted = false
    private var dataTask: URLSessionDataTask?
    var session: URLSessionProtocol = URLSession.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData()
        let sortis = UIBarButtonItem(title: "Sort by least stars", style: .plain, target: self, action: #selector(sorting))
        sortis.accessibilityIdentifier = "Sort"
        sortis.isAccessibilityElement = true
        navigationItem.rightBarButtonItems = [sortis]
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 600
        
    }
    
    func fetchData(){
        let urlString = "https://api.github.com/search/repositories?q=created:%3E2022-03-08"
        let url = URL(string: urlString)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        session.dataTask(with: url){ data,response,error in
            var decoded : Informations?
            var errorMessage: String?
            if let error = error{
                errorMessage = error.localizedDescription
            } else if let response = response as? HTTPURLResponse,response.statusCode != 200{
                errorMessage = "Response:" + HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            } else if let data = data {
                do{
                 decoded = try decoder.decode(Informations.self, from: data)
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
                    DispatchQueue.main.async {
                      [weak self] in
                        guard let self = self else {return}
                        if let decoded = decoded {
                        self.git = decoded.items
                        self.git2 = self.git
                       // print("Here:\(decodedResponse.items)")
                        self.tableView.reloadData()
                    }
                        if let errorMessage = errorMessage {
                            self.showError(errorMessage)
                        }
                }
        }.resume()
          
    }
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return git2.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.config(with: git2[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.detailItem = git2[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        git2 = git
        if searchText == ""{
            git2 = git
        } else {
            git2 = git.filter{
                $0.fullName.lowercased().contains(searchText.lowercased())
            }
        }
        self.tableView.reloadData()
    }
   @objc func sorting(){
       if isSorted == false{
        git2.sort{ $0.stargazersCount < $1.stargazersCount}
        tableView.reloadData()
       navigationItem.rightBarButtonItem?.title = "Sort by most stars"
           isSorted.toggle()
       } else {
           git2.sort{ $0.stargazersCount > $1.stargazersCount}
           tableView.reloadData()
          navigationItem.rightBarButtonItem?.title = "Sort by least stars"
           isSorted.toggle()
       }
    }
    deinit {
    print(">> ViewController.deinit")
    }
}

extension URLSession: URLSessionProtocol{
    
}

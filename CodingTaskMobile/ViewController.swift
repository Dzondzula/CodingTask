//
//  ViewController.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 16.3.22..
//

import UIKit

protocol URLSessionProtocol{
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    //    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

class ViewController: UITableViewController,UISearchBarDelegate,Storyboarded {
    
    weak var coordinator :MainCoordinator?
    
    @IBOutlet var search: UITableView!
    var git : [GitInfo] = [] {
        didSet{
            handleResults(git)
        }
    }
    var git2 = [GitInfo]()
    var handleResults: ([GitInfo]) -> Void = { print($0) }
    
    
    var viewModel = VCViewModel(user: "octocat"){
        didSet{
            guard isViewLoaded else {return}
            
        }
    }
    var tableViewModel : RepositoryTabelViewModel!
    private var dataTask: URLSessionDataTask?
    var session: URLSessionProtocol = URLSession.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        Dispatch.global(qos: .userInitiated).async {
            self.viewModel.fetchData{ result in
            switch result{
                
            case .success(let result):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else {return}
                    
                    self.git = result
                    self.git2 = self.git
                    
                    self.tableView.reloadData()
                    
                }
            case .failure(let error):
                Dispatch.main.async{
                let errorMessage = error.localizedDescription
                self.showError(errorMessage)
            }
            }
        }
        }
        let sort = UIBarButtonItem(title: viewModel.sortedMost, style: .plain, target: self, action: #selector(sorting))
        //sort.accessibilityIdentifier = "Sort"
        sort.isAccessibilityElement = true
        navigationItem.rightBarButtonItems = [sort]
        
    }
    
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        Task{
    //            let result = await fetchData()
    //            switch result{
    //            case .success(let users):
    //                self.git = users
    //                self.git2 = git
    //                DispatchQueue.main.async {
    //                    self.tableView.reloadData()
    //                }
    //            case .failure(let error):
    //                showError(error.localizedDescription )
    //            }
    //        }
    //    }
    //        ❗️// MODERN CONCCURENCY - Ne koristim jer ne umem da testiram async-await❗️
    
    //    func fetchData() async -> Result<[GitInfo],MyError>{
    //        let urlString = "https://api.github.com/search/repositories?q=created:%3E2022-03-08"
    //        let url = URL(string: urlString)!
    //        let decoder = JSONDecoder()
    //        decoder.keyDecodingStrategy = .convertFromSnakeCase
    //
    //        do{
    //            let (data,response) = try await session.data(from: url, delegate: nil)
    //            guard let response = response as? HTTPURLResponse,response.statusCode != 200 else {
    //                return .failure(MyError(message: "Cannot make connection"))}
    //            let decoded = try decoder.decode(Informations.self, from: data)
    //            return .success(decoded.items)
    //
    //        }
    //        catch {
    //            return .failure(MyError(message: "Cannot procces data"))
    //        }
    
    
    private func showError(_ message: String) {
        let title = viewModel.networkError
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
    
    @objc func sorting(){
        if viewModel.isSorted{
            git2.sort{ $0.stargazersCount < $1.stargazersCount}
            tableView.reloadData()
            navigationItem.rightBarButtonItem?.title = viewModel.sortedMost
            viewModel.isSorted.toggle()
        } else {
            git2.sort{ $0.stargazersCount > $1.stargazersCount}
            tableView.reloadData()
            navigationItem.rightBarButtonItem?.title = viewModel.sortedLeast
            viewModel.isSorted.toggle()
        }
    }
    
    
    deinit {
        print(">> ViewController.deinit")
    }
}

extension URLSession: URLSessionProtocol{
    
}


extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return git2.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        tableViewModel = RepositoryTabelViewModel(repository: git2)
        let model =  tableViewModel.viewModel(for: indexPath.row)
        cell.config(withViewModel: model)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: String(describing: DetailViewController.self)) as! DetailViewController
        tableViewModel = RepositoryTabelViewModel(repository: git2)
        let repoDetail =  tableViewModel.viewModelDetail(for: indexPath.row)
        vc.detailItem = repoDetail
        coordinator?.detailVC(to: repoDetail)
        //navigationController?.pushViewController(vc, animated: true)
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
}

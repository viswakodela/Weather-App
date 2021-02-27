//
//  AddCityViewController.swift
//  Weather App
//
//  Created by Viswa Kodela on 2/21/21.
//

import UIKit
import Combine

class AddCityViewController: UIViewController {
    
    // MARK:- Layout Objects
    let searchController = UISearchController(searchResultsController: nil)
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        return tv
    }()
    let leftBarButtonItem = UIBarButtonItem(
        image: UIImage(named: "chevron.down"),
        style: .plain,
        target: nil,
        action: nil
    )
    private var subscribers = Set<AnyCancellable>()
    
    @Published
    private var selectedCity: City?
    
    // MARK:- properties
    private let viewModel = AddLocationViewModel()
    enum Section: Int {
        case results
    }
    
    private var dataSource: UITableViewDiffableDataSource<Section, LocationCellViewModel>!
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        configureTableView()
        
        viewModel
            .snapshotPublisher
            .sink { [unowned self] (snapshot) in
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &subscribers)
    }
    
    // MARK:- Helpers
    private func setupTableView() {
        tableView.rowHeight = 44
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    private func setupNavBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Add City"
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        searchController.searchBar.placeholder = "Search..."
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    private func configureTableView() {
        tableView.register(SelectLocationTableviewCell.self,
                           forCellReuseIdentifier: String(describing: LocationCellViewModel.self))
        
        dataSource = UITableViewDiffableDataSource.init(tableView: tableView, cellProvider: { (tv, indexPath, result) -> UITableViewCell? in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: result.identifier)
            (cell as? TableViewCellProtocol)?.update(with: result)
            return cell
        })
    }
}

extension AddCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel
            .geolocate(selectedIndex: indexPath.item)
            .map { $0 }
            .catch { error -> Just<City?> in
                Just(nil)
            }
            .compactMap{ $0 }
            .assign(to: &$selectedCity)
    }
    
}

extension AddCityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text
    }
}

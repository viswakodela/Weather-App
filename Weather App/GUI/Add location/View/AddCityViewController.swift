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
    private var cancellables = Set<AnyCancellable>()
    
    @Published
    private var selectedCity: City?
    
    // MARK:- properties
    private let viewModel = AddLocationViewModel()
    enum Section: Int {
        case results
    }
    
    struct Result: Identifiable, Equatable, Hashable {
        let id = UUID()
        let title: String
        let subtitle: String
    }
    
    private var dataSource: UITableViewDiffableDataSource<Section, Result>!
    
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
            .store(in: &cancellables)
    }
    
    // MARK:- Helpers
    private func setupTableView() {
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
        
        searchController.searchBar.placeholder = " Search..."
        searchController.searchResultsUpdater = self
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        dataSource = UITableViewDiffableDataSource.init(tableView: tableView, cellProvider: { (tv, indexPath, result) -> UITableViewCell? in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.textLabel?.text = result.title
            cell?.detailTextLabel?.text = result.subtitle
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

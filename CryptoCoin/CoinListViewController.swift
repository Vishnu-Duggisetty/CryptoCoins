//
//  CoinListViewController.swift
//  CryptoCoin
//
//  Created by Vishnu Duggisetty on 25/10/24.
//

import UIKit

class CoinListViewController: UIViewController {
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = CoinViewModel()
    private var filterButton: UIBarButtonItem!
    private var filterParentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        
        Task {
            await viewModel.loadCoins()
        }
    }
    
    private func setupUI() {
        setupNavigationBar()
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CoinCell.self, forCellReuseIdentifier: CoinCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        // Left-aligned title
        let titleLabel = UILabel()
        titleLabel.text = "COIN"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        titleLabel.textColor = .white
        
        // Search button on the right
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(toggleSearchBar))
        searchButton.tintColor = .white
        
        // Configure the search controller
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Coins"
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        searchController.isActive = true
        
        // Add filter button
        filterButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(showFilterOptions))
        filterButton.tintColor = .white
        navigationItem.rightBarButtonItems = [searchButton, filterButton]
    }
    
    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            guard let self else { return }
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
    }
}

extension CoinListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.identifier, for: indexPath) as! CoinCell
        let coin = viewModel.filteredCoins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
}

extension CoinListViewController: UISearchBarDelegate {
    @objc private func toggleSearchBar() {
        navigationItem.searchController = searchController
        searchController.isActive = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCoins(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchCoins(searchText: "")
    }
}

extension CoinListViewController: CoinFilterViewDelegate {
    @objc private func showFilterOptions() {
        filterParentView.subviews.forEach { $0.removeFromSuperview() }
        filterParentView.removeFromSuperview()
        let filterView = CoinFilterView()
        filterView.delegate = self
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        filterParentView = UIView(frame: CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 400))
        filterParentView.backgroundColor = .white
        filterParentView.layer.cornerRadius = 12
        filterParentView.addSubview(filterView)
        view.addSubview(filterParentView)
        
        // Layout for filter view
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: filterParentView.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: filterParentView.trailingAnchor),
            filterView.topAnchor.constraint(equalTo: filterParentView.topAnchor),
            filterView.bottomAnchor.constraint(equalTo: filterParentView.bottomAnchor)
        ])
        
        // Animate the bottom sheet
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.filterParentView.frame.origin.y = self.view.bounds.height - 400
        }
    }
    
    func didUpdateFilters(
        isActive: Bool,
        type: String,
        isNew: Bool,
        notApplied: Bool
    ) {
        if notApplied {
            viewModel.searchCoins(searchText: "")
            return
        }
        viewModel.filterCoins(isActive: isActive, type: type, isNew: isNew)
    }
}

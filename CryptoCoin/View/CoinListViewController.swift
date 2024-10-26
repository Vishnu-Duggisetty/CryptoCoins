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
    private var filterView = CoinFilterView()
    private var filterViewTopConstraint: NSLayoutConstraint!
    
    var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = .gray
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        loadCoins()
    }
    
    private func loadCoins() {
        Task {
            showLoader()
            await viewModel.loadCoins()
            hideLoader()
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
        
        setUpFilterView()
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
                self.updateTableBackgroundView()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            guard let self else { return }
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            DispatchQueue.main.async {
                self.present(alert, animated: true)
                self.updateTableBackgroundView()
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
    
    private func updateTableBackgroundView() {
        if tableView.numberOfRows(inSection: 0) == 0 {
            let noDataLabel = UILabel()
            noDataLabel.text = "No Data Available"
            noDataLabel.textColor = .gray
            noDataLabel.textAlignment = .center
            noDataLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            
            tableView.backgroundView = noDataLabel
        } else {
            tableView.backgroundView = nil
        }
    }
}

extension CoinListViewController: UISearchBarDelegate {
    @objc private func toggleSearchBar() {
        removeFilterView()
        navigationItem.searchController = searchController
        searchController.isActive = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        removeFilterView()
        viewModel.searchCoins(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeFilterView()
        viewModel.searchCoins(searchText: "")
    }
}

extension CoinListViewController: CoinFilterViewDelegate {
    func setUpFilterView() {
        filterView.delegate = self
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)
        filterViewTopConstraint = filterView.topAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            filterViewTopConstraint,
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 300)
        ])
        filterView.setupUI()
        view.bringSubviewToFront(filterView)
    }
    
    @objc private func showFilterOptions() {
        filterViewTopConstraint.constant = -300
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func didUpdateFilters(
        isActive: Bool,
        isInActive: Bool,
        type: String?,
        isNew: Bool
    ) {
        viewModel.filterCoins(
            isActive: isActive,
            inActive: isInActive,
            type: type,
            isNew: isNew
        )
    }
    
    func closeFilterView() {
        filterViewTopConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func removeFilters() {
        viewModel.removeFilters()
    }
    
    private func removeFilterView() {
        closeFilterView()
        filterView.subviews.forEach { $0.removeFromSuperview() }
        filterView.removeFromSuperview()
        filterView = CoinFilterView()
        setUpFilterView()
    }
}

extension CoinListViewController {
    func showLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if self.loader.superview == nil {
                self.view.addSubview(self.loader)
                
                NSLayoutConstraint.activate([
                    self.loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    self.loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
                ])
            }
            self.view.bringSubviewToFront(loader)
            self.loader.startAnimating()
        }
    }
    
    func hideLoader() {
        loader.stopAnimating()
        loader.removeFromSuperview()
    }
}

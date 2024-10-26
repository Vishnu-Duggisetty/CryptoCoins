//
//  CoinFilterView.swift
//  CryptoCoin
//
//  Created by Vishnu Duggisetty on 26/10/24.
//

import UIKit

protocol CoinFilterViewDelegate: AnyObject {
    func didUpdateFilters(isActive: Bool, isInActive: Bool, type: String?, isNew: Bool)
    
    func closeFilterView()
    func removeFilters()
}

class CoinFilterView: UIView {
    
    weak var delegate: CoinFilterViewDelegate?
    
    private var coinTypeSegmentedControl: UISegmentedControl!
    private var removeFilterButton: UIButton!
    private var closeButton: UIButton!
    private let filterView = UIView()
    private let activeSwitch = UISwitch()
    private let activeLabel = UILabel()
    private let inActiveSwitch = UISwitch()
    private let inActiveLabel = UILabel()
    private let isNewSwitch = UISwitch()
    private let isNewLabel = UILabel()
    private let coinTypeSegment = UISegmentedControl(items: ["All", "Coin", "Token"])
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .lightGray
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        removeFilterButton = UIButton(type: .system)
        removeFilterButton.setImage(UIImage(systemName: "trash"), for: .normal)
        removeFilterButton.tintColor = .red // Set icon color to red
        removeFilterButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(removeFilterButton)
        removeFilterButton.addTarget(self, action: #selector(removeFilters), for: .touchUpInside)
        
        closeButton = UIButton(type: .system)
        closeButton.setTitle("✖️", for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        
        activeLabel.text = "Active"
        activeLabel.translatesAutoresizingMaskIntoConstraints = false
        activeSwitch.translatesAutoresizingMaskIntoConstraints = false
        activeSwitch.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        
        inActiveLabel.text = "In Active"
        inActiveLabel.translatesAutoresizingMaskIntoConstraints = false
        inActiveSwitch.translatesAutoresizingMaskIntoConstraints = false
        inActiveSwitch.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        
        isNewLabel.text = "New"
        isNewLabel.translatesAutoresizingMaskIntoConstraints = false
        isNewSwitch.translatesAutoresizingMaskIntoConstraints = false
        isNewSwitch.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        
        coinTypeSegment.translatesAutoresizingMaskIntoConstraints = false
        coinTypeSegment.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        coinTypeSegment.selectedSegmentIndex = 0
        
        let isNewStack = UIStackView(arrangedSubviews: [isNewLabel, isNewSwitch])
        isNewStack.axis = .horizontal
        isNewStack.spacing = 10
        
        let activeStack = UIStackView(arrangedSubviews: [activeLabel, activeSwitch])
        activeStack.axis = .horizontal
        activeStack.spacing = 10
        
        let inActiveStack = UIStackView(arrangedSubviews: [inActiveLabel, inActiveSwitch])
        inActiveStack.axis = .horizontal
        inActiveStack.spacing = 10
        
        let mainStack = UIStackView(arrangedSubviews: [coinTypeSegment, isNewStack, activeStack, inActiveStack])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .leading
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            removeFilterButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            removeFilterButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            mainStack.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    @objc private func closeTapped() {
        delegate?.closeFilterView()
    }
    
    @objc private func removeFilters() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.coinTypeSegment.selectedSegmentIndex = 0
            self.activeSwitch.isOn = false
            self.inActiveSwitch.isOn = false
            self.isNewSwitch.isOn = false
            self.delegate?.removeFilters()
        }
    }
    
    @objc func filterChanged() {
        let coinType = coinTypeSegment.selectedSegmentIndex == 1 ? "coin" : coinTypeSegment.selectedSegmentIndex == 2 ? "token" : nil
        delegate?.didUpdateFilters(
            isActive: activeSwitch.isOn,
            isInActive: inActiveSwitch.isOn,
            type: coinType,
            isNew: isNewSwitch.isOn
        )
    }
}


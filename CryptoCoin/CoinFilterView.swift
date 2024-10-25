//
//  CoinFilterView.swift
//  CryptoCoin
//
//  Created by Vishnu Duggisetty on 26/10/24.
//

import UIKit

protocol CoinFilterViewDelegate: AnyObject {
    func didUpdateFilters(isActive: Bool, type: String, isNew: Bool, notApplied: Bool)
}

class CoinFilterView: UIView {
    
    weak var delegate: CoinFilterViewDelegate?
    
    private var isActiveSwitch: UISwitch!
    private var coinTypeSegmentedControl: UISegmentedControl!
    private var isNewSwitch: UISwitch!
    private var applyButton: UIButton!
    private var closeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        // Close Button
        closeButton = UIButton(type: .system)
        closeButton.setTitle("✖️", for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        
        // Active Switch
        isActiveSwitch = UISwitch()
        let activeLabel = UILabel()
        activeLabel.text = "Active"
        activeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let activeStack = UIStackView(arrangedSubviews: [activeLabel, isActiveSwitch])
        activeStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activeStack)
        
        // Coin Type Segmented Control
        coinTypeSegmentedControl = UISegmentedControl(items: ["All", "Type1", "Type2"]) // Adjust based on your coin types
        coinTypeSegmentedControl.selectedSegmentIndex = 0
        coinTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(coinTypeSegmentedControl)
        
        // New Switch
        isNewSwitch = UISwitch()
        let newLabel = UILabel()
        newLabel.text = "New Crypto"
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let newStack = UIStackView(arrangedSubviews: [newLabel, isNewSwitch])
        newStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(newStack)
        
        // Apply Button
        applyButton = UIButton(type: .system)
        applyButton.setTitle("Apply", for: .normal)
        applyButton.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(applyButton)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            activeStack.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 32),
            activeStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            coinTypeSegmentedControl.topAnchor.constraint(equalTo: activeStack.bottomAnchor, constant: 16),
            coinTypeSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            coinTypeSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            newStack.topAnchor.constraint(equalTo: coinTypeSegmentedControl.bottomAnchor, constant: 16),
            newStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            applyButton.topAnchor.constraint(equalTo: newStack.bottomAnchor, constant: 32),
            applyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            applyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func closeTapped() {
        superview?.removeFromSuperview()
        removeFromSuperview()
        delegate?.didUpdateFilters(isActive: false, type: "", isNew: false, notApplied: true)
    }
    
    @objc private func applyTapped() {
        let isActive = isActiveSwitch.isOn
        let selectedType = coinTypeSegmentedControl.selectedSegmentIndex == 0 ? "All" : coinTypeSegmentedControl.titleForSegment(at: coinTypeSegmentedControl.selectedSegmentIndex) ?? ""
        let isNew = isNewSwitch.isOn
        
        delegate?.didUpdateFilters(isActive: isActive, type: selectedType, isNew: isNew, notApplied: false)
        closeTapped()
    }
}


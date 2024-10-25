//
//  CoinCell.swift
//  CryptoCoin
//
//  Created by Vishnu Duggisetty on 26/10/24.
//

import UIKit

class CoinCell: UITableViewCell {
    
    static let identifier = "CoinCell"
    
    // UI Elements
    private let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let newImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup UI
    private func setupUI() {
        addSubview(coinImageView)
        addSubview(newImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        selectionStyle = .none
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            coinImageView.widthAnchor.constraint(equalToConstant: 40),
            coinImageView.heightAnchor.constraint(equalToConstant: 40),
            coinImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            coinImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            newImageView.widthAnchor.constraint(equalToConstant: 20),
            newImageView.heightAnchor.constraint(equalToConstant: 20),
            newImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            newImageView.topAnchor.constraint(equalTo: topAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: coinImageView.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: coinImageView.leadingAnchor, constant: -8),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    // Configure Cell
    func configure(with coin: Coin) {
        titleLabel.text = coin.name
        subtitleLabel.text = coin.symbol
        
        if coin.isActive {
            switch coin.cryptoType {
            case .Coin:
                coinImageView.image = UIImage(named: "coin")
            case .Token:
                coinImageView.image = UIImage(named: "token")
            }
        } else {
            coinImageView.image = UIImage(named: "inactive")
        }
        
        newImageView.image = coin.isNew ? UIImage(named: "new") : UIImage()
        
//        backgroundColor = coin.isActive ? .white : .lightGray.withAlphaComponent(0.5)
    }
}


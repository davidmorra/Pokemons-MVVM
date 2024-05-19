//
//  File.swift
//  
//
//  Created by Davit on 17.05.24.
//

import UIKit
import Common

class StatCollectionViewCell: CollectionViewCell {
    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return iconImageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let trailingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(trailingLabel)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            trailingLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            trailingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trailingLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
        ])

        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
    }

    func configure(with stat: PokemonStatsItem) {
        iconImageView.image = UIImage(systemName: stat.iconName)
        titleLabel.text = stat.statTitle
        trailingLabel.text = stat.statValue
    }
}

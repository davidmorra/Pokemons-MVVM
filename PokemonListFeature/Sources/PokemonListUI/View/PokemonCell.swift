//
//  PokemonCell.swift
//  Garage
//
//  Created by Davit on 15.05.24.
//

import UIKit
import Common
import Combine
import Shared

class PokemonCell: CollectionViewCell {
    private var cancellable: AnyCancellable?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.tintColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
    }
    
    func configure(with viewmodel: PokemonListItemViewModel, imageRepository: ImageLoaderRepository) {
        titleLabel.text = viewmodel.name.capitalized
        loadImage(for: viewmodel.id, placeholder: UIImage(resource: .placeholder), repository: imageRepository)
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        
        let horizontalPadding: CGFloat = 16
        let verticalPadding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            
            imageView.heightAnchor.constraint(equalToConstant: 160),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: verticalPadding)
        ])
    }
    
    func loadImage(for pokemonId: Int, placeholder: UIImage? = nil, repository: ImageLoaderRepository) {
        self.imageView.image = placeholder

        cancellable = repository.loadImage(for: pokemonId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: ()
                case .failure: ()
                }
            }, receiveValue: { [weak self] data in
                self?.imageView.setImage(UIImage(data: data), animated: true)
            })
        
    }

}

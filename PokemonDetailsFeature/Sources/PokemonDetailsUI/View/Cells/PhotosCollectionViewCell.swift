//
//  File.swift
//  
//
//  Created by Davit on 17.05.24.
//

import UIKit
import Common
import Combine
import Shared

class PhotosCollectionViewCell: CollectionViewCell {
    var cancellable: AnyCancellable?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        return imageView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])
    }
    
    func configure(with pokemonId: Int, imageLoaderRepository: ImageLoaderRepository) {
        cancellable = nil
        cancellable = imageLoaderRepository.loadImage(for: pokemonId)
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

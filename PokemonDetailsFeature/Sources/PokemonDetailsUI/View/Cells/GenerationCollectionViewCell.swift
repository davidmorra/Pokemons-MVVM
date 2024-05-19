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

class GenerationCollectionViewCell: CollectionViewCell {
    private var cancellable: AnyCancellable?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        cancellable = nil
    }
    
    func configure(with item: GenerationItem, imageLoaderRepository: ImageLoaderRepository) {
        cancellable = imageLoaderRepository
            .loadImage(path: Generate.generationImagePath(from: item.imageUrl))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: ()
                case .failure: ()
                }
            }, receiveValue: { [weak self] data in
                self?.imageView.setImage(UIImage(data: data), animated: false)
            })
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
//            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 80),
            
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}

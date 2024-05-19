//
//  PokemonDetailsViewController.swift
//
//
//  Created by Davit on 17.05.24.
//

import UIKit
import Combine
import Common
import Shared

public class PokemonDetailsViewController: UIViewController {
    enum Section: Int {
        case photos
        case stats
        case generations
    }
    
    enum Item: Hashable {
        case photoItem(URL?)
        case statItem(PokemonStatsItem)
        case generationsItem(GenerationItem)
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private var cancellables = Set<AnyCancellable>()
    private let imageLoaderRepository: ImageLoaderRepository
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerReusableCellWithClass(PhotosCollectionViewCell.self)
        collectionView.registerReusableCellWithClass(StatCollectionViewCell.self)
        collectionView.registerReusableCellWithClass(GenerationCollectionViewCell.self)
        collectionView.registerHeader(LabeledHeaderView.self)
        return collectionView
    }()

    private var datasource: DataSource!
    private let viewmodel: PokemonDetailsViewModel
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    public init(viewmodel: PokemonDetailsViewModel, imageLoaderRepository: ImageLoaderRepository) {
        self.viewmodel = viewmodel
        self.imageLoaderRepository = imageLoaderRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDataSource()
        
        viewmodel.viewDidLoad()
        
        setupBindigs()
    }
    
    private func setupBindigs() {
        applySnapshot(for: viewmodel.pokemon.imageUrl)

        viewmodel.$stats
            .dropFirst()
            .sink(receiveValue: { [weak self] in
                self?.applySnapshot(for: $0)
            })
            .store(in: &cancellables)
        
        viewmodel.$generations
            .dropFirst()
            .sink { [weak self] in
                self?.applySnapshot(for: $0)
            }
            .store(in: &cancellables)
        
        viewmodel.$isLoading
            .sink { [weak self] in
                self?.isLoading($0)
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Snapshots
    private func applySnapshot(for image: URL?) {
        var snapshot = datasource.snapshot()
        if !datasource.snapshot().sectionIdentifiers.contains(.photos) {
            snapshot.appendSections([.photos])
        }
        snapshot.appendItems([Item.photoItem(viewmodel.pokemon.imageUrl)], toSection: .photos)
        datasource.apply(snapshot)
    }

    private func applySnapshot(for stats: [PokemonStatsItem]) {
        var snapshot = datasource.snapshot()
        if !datasource.snapshot().sectionIdentifiers.contains(.stats) {
            snapshot.appendSections([.stats])
        }
        snapshot.appendItems(stats.map(Item.statItem), toSection: .stats)
        datasource.apply(snapshot)
    }
    
    private func applySnapshot(for generations: [GenerationItem]) {
        var snapshot = datasource.snapshot()
        if !datasource.snapshot().sectionIdentifiers.contains(.generations) {
            snapshot.appendSections([.generations])
        }
        snapshot.appendItems(generations.map(Item.generationsItem), toSection: .generations)
        datasource.apply(snapshot)
    }
    
    private func setupViews() {
        title = viewmodel.pokemon.name
        
        setupCollectionView()
        setupActivityIndicator()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.constrainToFill(view)
        collectionView.backgroundColor = .systemGray6
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 32).isActive = true
    }
    
    private func isLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    private func setupDataSource() {
        datasource = DataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
            
            switch item {
            case .photoItem:
                let cell = collectionView.dequeue(PhotosCollectionViewCell.self, indexPath: indexPath)
                cell.configure(with: viewmodel.pokemon.id, imageLoaderRepository: imageLoaderRepository)
                return cell
                
            case let .statItem(stat):
                let cell = collectionView.dequeue(StatCollectionViewCell.self, indexPath: indexPath)
                cell.configure(with: stat)
                return cell
                
            case let .generationsItem(generation):
                let cell = collectionView.dequeue(GenerationCollectionViewCell.self, indexPath: indexPath)
                cell.configure(with: generation, imageLoaderRepository: imageLoaderRepository)
                return cell
            }
        })
        
        datasource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            if elementKind == UICollectionView.elementKindSectionHeader {
                guard let section = Section(rawValue: indexPath.section) else { return nil }
                
                switch section {
                case .photos: return nil
                case .stats:
                    let header = collectionView.dequeueHeader(LabeledHeaderView.self, forIndexPath: indexPath)
                    header.configure(with: "Stats")
                    return header
                case .generations:
                    let header = collectionView.dequeueHeader(LabeledHeaderView.self, forIndexPath: indexPath)
                    header.configure(with: "Generations")
                    return header
                }
            }
            
            return .init()
        }
    }

    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [unowned self] sectionIndex, env in
            
            guard let sectionType = Section(rawValue: sectionIndex) else { fatalError() }
            
            switch sectionType {
            case .photos:
                return photoSectionLayout()
            case .stats:
                return infoSectionLayout()
            case .generations:
                return generationsSectionLayout()
            }
        }
    }
    
    private func photoSectionLayout() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .absolute(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        section.interGroupSpacing = 16
        return section
    }

    private func infoSectionLayout() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1/2

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .estimated(88))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(28)),
                  elementKind: UICollectionView.elementKindSectionHeader,
                  alignment: .topLeading)
        ]
        
        return section
    }
    
    private func generationsSectionLayout() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1/2

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        section.interGroupSpacing = 16
        
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(28)),
                  elementKind: UICollectionView.elementKindSectionHeader,
                  alignment: .topLeading)
        ]

        return section
    }

}

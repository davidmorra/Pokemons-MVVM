//
//  PokemonListViewController.swift
//  Garage
//
//  Created by Davit on 15.05.24.
//

import UIKit
import Combine
import Common
import ApiClient
import Shared

public class PokemonListViewController: UIViewController {
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PokemonListItemViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PokemonListItemViewModel>
    
    private var cancellables = Set<AnyCancellable>()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let viewmodel: PokemonListViewModel
    private let imageLoaderRepository: ImageLoaderRepository
    private var datasource: DataSource!

    public init(viewmodel: PokemonListViewModel, imageLoaderRepository: ImageLoaderRepository) {
        self.viewmodel = viewmodel
        self.imageLoaderRepository = imageLoaderRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewmodel.viewDidLoad()
        setupBindings()
    }
    
    private func setupViews() {
        title = "Pokemons"
        setupCollectionView()
        setupDataSource()
    }
    
    private func setupBindings() {
        viewmodel.$pokemons
            .sink { [weak self] pokemons in
                self?.updateSnapshot(with: pokemons)
            }
            .store(in: &cancellables)
        
        viewmodel.$error
            .dropFirst()
            .sink { [weak self] error in
                self?.presentAlert("Something went wrong")
            }
            .store(in: &cancellables)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.constrainToFill(view)
        collectionView.registerReusableCellWithClass(PokemonCell.self)
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
    }

    private func setupDataSource() {
        datasource = DataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, pokemon in
            let cell = collectionView.dequeue(PokemonCell.self, indexPath: indexPath)
            cell.configure(with: pokemon, imageRepository: imageLoaderRepository)
            
            if indexPath.row == self.viewmodel.pokemons.count - 1 {
                self.viewmodel.loadNextPage()
            }
            
            return cell
        })
    }
    
    private func updateSnapshot(with characters: [PokemonListItemViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters, toSection: .main)
        datasource.apply(snapshot)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let fraction: CGFloat = 1/2

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        section.interGroupSpacing = 16
                
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
    
    private func presentAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Retry", style: .default) { [unowned self] _ in
            viewmodel.reset()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension PokemonListViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = datasource.snapshot().itemIdentifiers[indexPath.row]
        viewmodel.onSelect(pokemon)
    }
}

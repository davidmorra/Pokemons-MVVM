import UIKit

extension UICollectionView {
    public func registerReusableCellWithClass<T: CollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    public func registerReusableCellWithClass<T: CollectionViewCell>(_ cellType: [T.Type]) {
        cellType.forEach {
            register($0, forCellWithReuseIdentifier: $0.reuseIdentifier)
        }
    }

    public func dequeue<T: CollectionViewCell>(_ viewType: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: viewType.reuseIdentifier, for: indexPath) as! T
    }

    public func registerHeader<T: CollectionReusableView>(_ viewType: T.Type) {
        self.register(
            viewType,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: viewType.reuseIdentifier
        )
    }
    
    public func registerFooter<T: CollectionReusableView>(_ viewType: T.Type) {
        self.register(
            viewType,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: viewType.reuseIdentifier
        )
    }

    public func dequeueHeader<T: CollectionReusableView>(_ viewType: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: viewType.reuseIdentifier,
            for: indexPath
        ) as! T
    }
    
    public func dequeueFooter<T: CollectionReusableView>(_ viewType: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: viewType.reuseIdentifier,
            for: indexPath
        ) as! T
    }
}


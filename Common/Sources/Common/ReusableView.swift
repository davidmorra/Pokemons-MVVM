import UIKit

public protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    public static var reuseIdentifier: String {
        if let component = String(describing: self).split(separator: ".").last {
            return String(component)
        } else {
            return ""
        }
    }
}

public typealias CollectionViewCell = UICollectionViewCell & ReusableView
public typealias CollectionReusableView = UICollectionReusableView & ReusableView

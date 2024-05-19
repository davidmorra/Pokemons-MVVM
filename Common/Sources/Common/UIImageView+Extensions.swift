//
//  File.swift
//
//
//  Created by Davit on 18.05.24.
//

import UIKit

public extension UIImageView {
    func setImage(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.3 : 0.0
        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: {
            self.image = image
            
        }, completion: nil)
    }
}

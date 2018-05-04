//
//  Zap
//
//  Created by Otto Suess on 27.04.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChild(viewController: UIViewController, to container: UIView) {
        addChildViewController(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(viewController.view)
        
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
            viewController.view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0),
            viewController.view.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            viewController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0)
        ])
        
        viewController.didMove(toParentViewController: self)
    }
}

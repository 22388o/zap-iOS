//
//  Library
//
//  Created by Otto Suess on 20.12.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import Bond
import Foundation
import Lightning

extension UIStoryboard {
    static func instantiateFavouriteProductsViewController(transactionService: TransactionService, productsViewModel: ProductsViewModel, shoppingCartViewModel: ShoppingCartViewModel) -> ZapNavigationController {
        let productViewController = StoryboardScene.PoS.productViewController.instantiate()
        productViewController.transactionService = transactionService
        productViewController.productsViewModel = productsViewModel
        productViewController.shoppingCartViewModel = shoppingCartViewModel
        
        let navigationController = ZapNavigationController(rootViewController: productViewController)
        navigationController.tabBarItem.image = Asset.tabbarFavourites.image
        navigationController.tabBarItem.title = "Favourites"

        return navigationController
    }
}

final class FavouriteProductsViewController: UIViewController, ShoppingCartPresentable {
    @IBOutlet private weak var payButton: UIButton!

    // swiftlint:disable implicitly_unwrapped_optional
    fileprivate var productsViewModel: ProductsViewModel!
    fileprivate var shoppingCartViewModel: ShoppingCartViewModel!
    fileprivate var transactionService: TransactionService!
    // swiftlint:enable implicitly_unwrapped_optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorites"
        
        Style.Button.background.apply(to: payButton)
        
        view.backgroundColor = UIColor.Zap.background
        
        navigationItem.largeTitleDisplayMode = .never

        addShoppingCartBarButton(shoppingCartViewModel: shoppingCartViewModel, selector: #selector(presentShoppingCart))
        
        setupPayButton(button: payButton, amount: shoppingCartViewModel.totalAmount)
    }
    
    @IBAction private func presentTipViewController(_ sender: Any) {
        presentTipViewController(transactionService: transactionService, fiatValue: shoppingCartViewModel.totalAmount.value)
    }
    
    @objc func presentShoppingCart() {
        presentShoppingCart(shoppingCartViewModel: shoppingCartViewModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageViewController = segue.destination as? FavouritePageViewController {
            pageViewController.productsViewModel = productsViewModel
            pageViewController.shoppingCartViewModel = shoppingCartViewModel
        }
    }
}

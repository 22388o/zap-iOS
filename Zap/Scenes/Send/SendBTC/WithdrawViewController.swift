//
//  Zap
//
//  Created by Otto Suess on 21.01.18.
//  Copyright © 2018 Otto Suess. All rights reserved.
//

import UIKit

final class WithdrawViewController: UIViewController {
    
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var amountInputView: AmountInputView!
    
    var withdrawViewModel: WithdrawViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "scene.withdraw.title".localized
        
        Style.label.apply(to: addressLabel)
        Style.button.apply(to: sendButton)
        sendButton.tintColor = .white
        
        addressLabel.text = withdrawViewModel?.address
        
        amountInputView.amountViewModel = withdrawViewModel
    }
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func sendButtonTapped(_ sender: Any) {
        withdrawViewModel?.send { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

//
//  ZapShared
//
//  Created by Otto Suess on 18.06.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import Foundation

final class RemovePinSettingsItem: SettingsItem {
    let title = "Remove Pin"
    
    func didSelectItem(from fromViewController: UIViewController) {
        AuthenticationService.shared.resetPin()
        fatalError("Crash to restart.")
    }
}

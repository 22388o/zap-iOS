//
//  Zap
//
//  Created by Otto Suess on 10.02.18.
//  Copyright © 2018 Otto Suess. All rights reserved.
//

import Bond
import BTCUtil
import Foundation
import Lightning

final class OpenChannelViewModel {
    private let lightningService: LightningService
    private let lightningNodeURI: LightningNodeURI
    
    var amount: Satoshi = 0
    
    init(lightningService: LightningService, lightningNodeURI: LightningNodeURI) {
        self.lightningService = lightningService
        self.lightningNodeURI = lightningNodeURI
    }
    
    func openChannel(callback: @escaping (Result<ChannelPoint>) -> Void) {
        lightningService.channelService.open(pubKey: lightningNodeURI.pubKey, host: lightningNodeURI.host, amount: amount, callback: callback)
    }
}

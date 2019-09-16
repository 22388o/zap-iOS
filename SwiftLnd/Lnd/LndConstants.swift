//
//  ZapShared
//
//  Created by Otto Suess on 26.06.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import Foundation
import SwiftBTC

public enum LndConstants {
    public static let minChannelSize: Satoshi = 20000
    public static let maxChannelSize: Satoshi = 16777215
    public static let maxLightningPaymentAllowed: Satoshi = 4294967

    public static let currentVersionNumber = Version.Number(string: "0.7.1")! // swiftlint:disable:this force_unwrapping
}

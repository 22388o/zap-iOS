//
//  ZapShared
//
//  Created by Otto Suess on 26.06.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import Bond
import Foundation
import Lightning
import SwiftLnd

final class RootViewModel: NSObject {
    enum State {
        case noWallet
        case connecting
        case noInternet
        case syncing
        case running
    }
    
    let state = Observable<State>(.connecting)
    
    private var connectionTimeoutTimer: Timer?
    private var syncingStartTime: Date?
    
    private(set) var lightningService: LightningService? {
        didSet {
            bindStateToLnd()
        }
    }
    var walletService: WalletService {
        return WalletService(connection: LndConnection.current)
    }

    func start() {
        ExchangeUpdaterJob.start()
        setInitialState()
    }
    
    private func setInitialState() {
        switch LndConnection.current {
        case .none:
            state.value = .noWallet
        default:
            state.value = .connecting
            connect()
        }
    }
    
    func stop() {
        ExchangeUpdaterJob.stop()
        lightningService?.stop()
        LocalLnd.stop()
    }
    
    func connect() {
        state.value = .connecting
        
        let connection = LndConnection.current
        
        #if !LOCALONLY
        if case .local = connection {
            walletService.unlockWallet { _ in }
        }
        #endif
        
        guard let lightningService = LightningService(connection: connection) else { return }
        self.lightningService = lightningService
        lightningService.start()
        
        connectionTimeoutTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            self?.connectionTimeoutTimer = nil
            self?.state.value = .noWallet
        }
    }
    
    func disconnect() {
        self.lightningService = nil
        lightningService?.stop()
        setInitialState()
    }
    
    private func bindStateToLnd() {
        _ = lightningService?.infoService.walletState
            .skip(first: 1)
            .filter(filterSyncing)
            .distinct()
            .map(stateForInfoState)
            .feedNext(into: state)
            .observeNext { [weak self] _ in
                self?.connectionTimeoutTimer?.invalidate()
                self?.connectionTimeoutTimer = nil
            }
            .dispose(in: reactive.bag)
    }
    
    private func stateForInfoState(_ state: InfoService.State) -> RootViewModel.State {
        switch state {
        case .connecting:
            return handleConnectingState()
        case .noInternet:
            return .noInternet
        case .syncing:
            return .syncing
        case .running:
            return .running
        }
    }
    
    private func handleConnectingState() -> State {
        if case .remote = LndConnection.current {
            lightningService?.stop()
            lightningService = nil
            return .noWallet
        } else {
            return .connecting
        }
    }
    
    // add 3 second debounce to syncing, so we don't switch to sync screen when the app is running and a new block is found.
    private func filterSyncing(newState: InfoService.State) -> Bool {
        if state.value == .running && newState == .syncing {
            if let syncingStartTime = syncingStartTime {
                if syncingStartTime.addingTimeInterval(3) < Date() {
                    self.syncingStartTime = nil
                    return true
                }
            } else {
                syncingStartTime = Date()
            }
            return false
        }
        return true
    }
}

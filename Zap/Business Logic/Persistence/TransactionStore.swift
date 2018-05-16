//
//  Zap
//
//  Created by Otto Suess on 15.05.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import Bond
import Foundation

final class TransactionStore {
    let transactions: Observable<[TransactionViewModel]>
    
    init() {
        transactions = Observable([])
    }
    
    func update(transactions newTransactions: [Transaction]) {
        var viewModels = [TransactionViewModel]()
        for transaction in newTransactions where !exists(transaction) {
            viewModels.append(transcactionViewModel(for: transaction))
        }
        transactions.value += viewModels
    }
    
    func updateAnnotation(_ annotation: TransactionAnnotation, for transactionViewModel: TransactionViewModel) {
        if annotation.isHidden,
            let index = transactions.value.index(where: {
                areTransactionsEqual(lhs: $0, rhs: transactionViewModel)
            }) {
            
            var newTransactions = transactions.value
            newTransactions.remove(at: index)
            transactions.value = newTransactions
        }
    }
    
    // MARK: - Private, refactor this shit
    
    private func areTransactionsEqual(lhs: TransactionViewModel, rhs: TransactionViewModel) -> Bool {
        if let lhs = lhs as? OnChainTransactionViewModel,
            (rhs as? OnChainTransactionViewModel)?.onChainTransaction == lhs.onChainTransaction {
            return true
        } else if let lhs = lhs as? LightningPaymentViewModel,
            (rhs as? LightningPaymentViewModel)?.lightningPayment == lhs.lightningPayment {
            return true
        } else if let lhs = lhs as? LightningInvoiceViewModel,
            (rhs as? LightningInvoiceViewModel)?.lightningInvoice == lhs.lightningInvoice {
            return true
        }
        
        return false
    }
    
    private func exists(_ transaction: Transaction) -> Bool {
        for existingTransaction in transactions.value {
            if let existingTransaction = existingTransaction as? OnChainTransactionViewModel,
                (transaction as? OnChainTransaction) == existingTransaction.onChainTransaction {
                return true
            } else if let existingTransaction = existingTransaction as? LightningPaymentViewModel,
                (transaction as? LightningPayment) == existingTransaction.lightningPayment {
                return true
            } else if let existingTransaction = existingTransaction as? LightningInvoiceViewModel,
                (transaction as? LightningInvoice) == existingTransaction.lightningInvoice {
                return true
            }
        }
        return false
    }
    
    private func transcactionViewModel(for transaction: Transaction) -> TransactionViewModel {
        let annotation = TransactionAnnotation(isHidden: false, customMemo: nil)
        
        if let transaction = transaction as? OnChainTransaction {
            return OnChainTransactionViewModel(onChainTransaction: transaction, annotation: annotation)
        } else if let transaction = transaction as? LightningPayment {
            return LightningPaymentViewModel(lightningPayment: transaction, annotation: annotation)
        } else if let transaction = transaction as? LightningInvoice {
            return LightningInvoiceViewModel(lightningInvoice: transaction, annotation: annotation)
        } else {
            fatalError("type not implemented")
        }
    }
}

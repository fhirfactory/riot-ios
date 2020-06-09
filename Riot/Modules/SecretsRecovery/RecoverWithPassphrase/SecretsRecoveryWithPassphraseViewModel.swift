/*
 Copyright 2020 New Vector Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

final class SecretsRecoveryWithPassphraseViewModel: SecretsRecoveryWithPassphraseViewModelType {
    
    // MARK: - Properties
    
    // MARK: Private
    
    private let recoveryService: MXRecoveryService
    private var currentHTTPOperation: MXHTTPOperation?
    
    // MARK: Public
    
    var passphrase: String?
    
    var isFormValid: Bool {
        return self.passphrase?.isEmpty == false
    }
    
    weak var viewDelegate: SecretsRecoveryWithPassphraseViewModelViewDelegate?
    weak var coordinatorDelegate: SecretsRecoveryWithPassphraseViewModelCoordinatorDelegate?
    
    // MARK: - Setup
    
    init(recoveryService: MXRecoveryService) {
        self.recoveryService = recoveryService
    }
    
    deinit {
        self.currentHTTPOperation?.cancel()
    }
    
    // MARK: - Public
    
    func process(viewAction: SecretsRecoveryWithPassphraseViewAction) {
        switch viewAction {
        case .recover:
            self.recoverWithPassphrase()
        case .cancel:
            self.coordinatorDelegate?.secretsRecoveryWithPassphraseViewModelDidCancel(self)
        case .unknownPassphrase:
            self.coordinatorDelegate?.secretsRecoveryWithPassphraseViewModelDoNotKnowPassphrase(self)
        }
    }
    
    // MARK: - Private
    
    private func recoverWithPassphrase() {
        guard let passphrase = self.passphrase else {
            return
        }
        
        self.update(viewState: .loading)
        
        self.recoveryService.privateKey(fromPassphrase: passphrase, success: { [weak self] privateKey in
            guard let self = self else {
                return
            }
            
            self.recoveryService.recoverSecrets(nil, withPrivateKey: privateKey, recoverServices: true, success: { [weak self] recoveryResult in
                guard let self = self else {
                    return
                }                
                self.update(viewState: .loaded)
                self.coordinatorDelegate?.secretsRecoveryWithPassphraseViewModelDidRecover(self)
            }, failure: { [weak self] error in
                guard let self = self else {
                    return
                }
                self.update(viewState: .error(error))
            })
            
        }, failure: { [weak self] error in
            guard let self = self else {
                return
            }
            self.update(viewState: .error(error))
        })
    }
    
    private func update(viewState: SecretsRecoveryWithPassphraseViewState) {
        self.viewDelegate?.secretsRecoveryWithPassphraseViewModel(self, didUpdateViewState: viewState)
    }
}

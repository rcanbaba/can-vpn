//
//  ViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 19.12.2022.
//

import UIKit

class InitialViewController: UIViewController {
    
    private var connectionState = ConnectionState.initial {
        didSet {
            setUIState()
        }
    }
    
    private lazy var mainView = MainScreenView()

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        setUIState()
    }
    
    override func loadView() {
        view = mainView
    }
    
    
    private func setUIState() {
        mainView.setStateLabel(text: connectionState.getStateText())
        mainView.setUserInteraction(isEnabled: true)
    }
    
    private func setVPN() {
        switch connectionState {
        case .initial:
            connectionState = .connecting
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.connectionState = .connected
            }
        case .connect:
            connectionState = .connecting
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.connectionState = .connected
            }
        case .connecting:
            break
        case .connected:
            connectionState = .disconnecting
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.connectionState = .disconnected
            }
        case .disconnect:
            connectionState = .disconnecting
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.connectionState = .disconnected
            }
        case .disconnecting:
            break
        case .disconnected:
            connectionState = .connecting
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.connectionState = .connected
            }
        }
    }
}

extension InitialViewController: MainScreenViewDelegate {
    func stateViewTapped() {
        setVPN()
//        switch connectionState {
//        case .initial, .connect, .disconnected:
//            connectionState = .connecting
//        case .connecting, .connected, .disconnect, .disconnecting:
//            connectionState = .disconnecting
//        }
        
    }
}

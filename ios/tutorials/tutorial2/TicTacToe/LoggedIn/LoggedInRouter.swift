//
//  LoggedInRouter.swift
//  TicTacToe
//
//  Created by Varun Santhanam on 7/9/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import RIBs

protocol LoggedInInteractable: Interactable, OffGameListener, TicTacToeListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
    
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
    
}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: LoggedInInteractable,
         viewController: LoggedInViewControllable,
         offGameBuilder: OffGameBuildable,
         ticTacToeBuilder: TicTacToeBuildable) {
        
        self.viewController = viewController
        self.offGameBuilder = offGameBuilder
        self.ticTacToeBuilder = ticTacToeBuilder
        super.init(interactor: interactor)
        interactor.router = self
        
    }
    
    override func didLoad() {
        
        super.didLoad()
        attachOffGame()
        
    }

    // MARK: - LoggedInRouting
    
    func cleanupViews() {
        if let currentChild = currentChild {
            viewController.dismiss(viewController: currentChild.viewControllable)
        }
    }
    
    func routeToTicTacToe() {
        
        detachCurrentChild()
        
        let ticTacToe = ticTacToeBuilder.build(withListener: interactor)
        currentChild = ticTacToe
        attachChild(ticTacToe)
        viewController.present(viewController: ticTacToe.viewControllable)
        
        
    }
    
    func routeToOffGame() {
        
        detachCurrentChild()
        attachOffGame()
        
    }

    // MARK: - Private

    private let viewController: LoggedInViewControllable
    private let offGameBuilder: OffGameBuildable
    private let ticTacToeBuilder: TicTacToeBuildable
    
    private var currentChild: ViewableRouting?
    
    private func attachOffGame() {
        
        let offGame = offGameBuilder.build(withListener: interactor)
        self.currentChild = offGame
        self.attachChild(offGame)
        viewController.present(viewController: offGame.viewControllable)
        
    }
    
    private func detachCurrentChild() {
        
        if let currentChild = currentChild {
            
            detachChild(currentChild)
            viewController.dismiss(viewController: currentChild.viewControllable)
            
        }
        
    }
}

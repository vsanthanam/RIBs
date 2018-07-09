//
//  LoggedInActionableItem.swift
//  TicTacToe
//
//  Created by Varun Santhanam on 7/9/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import RxSwift

public protocol LoggedInActionableItem: class {
    func launchGame(with id: String?) -> Observable<(LoggedInActionableItem, ())>
}

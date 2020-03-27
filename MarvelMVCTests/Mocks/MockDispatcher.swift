//
//  MockDispatcher.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 27/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
@testable import MarvelMVC

class MockDispatcher: Dispatcher {
    var queue: DispatchQueue

    public init() {
        queue = DispatchQueue.main
    }

    //Most definately not an async task
    func async(_ work: @escaping ()->Void) {
        work()
    }
}

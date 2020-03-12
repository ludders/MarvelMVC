//
//  Dispatcher.swift
//  MarvelMVC
//
//  Created by dludlow7 on 11/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

protocol Dispatcher {
    var queue: DispatchQueue { get }
    func async(_ work: @escaping ()->Void)
}

class MainDispatcher : Dispatcher {
    var queue: DispatchQueue

    public init() {
        queue = DispatchQueue.main
    }

    func async(_ work: @escaping ()->Void) {
        queue.async(execute: work)
    }
}

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

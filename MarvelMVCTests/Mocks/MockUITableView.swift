//
//  MockUITableView.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 11/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import UIKit

class MockUITableView: UITableView {

    var reloadRowsCalled: Bool = false
    var indexPathsUsed: [IndexPath]?

    public init() {
        super.init(frame: CGRect.zero, style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        reloadRowsCalled = true
        indexPathsUsed = indexPaths
    }
}

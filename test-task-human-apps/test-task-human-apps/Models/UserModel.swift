//
//  UserModel.swift
//  test-task-human-apps
//
//  Created by Александр Янчик on 21.02.25.
//

import Foundation

class UserModel: CellData {
    var name: String
    var cellIdentifier: String

    init (
        name: String,
        cellIdentifier: String = "UserInfoTableViewCell"
    ) {
        self.cellIdentifier = cellIdentifier
        self.name = name
    }
}

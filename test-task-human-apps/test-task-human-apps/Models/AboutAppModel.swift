//
//  AboutAppData.swift
//  test-task-human-apps
//
//  Created by Александр Янчик on 22.02.25.
//


class AboutAppModel: CellData {
    let title: String
    let cellIdentifier: String = "AboutAppTableViewCell"
    
    init(title: String) {
        self.title = title
    }
}

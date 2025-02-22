//
//  GenericTableViewDataSource.swift
//  test-task-human-apps
//
//  Created by Александр Янчик on 22.02.25.
//

import UIKit


final class UniversalTableViewDataSource: NSObject, UITableViewDataSource {
    private(set) var data: [CellData] = []

    func updateData(_ data: [CellData]) {
        self.data = data
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return data.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cellData = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellData.cellIdentifier, for: indexPath)
        
        switch cellData {
            case let aboutAppData as AboutAppModel:
                (cell as? AboutAppTableViewCell)?.configure(with: aboutAppData)
            default:
                break
        }
        
        return cell
    }
}

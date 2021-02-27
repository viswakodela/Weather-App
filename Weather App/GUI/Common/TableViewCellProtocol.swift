//
//  TableViewCellProtocol.swift
//  Weather App
//
//  Created by Viswa Kodela on 2021-02-26.
//

import UIKit

protocol TableViewCellProtocol {
    var identifier: String { get }
    func update(with viewModel: TableViewCellModelProtocol)
}

protocol TableViewCellModelProtocol {
    var accessoryType: UITableViewCell.AccessoryType { get }
}

extension TableViewCellModelProtocol {
    var accessoryType: UITableViewCell.AccessoryType {
        return .none
    }
}

//
//  SelectLocationTableViewCell.swift
//  Weather App
//
//  Created by Viswa Kodela on 2021-02-26.
//

import UIKit

class SelectLocationTableviewCell: UITableViewCell {
    
    // MARK:- Layout Objects
    let titleLabel: UILabel = {
        let label = BodyLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFontWeight(.regular)
        return label
    }()
    
    // MARK:- init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:- Helpers
    private func configureLayout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK:- TableViewCellProtocol
extension SelectLocationTableviewCell: TableViewCellProtocol {
    var identifier: String {
        String(describing: SelectLocationTableviewCell.self)
    }
    
    func update(with viewModel: TableViewCellModelProtocol) {
        guard let viewModel = viewModel as? LocationCellViewModel else { return }
        titleLabel.text = viewModel.title + ", " + viewModel.subtitle
    }
}

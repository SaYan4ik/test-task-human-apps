//
//  UserInfoTableViewCell.swift
//  test-task-human-apps
//
//  Created by Александр Янчик on 22.02.25.
//

import UIKit


class AboutAppTableViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure(with aboutData: AboutAppModel) {
        setupViews()
        titleLabel.text = aboutData.title
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = Theme.backgroundPrimary
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
}

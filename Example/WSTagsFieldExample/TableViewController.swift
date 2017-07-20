//
//  TableViewController.swift
//  WSTagsFieldExample
//
//  Created by Ricardo Pereira on 28/04/2017.
//  Copyright © 2017 Whitesmith. All rights reserved.
//

import UIKit
import WSTagsField

class TableViewController: UITableViewController {

    let records = ["Festival", "Salvador", "EuroVision", "Beer"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.allowsSelection = false
        tableView.register(TagsViewCell.self, forCellReuseIdentifier: String(describing: TagsViewCell.self))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
        //tableView.beginUpdates()
        //tableView.endUpdates()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TagsViewCell.self),
                                                       for: indexPath) as? TagsViewCell else {
                                                        return UITableViewCell(style: .default, reuseIdentifier: nil)
        }

        cell.tagsField.onDidChangeHeightTo = { _ in
            tableView.beginUpdates()
            tableView.endUpdates()
        }

        return cell
    }

}

class TagsViewCell: UITableViewCell {

    let tagsField = WSTagsField()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tagsField.placeholder = "Enter a tag"
        tagsField.backgroundColor = .white
        //tagsField.frame = CGRect(x: 0, y: 0, width: 300, height: 44)
        tagsField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tagsField)

        NSLayoutConstraint.activate([
            tagsField.topAnchor.constraint(equalTo: contentView.topAnchor),
            tagsField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagsField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            //tagsField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            //tagsField.heightAnchor.constraint(equalToConstant: 44),
            //tagsField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: tagsField.bottomAnchor)
        ])

        tagsField.addTag("alksjlkasd")
        tagsField.addTag("alksjlkasd1")
        tagsField.addTag("alksjlkasd2")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

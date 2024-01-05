//
//  CustomActionSheet.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 05.01.2024.
//

import Foundation
import UIKit

protocol CustomActionDelegate: AnyObject {
    func onEditAction()
    func onDeleteAction()
}

class CustomActionSheet: UIViewController {
    weak var delegate: CustomActionDelegate?
    
    let actionSheetHeight: CGFloat = 250
    let buttonHeight: CGFloat = 70

    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundView = UIView(frame: CGRect(x: 0, y: view.frame.maxY - actionSheetHeight, width: view.frame.width, height: actionSheetHeight))
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.cornerRadius = 15
        view.addSubview(backgroundView)

        let editButton = createButton(title: "Изменить", iconName: "edit")
        editButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        editButton.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: buttonHeight)
        backgroundView.addSubview(editButton)

        let deleteButton = createButton(title: "Удалить", iconName: "trash")
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        deleteButton.frame = CGRect(x: 0, y: buttonHeight + 20, width: view.frame.width, height: buttonHeight)
        backgroundView.addSubview(deleteButton)
    }

    func createButton(title: String, iconName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)

        let iconImage = UIImage(named: iconName)?.resize(targetSize: CGSize(width: 25, height: 25))
        let iconImageView = UIImageView(image: iconImage)
        iconImageView.contentMode = .center
        iconImageView.frame = CGRect(x: 20, y: 15, width: 40, height: 40)
        iconImageView.backgroundColor = UIColor(rgb: 0x5458EA)
        iconImageView.layer.cornerRadius = 10

        button.addSubview(iconImageView)

        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "gothampro", size: 18)
        button.layer.cornerRadius = 0

        return button
    }

    @objc func editAction() {
        dismiss(animated: true, completion: nil)
        self.delegate?.onEditAction()
    }

    @objc func deleteAction() {
        dismiss(animated: true, completion: nil)
        self.delegate?.onDeleteAction()
    }
}

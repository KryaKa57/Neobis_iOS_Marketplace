//
//  TextFieldCell.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 04.01.2024.
//

import Foundation
import UIKit

class TextFieldTableViewCell: UITableViewCell {
    static var identifier = "TextFieldTableViewCell"
    
    class TextField: UITextField {
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 12, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 12, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 44)
        }
    }
    
    let textField: UITextField = {
        let tf = TextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Edit me"
        tf.font = UIFont(name: "gothampro", size: 16)
        tf.textColor = .black
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.frame = bounds
        addSubview(textField)
        
        backgroundColor = .white
        layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ placeholder: String) {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xC0C0C0),
            NSAttributedString.Key.font: UIFont(name: "gothampro", size: 16)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes as [NSAttributedString.Key : Any])
    }
}

extension UITextField {
    public func setPlaceholderColor(_ color: UIColor) {
        guard let placeholder = self.placeholder else { return }
        let attributes = [
            NSAttributedString.Key.foregroundColor: color
        ]
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
}


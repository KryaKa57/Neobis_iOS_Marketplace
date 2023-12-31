//
//  CodeInputView.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 28.12.2023.
//

import Foundation
import UIKit

open class CodeInputView: UIView, UIKeyInput {
  open var delegate: CodeInputViewDelegate?
  private var nextTag = 1

  // MARK: - UIResponder

  open override var canBecomeFirstResponder: Bool { true }

  // MARK: - UIView

  public override init(frame: CGRect) {
    super.init(frame: frame)

    var frame = CGRect(x: 85, y: 10, width: 35, height: 40)
    for index in 1...4 {
        let digitLabel = UILabel(frame: frame)
        digitLabel.font = .systemFont(ofSize: 42)
        digitLabel.tag = index
        digitLabel.text = "0"
        digitLabel.textColor = .black
        digitLabel.textAlignment = .center
        addSubview(digitLabel)
        frame.origin.x += 35 + 15
    }
  }

  // MARK: - NSCoding

  required public init?(coder: NSCoder) { fatalError("init(coder:) hasn't been implemented") }

  // MARK: - UIKeyInput

  public var hasText: Bool { nextTag > 1 ? true : false }

  open func insertText(_ text: String) {
    if nextTag < 5 {
      (viewWithTag(nextTag)! as! UILabel).text = text
      nextTag += 1

      if nextTag == 5 {
        var code = ""
        for index in 1..<nextTag {
          code += (viewWithTag(index)! as! UILabel).text!
        }
        delegate?.codeInputView(self, didFinishWithCode: code)
      }
    }
  }

  open func deleteBackward() {
    if nextTag > 1 {
      nextTag -= 1
      (viewWithTag(nextTag)! as! UILabel).text = "0"
    }
  }

  open func clear() { while nextTag > 1 { deleteBackward() } }

  // MARK: - UITextInputTraits

  open var keyboardType: UIKeyboardType { get { .numberPad } set { } }
}

public protocol CodeInputViewDelegate {
  func codeInputView(_ codeInputView: CodeInputView, didFinishWithCode code: String)
}

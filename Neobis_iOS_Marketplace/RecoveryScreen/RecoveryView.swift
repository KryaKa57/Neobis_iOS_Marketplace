//
//  RecoveryView.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 28.12.2023.
//

import Foundation
import UIKit
import SnapKit

class RecoveryView: UIView {
    private let systemBounds = UIScreen.main.bounds
    
    var seconds = 60
    var timer: Timer?
    
    lazy var phoneIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")?
                        .resize(targetSize: CGSize(width: 45, height: 45))
                        .withTintColor(UIColor(rgb: 0xFFFFFF, alpha: 0.5))
        
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor(rgb: 0x5458EA)
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите код из СМС"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "gothampro-medium", size: 22)
        return label
    }()
    
    lazy var phoneTextField = CodeInputView()
    
    lazy var nextButton = CustomButton(textValue: "Отправить еще раз", isPrimary: false)
    
    lazy var resendLabel: UILabel = {
        let label = UILabel()
        label.text = "Повторный запрос"
        label.textAlignment = .center
        label.textColor = UIColor(rgb: 0xC0C0C0)
        label.font = UIFont(name: "gothampro", size: 18)
        return label
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "01:00"
        label.textAlignment = .center
        label.textColor = UIColor(rgb: 0xC0C0C0)
        label.font = UIFont(name: "gothampro", size: 18)
        return label
    }()
    
    lazy var resendStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = .white
        
        startTimer()
        
        resendStackView.addArrangedSubview(resendLabel)
        resendStackView.addArrangedSubview(timerLabel)
        
        self.addSubview(phoneIconImageView)
        self.addSubview(mainLabel)
        self.addSubview(phoneTextField)
        self.addSubview(resendStackView)
    }
    
    private func setConstraints() {
        self.phoneIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(systemBounds.height * 0.15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(systemBounds.width / 5)
        }
        self.mainLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneIconImageView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(32)
        }
        self.phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(32)
        }
        self.resendStackView.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(64)
            make.centerX.equalToSuperview()
        }
    }
    
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = timeString(time: TimeInterval(seconds))

        if seconds <= 0 {
            timer?.invalidate()
            timer = nil
            resendLabel.removeFromSuperview()
            timerLabel.removeFromSuperview()
            resendStackView.removeArrangedSubview(resendLabel)
            resendStackView.removeArrangedSubview(timerLabel)
            resendStackView.addArrangedSubview(nextButton)
        }
    }
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

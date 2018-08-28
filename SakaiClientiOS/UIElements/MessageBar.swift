//
//  MessageBar.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/27/18.
//

import UIKit

class MessageBar: UIView {
    var inputField: ChatTextView!
    var sendButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        addViews()
        setConstraints()
    }
    
    func setup() {
        self.backgroundColor = UIColor.white
        
        inputField = ChatTextView()
        inputField.isScrollEnabled = false
        inputField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        inputField.textColor = AppGlobals.SAKAI_RED
        inputField.tintColor = AppGlobals.SAKAI_RED
        inputField.font = UIFont.systemFont(ofSize: 16)
        inputField.layer.cornerRadius = 5
        inputField.backgroundColor = UIColor.lightGray
        
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sendButton.tintColor = AppGlobals.SAKAI_RED
    }
    
    func addViews() {
        self.addSubview(inputField)
        self.addSubview(sendButton)
    }
    
    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        inputField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        inputField.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        inputField.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        inputField.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        inputField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -5.0).isActive = true
        inputField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.80).isActive = true
        
        sendButton.topAnchor.constraint(equalTo: inputField.topAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: inputField.bottomAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0).isActive = true
    }
    
}

//
//  TappableTextView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/19/18.
//

import UIKit

class TappableTextView: UITextView {
    
    var tapRecognizer: UITapGestureRecognizer!
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.isEditable = false
        self.isSelectable = true
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(deselectText))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func deselectText() {
        self.selectedTextRange = nil
    }
    
}

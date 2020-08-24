//
//  RichTextEditorViewControllerDelegate.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/15/19.
//

import Foundation

@objc protocol RichTextEditorViewControllerDelegate {
    @objc optional func editorController(_ editorController: RichTextEditorViewController,
                                         loadTextWithResult result: @escaping (String?) -> Void)

    @objc func editorController(
        _ editorController: RichTextEditorViewController,
        shouldSaveBody html: String?,
        didSucceed: @escaping (Bool) -> Void)
}

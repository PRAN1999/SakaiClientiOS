//
//  RichTextEditorViewControllerDelegate.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/15/19.
//

import Foundation

@objc protocol RichTextEditorViewControllerDelegate {
    @objc optional func editorController(_ editorController: RichTextEditorViewController,
                                         shouldSyncTextWithResult result: @escaping (String?) -> Void)

    @objc optional func editorController(_ editorController: RichTextEditorViewController,
                                         shouldSaveBody html: String,
                                         didSucceed: @escaping (Bool) -> Void)

    @objc optional func editorController(_ editorController: RichTextEditorViewController,
                                         shouldSaveTitle title: String,
                                         didSucceed: @escaping (Bool) -> Void)
}

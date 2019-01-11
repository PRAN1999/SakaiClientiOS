//
//  Interactable.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/11/19.
//

import UIKit

protocol Interactable {
    var interactionController: UIPercentDrivenInteractiveTransition? { get }
}

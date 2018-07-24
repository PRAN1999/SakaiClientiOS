//
//  HideableNetworkController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/23/18.
//

import ReusableSource

protocol HideableNetworkController: NetworkController where Self.Source: HideableNetworkSource {}

//
//  CommandParameter.swift
//  buildcannon
//
//  Created by Anderson Lucas C. Ramos on 13/06/18.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

protocol CommandParameter {
    var parameter: String { get }
    
    func buildParameter() -> String
}
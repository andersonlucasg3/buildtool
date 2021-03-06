//
//  Version.swift
//  buildcannon
//
//  Created by Anderson Lucas de Castro Ramos on 05/07/18.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

struct Version {
    private static let version = "1.3.0"
    
    static func printVersion() {
        Console.log(message: "buildcannon version \(self.version)")
    }
}

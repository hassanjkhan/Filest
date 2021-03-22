//
//  RandomCodeGenerator.swift
//  Filest
//
//  Created by Hassan on 2020-10-20.
//  Copyright © 2020 Z-Lux. All rights reserved.
//

import Foundation

class RandomCodeGenerator {
    var elements = ["A","B","C","D","E","F","H","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",]
    func GenerateCode() -> String{
        var code = ""
        for _ in 1...7 {
            code += elements[Int(arc4random_uniform(UInt32(elements.count)))]
        }
        return code
    }
}


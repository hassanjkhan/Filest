//
//  RandomCodeGenerator.swift
//  Filest
//
//  Created by admin on 2020-10-20.
//  Copyright © 2020 Z-Lux. All rights reserved.
//

import Foundation

class RandomCodeGenerator {
    
    var elements = ["1","2","3","4","5","6","7","8","9","0","A","B","C","D","E","F","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",]
    
    func GenerateCode() -> String{
        var code = ""
        for i in 1...7 {
            code += elements[Int(arc4random_uniform(UInt32(elements.count)))]
        }
        return code
    }
    
}


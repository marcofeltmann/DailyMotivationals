//
//  Tag.swift
//  Daily Motivational
//
//  Created by Marco Feltmann on 12.02.20.
//  Copyright © 2020 mfs. All rights reserved.
//

import Foundation

public struct Tag:Equatable {
    let title: String
    var limitation: String?
}

extension Tag {
    init(title: String, limitatingDate: Date) {
        self.title = title
        
        let dateFormatter = ISO8601DateFormatter()
        self.limitation = dateFormatter.string(from: limitatingDate)
    }
}

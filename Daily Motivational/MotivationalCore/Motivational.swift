//
//  Motivational.swift
//  Daily Motivational
//
//  Created by Marco Feltmann on 12.02.20.
//  Copyright © 2020 mfs. All rights reserved.
//

import Foundation

struct Motivational:Equatable {
    let uuid:UUID
    let message: String
    var media: MediaType?
    var tags: Array<Tag>?
}

extension Motivational {
    init(message: String, media:MediaType, tags:Array<Tag>) {
        self.uuid = UUID()
        self.message = message
        self.media = media
        self.tags = tags
    }
    
    init(message: String, tags:Array<Tag>) {
        self.uuid = UUID()
        self.message = message
        self.tags = tags
    }

    init(message: String, media:MediaType) {
        self.uuid = UUID()
        self.message = message
        self.media = media
    }
    
    init(message: String) {
        self.uuid = UUID()
        self.message = message
    }
}

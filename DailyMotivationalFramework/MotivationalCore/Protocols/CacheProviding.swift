//
//  CacheProviding.swift
//  Daily Motivational
//
//  Created by Marco Feltmann on 12.02.20.
//  Copyright © 2020 mfs. All rights reserved.
//

import Foundation

public protocol CacheProviding
{
    func cachedUUID()->(UUID, Date)
}

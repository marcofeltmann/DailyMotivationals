//
//  MediaType.swift
//  Daily Motivational
//
//  Created by Marco Feltmann on 12.02.20.
//  Copyright © 2020 mfs. All rights reserved.
//

import Foundation

/** Enumeration representing one type of media to interact with.
 
 MediaType distincts between three types of media:
 * `image` for presenting images
 * `video` for video playback
 * `audio` for audio playback
  */

public enum MediaType: Equatable {
    /// Image Media Type for display with correspoding file URL
    case image(URL)
    
    /// Video Media Type for playback with corresponding file URL
    case video(URL)
    
    /// Audio Media Type for playback with corresponding file URL
    case audio(URL)
}

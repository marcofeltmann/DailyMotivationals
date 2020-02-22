//
//  PickOfTheDay.swift
//  MotivationalCore
//
//  Created by Marco Feltmann on 12.02.20.
//  Copyright © 2020 mfs. All rights reserved.
//

import Foundation

/**
 
 Requirements

- has one Motivational Data type
- has one "valid until" date
- returns identical Motivational Data type as long as "valid until" is in the future
 
 Soooo. We need some calendar/date/whatever provider?
 A caching mechanism?
 
 
 */

public class PickOfTheDay
{
//MARK: Instance variables for providing required information to generate Pick Of The Day from
    private let cacheProvider:CacheProviding
    private let contentProvider:MotivationalProviding
//MARK: -
    
    
    
//MARK: The main functionality
    public func motivational()->(pick: Motivational, expires:Date)
    {
        let (uuidOfTheDay, expirationDate) = cacheProvider.cachedUUID()
        var motivatonalOfTheDay = contentProvider.motivational(identifiedBy: uuidOfTheDay)

        /* We explicitly use a reference here since structs would be passed by value by default.
         * But we'd like to have the Motivational itself modified, so we need the reference.
         */
        updatePickOfTheDayTag(for: &motivatonalOfTheDay)
        
        return(motivatonalOfTheDay, expirationDate)
    }
//MARK: -
    
    
    
//MARK: Initializer to enable object modification
    init(_ cacheProvider:CacheProviding?, contentProvider:MotivationalProviding?) {
        if let cacheProviderInstance = cacheProvider {
            self.cacheProvider = cacheProviderInstance
        } else {
            self.cacheProvider = DefaultCacheProvider()
        }
        
        if let contentProviderInstance = contentProvider {
            self.contentProvider = contentProviderInstance
        } else {
            self.contentProvider = DefaultContentProvider()
        }
    }
//MARK: -



//MARK: Internal helper methods to keep the main flow slim.
    private func updatePickOfTheDayTag(for motivational:inout Motivational)
    {
        var indexOfPickOfTheDayTag:Int?
        if let tags = motivational.tags {
            for currentTag in tags {
                if currentTag.title == "pickOfTheDay" {
                    indexOfPickOfTheDayTag = tags.firstIndex(of: currentTag)
                }
            }
            
        }
        if let pickOfTheDayTagIndex = indexOfPickOfTheDayTag {
            motivational.tags?.remove(at: pickOfTheDayTagIndex)
        }
        
        let pickOfTheDayTag = Tag(title: "pickOfTheDay", limitatingDate: Date())
        
        if motivational.tags != nil {
            motivational.tags?.append(pickOfTheDayTag)
        } else {
            let newTags = [pickOfTheDayTag]
            motivational.tags = newTags
        }
    }
//MARK: -



//MARK: Stubbed classes that do nothing but keep the instance working.
    private class DefaultCacheProvider:CacheProviding {
        func cachedUUID() -> (UUID, Date) {
            return (UUID(), Date.distantPast)
        }
    }
    
    private class DefaultContentProvider:MotivationalProviding {
        func motivational(identifiedBy uuid: UUID) -> Motivational {
            return Motivational(message: "Not Yet Implemented")
        }
    }
}

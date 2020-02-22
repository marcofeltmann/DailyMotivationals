//
//  MotivationalTests.swift
//  MotivationalCoreTests
//
//  Created by Marco Feltmann on 12.02.20.
//  Copyright © 2020 mfs. All rights reserved.
//

import XCTest

class MotivationalTests: XCTestCase
{
    let testBundle = Bundle(for: MediaTypeTests.self)
    
    func testInitialization_titleOnly_hasNothingElse()
    {
        let motivational = Motivational(message: "You are bloody brilliant!")
        
        XCTAssertEqual("You are bloody brilliant!", motivational.message);
        
        XCTAssertNil(motivational.media)
        XCTAssertNil(motivational.tags)
    }
    
    func testInitialization_titleWithMedia_hasBoth()
    {
        let resourceFileUrl = testBundle.url(forResource: "robot", withExtension: "jpg")!
        let media = MediaType.image(resourceFileUrl)
        
        let motivational = Motivational(message: "Just be the one", media: media)
        
        XCTAssertEqual("Just be the one", motivational.message)
        XCTAssertEqual(media, motivational.media!)
        
        XCTAssertNil(motivational.tags)
    }
    
    func testInitialization_titleWithTags_hasBoth()
    {
        let tags = [Tag(title: "author", limitation: "some MEME cat")]
        let motivational = Motivational(message: "This is Great!", tags: tags)
        
        XCTAssertEqual("This is Great!", motivational.message)
        XCTAssertEqual(tags, motivational.tags!)
        
        XCTAssertNil(motivational.media)
    }
    
    func testInitialization_allContentsButUUID_hasAll()
    {
        let tags = [Tag(title: "author", limitation: "some MEME cat")]
        let media = MediaType.image(testBundle.url(forResource: "CuteCat", withExtension: "mp4")!)
        let motivational = Motivational(message: "This is Great!", media: media, tags: tags)

        XCTAssertEqual("This is Great!", motivational.message)
        XCTAssertEqual(media, motivational.media!)
        XCTAssertEqual(tags, motivational.tags!)
    }
    
    func testInitialization_allContentsProvided_hasAll()
    {
        let tags = [Tag(title: "author", limitation: "some MEME cat")]
        let media = MediaType.image(testBundle.url(forResource: "CuteCat", withExtension: "mp4")!)
        let uuid = UUID()
        let motivational = Motivational(uuid:uuid, message: "This is Great!", media: media, tags: tags)

        XCTAssertEqual("This is Great!", motivational.message)
        XCTAssertEqual(media, motivational.media!)
        XCTAssertEqual(tags, motivational.tags!)
        XCTAssertEqual(uuid, motivational.uuid)
    }
    
    func testInitialization_uuidDiffersInEach()
    {
        let firstMotivational = Motivational(message: "I am Number 1")
        let secondMotivational = Motivational(message: "I am Number 1")
        
        XCTAssertNotEqual(firstMotivational.uuid, secondMotivational.uuid)
        XCTAssertNotEqual(firstMotivational, secondMotivational)
    }
}

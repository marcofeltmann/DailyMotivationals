//
//  MediaTypeTests.swift
//  MotivationalCoreTests
//
//  Created by Marco Feltmann on 12.02.20.
//  Copyright © 2020 mfs. All rights reserved.
//

import XCTest

class MediaTypeTests: XCTestCase
{
    /// Conveniently store a reference to the test bundle for easier loading of test resource files.
    let testBundle = Bundle(for: MediaTypeTests.self)

    //MARK: Testing runtime behaviour
    
    /* The folling tests are somewhat waste of time since they test behaviour which is guaranteed by the implementation.
     Implementation on the other hand is subject to change and we test for behaviour, not for implementation.
     So if implementation changes this test documents how it expects the new implementation to work. ☺️
     */

    /** Test Image Media Type Behaviour
     
    We expect the media to be only usable as an image so further implementations can rely on this.
     */
    func testMutuallyExclusiveType_imageType_doesNotContainOtherTypes()
    {
        // Since iOS file system APFS is case-sensitive mind the correct string cases!
        let resourceUrl = testBundle.url(forResource: "robot", withExtension: "jpg")

        // Early fail the test when the resourceUrl is no valid file url; `nil` in apples case.
        guard let imageFileUrl = resourceUrl else {
            XCTFail("Requiered to be some excessible image resource!")
            return
        }
        
        let mediaType = MediaType.image(imageFileUrl)
        
        switch mediaType {
        /* I could have used this as the last `default:` statement, but I don't want to:
        `switch` work top-down, so if `let .image(url)` catches up, the `default:` will never be reached. Putting `default:` on top of the switch will *always* catch this.
        Therefor I'll test the wrong values first and skip the `default:` branch.
        */
        case let .audio(fileURL), let.video(fileURL):
            XCTFail("Image Media type at \(fileURL.absoluteString) must not cast to anything else.")
            
        case let .image(fileUrl):
            XCTAssertEqual(imageFileUrl, fileUrl, "Returned file URL must match initialized file URL")
        }
    }

    
    /** Test Audio Media Type Behaviour
     
    We expect the media to be only usable as audio so further implementations can rely on this.
    
    - Note: This tests uses the same layout as `testMutuallyExclusiveType_imageType_doesNotContainOtherTypes`, so no further inline comments will be provided.
     */
    func testMutuallyExclusiveType_audioType_doesNotContainOtherTypes()
    {
        let resourceUrl = testBundle.url(forResource: "Cat1", withExtension: "wav")

        guard let soundFileUrl = resourceUrl else {
            XCTFail("Requiered to be some excessible audio resource!")
            return
        }
        
        let mediaType = MediaType.audio(soundFileUrl)
        
        switch mediaType {
        case let .image(fileURL), let.video(fileURL):
            XCTFail("Audio Media type at \(fileURL.absoluteString) must not cast to anything else.")
            
        case let .audio(fileUrl):
            XCTAssertEqual(soundFileUrl, fileUrl, "Returned file URL must match initialized file URL")
        }
    }
    
    /** Test Video Media Type Behaviour
     
    We expect the media to be only usable as video so further implementations can rely on this.
    
    - Note: This tests uses the same layout as `testMutuallyExclusiveType_imageType_doesNotContainOtherTypes`, so no further inline comments will be provided.
     */
    func testMutuallyExclusiveType_videoType_doesNotContainOtherTypes()
    {
        let resourceUrl = testBundle.url(forResource: "CuteCat", withExtension: "mp4")

        guard let movieFileUrl = resourceUrl else {
            XCTFail("Requiered to be some excessible video resource!")
            return
        }

        let mediaType = MediaType.video(movieFileUrl)
        
        switch mediaType {
        case let .image(fileURL), let.audio(fileURL):
            XCTFail("Video Media type at \(fileURL.absoluteString) must not cast to anything else.")
            
        case let .video(fileUrl):
            XCTAssertEqual(movieFileUrl, fileUrl, "Returned file URL must match initialized file URL")
        }
    }
    //MARK: -


    //MARK: Equality: Positive Tests
    func testEquality_imageMedia_equalImageUrl_equalMediaType()
    {
        let image = MediaType.image(testBundle.url(forResource: "robot", withExtension: "jpg")!)
        let sameImage = MediaType.image(testBundle.url(forResource: "robot", withExtension: "jpg")!)
        
        XCTAssertEqual(image, image)
        XCTAssertEqual(image, sameImage)
    }
    
    func testEquality_audioMedia_equalAudioUrl_equalMediaType()
    {
        let sound = MediaType.audio(testBundle.url(forResource: "Cat1", withExtension: "wav")!)
        let sameSound = MediaType.audio(testBundle.url(forResource: "Cat1", withExtension: "wav")!)
        
        XCTAssertEqual(sound, sound)
        XCTAssertEqual(sound, sameSound)
    }
    
    func testEquality_videoMedia_equalVideoUrl_equalMediaType()
    {
        let movie = MediaType.video(testBundle.url(forResource: "CuteCat", withExtension: "mp4")!)
        let sameMovie = MediaType.video(testBundle.url(forResource: "CuteCat", withExtension: "mp4")!)
        
        XCTAssertEqual(movie, movie)
        XCTAssertEqual(movie, sameMovie)
    }
    
    
    //MARK: Equality: Negative Tests
    func testEquality_differentTypes_equalFileUrl_differentMediaType()
    {
        let movie = MediaType.video(testBundle.url(forResource: "CuteCat", withExtension: "mp4")!)
        let image = MediaType.image(testBundle.url(forResource: "CuteCat", withExtension: "mp4")!)
        let sound = MediaType.audio(testBundle.url(forResource: "CuteCat", withExtension: "mp4")!)
        
        XCTAssertNotEqual(movie, image)
        XCTAssertNotEqual(image, sound)
        XCTAssertNotEqual(sound, movie)
    }
    
    func testEquality_imageType_differentFileUrl_differentMediaType()
    {
        let image = MediaType.image(testBundle.url(forResource: "robot", withExtension: "jpg")!)
        let differentImage = MediaType.image(testBundle.url(forResource: "CuteCat", withExtension: "mp4")!)
        
        XCTAssertNotEqual(image, differentImage)
    }
    
    func testEquality_audioType_differentFileUrl_differentMediaType()
    {
        let sound = MediaType.audio(testBundle.url(forResource: "Cat1", withExtension: "wav")!)
        let differentSound = MediaType.audio(testBundle.url(forResource: "CuteCat", withExtension: "mp4")!)
        
        XCTAssertNotEqual(sound, differentSound)
    }
    
    func testEquality_videoType_differentFileUrl_differentMediaType()
    {
        let movie = MediaType.image(testBundle.url(forResource: "robot", withExtension: "jpg")!)
        let differentMovie = MediaType.image(testBundle.url(forResource: "CuteCat", withExtension: "mp4")!)
        
        XCTAssertNotEqual(movie, differentMovie)
    }
}

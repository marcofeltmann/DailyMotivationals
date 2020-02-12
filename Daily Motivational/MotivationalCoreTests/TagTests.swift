//
//  TagTests.swift
//  MotivationalCoreTests
//
//  Created by Marco Feltmann on 12.02.20.
//  Copyright © 2020 mfs. All rights reserved.
//

import XCTest

class TagTests: XCTestCase
{
    //MARK: At this point we are testing runtime-guaranteed behaviour.

    func testInitialization_titleOnly_hasTitleAndNoLimitation()
    {
        let tag = Tag(title: "art")
        
        XCTAssertEqual("art", tag.title)
        XCTAssertNil(tag.limitation);
    }
    
    func testInitialization_titleAndLimitiation_hasBoth()
    {
        let tag = Tag(title: "art", limitation: "modern")
        
        XCTAssertEqual("art", tag.title)
        XCTAssertEqual("modern", tag.limitation!)
    }
    
    
    //MARK: Down here we can test what we really have impact on.
    
    func testInitialization_titleAndLimitationDate_hasCorrectDateString()
    {
        let secondsToProceedFromReferenceDate:TimeInterval = 123456
        let tag = Tag(title: "valid until", limitatingDate: Date.init(timeIntervalSinceReferenceDate: secondsToProceedFromReferenceDate))
        
        XCTAssertEqual("valid until", tag.title)
        XCTAssertEqual("2001-01-02T10:17:36Z", tag.limitation!)
    }
}

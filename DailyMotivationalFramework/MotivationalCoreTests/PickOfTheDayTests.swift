//
//  PickOfTheDayTests.swift
//  MotivationalCoreTests
//
//  Created by Marco Feltmann on 12.02.20.
//  Copyright © 2020 mfs. All rights reserved.
//

import XCTest

class PickOfTheDayTests: XCTestCase {
//MARK: Streamline tests of provider access
    
    /** Verify cache usage
     
    This simple test only checks if the caches method is called at all.
    - Note: All results of the calls are dismissed because they do not belong to the test. */
    func testProviderIntegration_accessesCacheProvider()
    {
        /// Define an expectation for how the PickOfTheDay interacts with its Cache Provider
        let providerAccessExpectation = self.expectation(description: "Requires PickOfTheDay to request its cache provider for cachedUUID()!")

        /// Configure the cache provider and tell our expectation
        let testCacheProvider = CacheProviderForTesting()
        testCacheProvider.expectationToFulfill = providerAccessExpectation

        /// Test the workflow
        let pickInTesting = PickOfTheDay(testCacheProvider, contentProvider:nil)
        let (_, _) = pickInTesting.motivational()
        
        /// Simply wait that the cache provider was called. Since everything is in-memory this one must be fast!
        self.wait(for: [providerAccessExpectation], timeout: 0.1)
    }
    
    /** Verify content provider usage
     
    This simple test only checks if the content provider method is called at all.
    - Note: All results of the calls are dismissed because they do not belong to the tests. */
    func testProviderIntegration_accessesContentProvider()
    {
        /// Define an expectation for how the PickOfTheDay interacts with its Content Provider
        let providerAccessExpectation = self.expectation(description: "Requires PickOfTheDay to request its content provider for motivational(identifiedBy:)!")

        /// Configure the content provider and tell our expectation
        let testContentProvider = MotivationalProviderForTesting()
        testContentProvider.accessExpectationToFulfill = providerAccessExpectation
        
        /// Test the workflow
        let pickInTesting = PickOfTheDay(nil, contentProvider: testContentProvider)
        let (_, _) = pickInTesting.motivational()
        
        /// Simply wait that the content provider was called. Since everything is in-memory this one must be fast!
        self.wait(for: [providerAccessExpectation], timeout: 0.1)
    }
    
    /** This somewhat complex test verifies the whole provider usage.
     
    Therefor a lot of stuff is going on in here, but it is how you use this in your app.
    - Note: See test implementation code for more information. */
    func testProviderIntegration_respectsProviderResults()
    {
        /** At this point we simply declare our expectations the test run has to meet.
            This is a common pattern when there are *dependencies* in your test case to different classes or aynchronous calls. */
        let cacheProviderAccessExpectation = self.expectation(description: "Requires PickOfTheDay to request its cache provider for cachedUUID()!")
        let contentProviderAccessExpectation = self.expectation(description: "Requires PickOfTheDay to request its content provider for motivational(identifiedBy:)!")
        let contentProviderUUIDSanityExpectation = self.expectation(description: "Requires PickOfTheDay to request its content provider with the correct UUID")

        /// We'll declare all the variables we need for the *Test* itself to run.
        let uuidToReturn = UUID()
        let expectationDate = Date()
        let motivationalToReturn = Motivational(uuid: uuidToReturn, message: "PickOfTheDayTests", media: nil, tags: nil)

        /// The cache provider is configured with our variables and expectation
        let testCacheProvider = CacheProviderForTesting()
        testCacheProvider.expectationToFulfill = cacheProviderAccessExpectation
        testCacheProvider.storedUuid = uuidToReturn
        testCacheProvider.expirationDate = expectationDate
        
        /// The content provider is also configured with our variables and expectations
        let testContentProvider = MotivationalProviderForTesting()
        testContentProvider.accessExpectationToFulfill = contentProviderAccessExpectation
        testContentProvider.validationExpectationToFulfill = contentProviderUUIDSanityExpectation
        testContentProvider.motivationalToReturn = motivationalToReturn
        
        /// This covers the real test: Creating a PickOfTheDay and get it's Motivational.
        let pickInTesting = PickOfTheDay(testCacheProvider, contentProvider:testContentProvider)
        let (motivational, expirationDate) = pickInTesting.motivational()
        
        /** Since we have dependencies covered by our expectations, we wait now for some time to let the system fulfill these expectations.
            The complete flow is managed in-memory without any dependencies to hardware, network or so on. So it must be very fast. */
        self.wait(for: [cacheProviderAccessExpectation, contentProviderAccessExpectation, contentProviderUUIDSanityExpectation], timeout: 0.1)
        
        /// After everything is done we'll check the return values with our variables.
        XCTAssertEqual(motivationalToReturn.uuid, motivational.uuid, "Motivational UUID must match provided motivational UUID")
        XCTAssertEqual(expectationDate, expirationDate, "Expiration date from Cache Provider must be returned")

        /** Well, this is the reason we cannot simply check equality on `motivational` and `motivationalToReturn`:
         *  The latter is enriched with (another or different) "pickOfTheDay" tag that hopefully holds some useful information.
         */
        XCTAssertTrue(motivational.tags?.contains(where: { (foundTag) -> Bool in
            foundTag.title == "pickOfTheDay" && foundTag.limitation != nil
        }) ?? false, "The Pick Of The Day has to add a corresponding tag with some limitation to the fetched Motivational for later reference")
    }
//MARK: -
        
        
        
//MARK: Internal helper classes
    class CacheProviderForTesting:CacheProviding
    {
        var expectationToFulfill:XCTestExpectation?
        
        var storedUuid:UUID = UUID()
        var expirationDate:Date = Date.distantPast
        
        func cachedUUID() -> (UUID, Date) {
            if let expectation = expectationToFulfill {
                expectation.fulfill()
            }
            return (storedUuid, expirationDate)
        }
    }

    class MotivationalProviderForTesting:MotivationalProviding
    {
        var accessExpectationToFulfill:XCTestExpectation?
        var validationExpectationToFulfill:XCTestExpectation?

        var motivationalToReturn:Motivational = Motivational(message: "Works")
        
        func motivational(identifiedBy uuid: UUID) -> Motivational {
            if let accessExpectation = accessExpectationToFulfill {
                accessExpectation.fulfill()
            }
            if let validationExpectaton = validationExpectationToFulfill {
                if(uuid == motivationalToReturn.uuid) {
                    validationExpectaton.fulfill()
                }
            }
            return motivationalToReturn
        }
    }
}

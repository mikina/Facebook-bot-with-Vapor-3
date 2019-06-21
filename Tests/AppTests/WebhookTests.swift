import XCTest
@testable import Vapor
@testable import App

final class WebhookTests: XCTestCase {
  
  var app: Application?
  
  override func setUp() {
    super.setUp()
    
    app = try! Application.makeTest(routes: routes)
  }
  
  func testWebhook() throws {
    
    let expectation = self.expectation(description: "Webhook")
    var responseData: Response?
    var challenge: String?
    
    try app?.test(.GET, "/webhook?hub.mode=subscribe&hub.verify_token=test&hub.challenge=CHALLENGE_ACCEPTED") { response in
      responseData = response
      challenge = String(decoding: response.http.body.data!, as: UTF8.self)
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    XCTAssertEqual(responseData?.http.status, .ok)
    XCTAssertEqual(responseData?.http.contentType, MediaType.plainText)
    XCTAssertEqual(challenge, "CHALLENGE_ACCEPTED")
  }
}

import XCTest
@testable import Vapor
@testable import App

final class WebhookTests: XCTestCase {
  
  var app: Application?
  var fbServiceMock: FBServiceMock? = nil
  
  override func setUp() {
    super.setUp()
    self.fbServiceMock = FBServiceMock()
    
    app = try! Application.makeTest(configure: { (config, services) in
      services.register(BotServiceProtocol.self) { container in
        return self.fbServiceMock!
      }
      
      services.register(MessagesServiceProtocol.self) { container in
        return MessagesService()
      }
    }, routes: routes)
  }
  
  let testsURL: URL = {
    let directory = DirectoryConfig.detect()
    let workingDirectory = URL(fileURLWithPath: directory.workDir)
    return workingDirectory.appendingPathComponent("Tests", isDirectory: true)
  }()
  
  override func tearDown() {
    super.tearDown()
    
    app = nil
    fbServiceMock = nil
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
  
  func testInitialMessage() throws {
    
    let expectation = self.expectation(description: "Webhook")
    var responseData: Response?
    // #1
    let jsonData = try Data(contentsOf: testsURL.appendingPathComponent("FB-request-1.json"))
    self.fbServiceMock!.response = HTTPResponse(status: .ok, body: "{}")
    // #2
    try app?.test(HTTPRequest(method: .POST, url: URL(string: "/webhook")!), beforeSend: { request in
      request.http.headers = HTTPHeaders.init([("Content-Type", "application/json")])
      // #3
      request.http.body = HTTPBody(data: jsonData)
    }, afterSend: { response in
      responseData = response
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 5, handler: nil)
    
    XCTAssertEqual(responseData?.http.status, .ok)
    // #4
    XCTAssertEqual(self.fbServiceMock?.responseMessage, "Hi 👋 I'm Echo Bot, I will send back everything you write to me 😄")
  }
  
  func testSecondMessage() throws {
    
    let expectation = self.expectation(description: "Webhook")
    var responseData: Response?
    
    let jsonData = try Data(contentsOf: testsURL.appendingPathComponent("FB-request-2.json"))
    self.fbServiceMock!.response = HTTPResponse(status: .ok, body: "{}")
    
    try app?.test(HTTPRequest(method: .POST, url: URL(string: "/webhook")!), beforeSend: { request in
      request.http.headers = HTTPHeaders.init([("Content-Type", "application/json")])
      request.http.body = HTTPBody(data: jsonData)
    }, afterSend: { response in
      responseData = response
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 5, handler: nil)
    
    XCTAssertEqual(responseData?.http.status, .ok)
    XCTAssertEqual(self.fbServiceMock?.responseMessage, "Echo: Hello!")
  }
}

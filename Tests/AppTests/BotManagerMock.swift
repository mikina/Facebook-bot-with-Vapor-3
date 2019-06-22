@testable import Vapor
@testable import App

class FBServiceMock: BotServiceProtocol, Service {
  let FacebookAPIToken = Environment.get("FBAPITOKEN")
  var responseMessage: String?
  var response: HTTPResponse?
  
  func sendFBMessage(_ req: Request, message: FBMessage, recipient: FBUserID) throws -> EventLoopFuture<Response> {
    responseMessage = message.text
    return req.future(req.response(http: response!))
  }
  
  func isSignatureValid(for req: Request) throws -> Bool {
    return true
  }
}

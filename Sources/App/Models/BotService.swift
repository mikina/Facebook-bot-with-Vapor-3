import Foundation
import Vapor

protocol BotServiceProtocol {
  func sendFBMessage(_ req: Request, message: FBMessage, recipient: FBUserID) throws -> EventLoopFuture<Response>
}

class FBService: BotServiceProtocol, Service {
  let FacebookAPIToken = Environment.get("FBAPITOKEN")
  
  func sendFBMessage(_ req: Request, message: FBMessage, recipient: FBUserID) throws -> EventLoopFuture<Response> {
    // #1
    var fbMessagesAPI = URLComponents(string: "https://graph.facebook.com/v2.6/me/messages")!
    fbMessagesAPI.queryItems = [URLQueryItem(name: "access_token", value: FacebookAPIToken)]
    
    // #2
    return try req.client().post(fbMessagesAPI.url!, headers: HTTPHeaders.init([("Content-Type", "application/json")])) { body in
      try body.content.encode(json: FBSendMessage(message: message, recipient: recipient))
    }
  }
}

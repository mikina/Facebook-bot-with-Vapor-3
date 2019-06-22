import Vapor

final class BotController {
  
  let FacebookVerifyToken = Environment.get("FBVERIFYTOKEN")
  
  func verify(_ req: Request) throws -> Future<String> {
    let mode = try req.query.get(String.self, at: "hub.mode")
    let token = try req.query.get(String.self, at: "hub.verify_token")
    let challenge = try req.query.get(String.self, at: "hub.challenge")
    
    if mode == "subscribe" && FacebookVerifyToken == token {
      return req.eventLoop.newSucceededFuture(result: challenge)
    }
    else {
      throw Abort(.forbidden)
    }
  }
  
  func message(_ req: Request) throws -> Future<Response> {
    // #1
    let data = try req.content.decode(FBResponseWrapper.self)
    
    // #2
    let botService = try req.make(BotServiceProtocol.self)
    let messagesService = try req.make(MessagesServiceProtocol.self)
    
    return data.flatMap { result in
      // #3
      guard let messageInput = result.entry.last?.messaging.last else {
        // Beware that in some cases Facebook response may not contain any messages.
        throw Abort(.badRequest)
      }
      
      // #4
      let fbMessage = try messagesService.createMessage(for: messageInput)
      return try botService.sendFBMessage(req, message: fbMessage, recipient: messageInput.sender)
    }
  }
}

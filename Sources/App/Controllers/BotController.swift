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
}

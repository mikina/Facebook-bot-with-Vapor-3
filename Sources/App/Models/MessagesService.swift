import Foundation
import Vapor

protocol MessagesServiceProtocol {
  func createMessage(for input: FBMessagingDetails) throws -> FBMessage
}

class MessagesService: MessagesServiceProtocol, Service {
  func createMessage(for input: FBMessagingDetails) throws -> FBMessage {
    if input.postback?.payload == "START" {
      // #1
      return FBMessage(text: "Hi 👋 I'm Echo Bot, I will send back everything you write to me 😄")
    }
    else if let message = input.message {
      // #2
      return FBMessage(text: "Echo: \(message.text ?? "This format is not supported yet, sorry 😇")")
    }
    else {
      throw Abort(.badRequest)
    }
  }
}

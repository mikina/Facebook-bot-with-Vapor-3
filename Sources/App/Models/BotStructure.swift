import Vapor

struct FBSendMessage: Codable {
  let message: FBMessage
  let recipient: FBUserID
}

struct FBMessage: Codable {
  let text: String?
}

struct FBUserID: Codable {
  let id: String
}

struct FBResponseWrapper: Codable  {
  let entry: [FBEntryWrapper]
}

struct FBEntryWrapper: Codable  {
  let messaging: [FBMessagingDetails]
}

struct FBMessagingDetails: Codable {
  let sender: FBUserID
  let message: FBMessage?
  let postback: FBPostback?
}

struct FBPostback: Codable {
  let payload: String
  let title: String
}

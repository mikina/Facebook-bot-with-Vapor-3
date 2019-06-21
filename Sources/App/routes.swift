import Vapor

public func routes(_ router: Router) throws {
  let botController = BotController()
  router.get("webhook", use: botController.verify)
}

#if !canImport(ObjectiveC)
import XCTest

extension AppTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__AppTests = [
        ("testNothing", testNothing),
    ]
}

extension WebhookTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__WebhookTests = [
        ("testWebhook", testWebhook),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AppTests.__allTests__AppTests),
        testCase(WebhookTests.__allTests__WebhookTests),
    ]
}
#endif
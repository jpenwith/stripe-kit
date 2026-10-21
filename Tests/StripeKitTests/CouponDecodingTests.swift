import Foundation
import XCTest
@testable import StripeKit

final class CouponDecodingTests: XCTestCase {
    func testSubscriptionDecodesFractionalCouponPercentage() throws {
        let response = """
            {
              "id": "sub_example",
              "object": "subscription",
              "created": 1744277355,
              "automatic_tax": {"enabled": false},
              "customer": "cus_example",
              "discount": {
                "id": "di_example",
                "object": "discount",
                "coupon": {
                  "id": "coupon_example",
                  "object": "coupon",
                  "created": 1744276121,
                  "percent_off": 81.24
                }
              }
            }
            """

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let subscription = try decoder.decode(Subscription.self, from: Data(response.utf8))

        XCTAssertEqual(subscription.customer, "cus_example")
        XCTAssertEqual(subscription.discount?.coupon?.percentOff, Decimal(string: "81.24"))
    }
}

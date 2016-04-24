//
//  AutoPartCo_strategy.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class AutoPartsStrategy: OrderStrategy {

  func fulfillOrder(order: Order) -> Bool {
    let toBeVerified = AutoPart.instance.getVerifyingNumber()
    if AutoPart.instance.authenticateOrder(order, response: toBeVerified % 2 == 0) {
      if AutoPart.instance.fulfillOrder(order) {
        print("Auto part strategy worked correctly, order fulfilled")
        order.orderFulfilled()
        return true
      } else {
        print("AutoPart strategy error: order id: \(order.orderId) could not be fulfilled")
      }
    } else {
        print("AutoPart strategy error: order id: \(order.orderId) could not be verified by vendor")
    }
    return false
  }
}

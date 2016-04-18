//
//  PartsNStuff_strategy.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class PartsNStuffStrategy: OrderStrategy {

  func fulfillOrder(order: Order) -> Bool {
    let mechanicId = MechanicOrderDataProvider.instace.getMechanicIdFromOrderId(order.orderId)
    if let mechanicId = mechanicId {
      if PartsNStuff.instance.fulfillOrder(order, mechanicId: mechanicId) {
        print("PartsNStuff strategy worked correctly, order fulfilled")
        order.orderFulfilled()
        return true
      } else {
        print("PartsNStuff strategy error: mechanic id: \(mechanicId) " +
              "is not approved to order from PartsNStuff")
      }
    } else {
      print("PartsNStuff strategy error: order id: \(order.orderId) did not match any mechanics")
    }
    return false
  }
}

//
//  ACME_strategy.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class ACMEStrategy: OrderStrategy {

  func fulfillOrder(order: Order) -> Bool {
    let signature = PartsSupervisor.instance.getSupervisorSignatureOnOrder(order)
    if ACME.instance.addToApprovedOrder(order, partsSupervisorSignature: signature) {
      if ACME.instance.fulfillOrder(order) {
        print("ACME strategy worked correctly, order fulfilled")
        order.orderFulfilled()
        return true
      } else {
        print("ACME strategy error: order id: \(order.orderId) could not be fulfilled")
      }
    } else {
        print("ACME strategy error: order id: \(order.orderId) could not be approved by vendor, " +
              "error with supervisor signature")
    }
    return false
  }
}

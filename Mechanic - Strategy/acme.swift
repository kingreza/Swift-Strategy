//
//  ACME.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class ACME {

  static let instance = ACME()
  var approvedOrders: Set<Order>
  private let privateKey = 5

  private init() {
    approvedOrders = Set<Order>()
  }

  func addToApprovedOrder(order: Order, partsSupervisorSignature: Int) -> Bool {
    if partsSupervisorSignature ^ privateKey == order.orderId {
      approvedOrders.insert(order)
      return true
    }
    return false
  }

  func fulfillOrder(order: Order) -> Bool {
    if approvedOrders.contains(order) {
      //Code by ACME to fulfill Order
      approvedOrders.remove(order)
      return true
    }
    return false
  }
}

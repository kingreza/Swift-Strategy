//
//  AutoPartCo.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class AutoPart {

  static var instance = AutoPart()
  private var expectedResponse: Bool {
    return self.selectedNumber % 2 == 0
  }
  private var selectedNumber: Int
  private var approvedOrders: Set<Order>


  private init() {
    approvedOrders = Set<Order> ()
    self.selectedNumber = Int(arc4random_uniform(1000) + 1)
  }

  private func setVerificationNumbers() {
    self.selectedNumber = Int(arc4random_uniform(1000) + 1)
  }

  func getVerifyingNumber() -> Int {
    return selectedNumber
  }

  func authenticateOrder(order: Order, response: Bool) -> Bool {
    if response == expectedResponse {
      approvedOrders.insert(order)
      return true
    }
    return false
  }

  func fulfillOrder(order: Order) -> Bool {
    if approvedOrders.contains(order) {
      //Code by AutoPart Co to fulfill order
      return true
    }
    return false
  }
}

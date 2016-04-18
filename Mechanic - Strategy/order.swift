//
//  File.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class Order: Hashable, Equatable {
  let orderId: Int
  var parts: [Part]
  var carType: CarType
  var fulfilled: Bool = false

  init(orderId: Int, parts: [Part], carType: CarType) {
    self.orderId = orderId
    self.parts = parts
    self.carType = carType
  }

  func orderFulfilled() {
    self.fulfilled = true
    print("Order: \(self.orderId) is fulfilled")
  }

  var hashValue: Int {
    return orderId
  }
}

func == (lhs: Order, rhs: Order) -> Bool {
  return lhs.orderId == rhs.orderId
}

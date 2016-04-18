//
//  orderer.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class Orderer {

  let strategy: OrderStrategy

  init(strategy: OrderStrategy) {
    self.strategy = strategy
  }

  func fulfillOrder(order: Order) -> Bool {
    return self.strategy.fulfillOrder(order)
  }
}

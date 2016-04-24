//
//  order_manager.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class OrderManager {
  static var instance = OrderManager()
  private var acmeStrategy: OrderStrategy
  private var partsnstuffStrategy: OrderStrategy
  private var autopartsStrategy: OrderStrategy
  private var currentOrderId: Int

  private init() {
    self.acmeStrategy = ACMEStrategy()
    self.partsnstuffStrategy = PartsNStuffStrategy()
    self.autopartsStrategy = AutoPartsStrategy()
    self.currentOrderId = 1558
  }

  func generateOrderForMechanic(mechanic: Mechanic, parts: [Part], carType: CarType) -> Order {
    let orderId = currentOrderId + 1
    let order = Order(orderId: orderId, parts: parts, carType: carType)
    MechanicOrderDataProvider.instace.addMechanicOrder(order, mechanic: mechanic)
    currentOrderId = orderId
    return order
  }

  func fulfillOrder(order: Order) -> Bool {
    switch order.carType {
    case .Domestic:
      return acmeStrategy.fulfillOrder(order)
    case .Asian:
      return partsnstuffStrategy.fulfillOrder(order)
    case .European:
      return autopartsStrategy.fulfillOrder(order)

    }
  }
}

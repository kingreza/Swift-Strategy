//
//  parts_supervisor.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class PartsSupervisor {
  static let instance = PartsSupervisor()
  private let privateKey = 5

  private init() {}

  func getSupervisorSignatureOnOrder(order: Order) -> Int {
    return order.orderId ^ privateKey
  }
}

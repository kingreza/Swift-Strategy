<h1>Design Patterns in Swift: Strategy</h1>
This repository is part of a series. For the full list check out <a href="https://shirazian.wordpress.com/2016/04/11/design-patterns-in-swift/">Design Patterns in Swift</a>

For a cheat-sheet of design patterns implemented in Swift check out <a href="https://github.com/ochococo/Design-Patterns-In-Swift"> Design Patterns implemented in Swift: A cheat-sheet</a>

<h3>The problem:</h3>

We order our parts from three different vendors. Each vendor has its own system for fulfilling parts orders.
<ol>
  <li>ACME Parts Co which provides parts for domestic cars requires authorization from our parts supervisor before it can finalize any orders.</li>
  <li>PartsNStuff which provides parts for asians cars provides us with reseller discounts and requires each mechanic to provide their designated ID before finalizing orders.</li>
  <li>AutoPart Co which provides parts for European cars, as part of their state of the art secure ordering,  sends us a number that we have to return true if even and false if odd before they can fulfill our orders.</li>
</ol>
We need a system that can fulfil mechanic's order from all our vendors.

<h3>The solution:</h3>
We need three different strategies for placing an order. We will solve this problem by implementing an OrderManager that will receives an order and decides which strategy to use to fulfil it. We will then implement three different strategies, each for fulfilling an order with a specific vendor. 

<!--more-->

Link to the repo for the completed project: <a href="https://github.com/kingreza/Swift-Strategy"> Swift - Strategy </a>

Because of various requirements needed to complete an order for each vendor, this solution has quite a few supporting classes that in many ways simulate the needed functionalities to match the requirements for each specific strategy. Since things can get easily out of hand when dealing with three different strategies, we will skip going over these supporting classes and only mention their function signatures. Many of them are supposed to simulate API calls and other utility like functions that are outside the scope of this project. If you are interested in how they work the code for them is included in the repo.

Lets begin by defining what we will use throughout all three strategies. 

````swift

struct Part {
  let name: String
  let price: Double

  init(name: String, price: Double) {
    self.name = name
    self.price = price
  }
}

enum CarType: Int {
  case Domestic = 0, Asian, European
}

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

struct Mechanic: Hashable, Equatable {
  let mechanicId: Int
  let name: String

  init(mechanicId: Int, name: String) {
    self.mechanicId = mechanicId
    self.name = name
  }

  var hashValue: Int {
    return mechanicId
  }
}

func == (lhs: Mechanic, rhs: Mechanic) -> Bool {
  return lhs.mechanicId == rhs.mechanicId
}

````

We start by defining our parts object. This will be a simple struct with a name and a price. We set these values in its initializer. We then define an enumerable that we will use to distinguish different car types. When then define an order. Order will implement Hashable and Equitable so we can use it in a Set. This is somewhat outside the scope of this article but if you want to define a Set using custom made classes they need to implement these protocols so Swift would know what makes them equal and what makes them different. If you're not familiar with Hashable and Equatable I suggest you <a href="http://nshipster.com/swift-comparison-protocols/">review this</a>. 

Our order object will have a unique id, a list of parts, a car type and a fulfilled flag. We set these values in its initializer and have it conform to the equitable and hashable protocol by adding the hashValue function and providing a == definition for the class.

We then define a Mechanic's class with a unique mechanic Id and name, and have it implement Hashable and Equatable.

We now have our general building blocks. But before we get into the Strategy Design Pattern, let's define what it means to be a Strategy, more specifically an Order Strategy:

````swift
protocol OrderStrategy {
  func fulfillOrder(order: Order) -> Bool
}
````

The one thing that all three strategies must have in common is their ability to fulfill an order. How they do it is none of our concern right now, we just want to make sure they can perform this task and return a boolean indicating success or failure. In a more complicated system, we probably would want to define a return value with more details, but to keep it simple we will settle for a boolean flag. 

Let's start building our Strategy pattern by looking at our first vendor.  

<em>ACME Parts Co which provides parts for domestic cars requires authorization from our parts supervisor before it can finalize any orders.</em>

We also know the API provided by our ACME partners. 

````swift

func addToApprovedOrder(order: Order, partsSupervisorSignature: Int) -> Bool

func fulfillOrder(order: Order) -> Bool

````

Before ACME fulfills an order, the order needs to be added to its approved orders. For it to be approved it needs to supply a signature by our Part supervisor. Thankfully, our part supervisor has also provided us with an API that we can use to get her signature for our orders.

````swift

 func getSupervisorSignatureOnOrder(order: Order) -> Int

````


I believe we have everything we need to begin coding our first Strategy.

Let's begin:

````swift
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
````

ACMEStrategy implements our OrderStrategy protocol. We begin by getting a signature from our PartSupervisor API. We pass our order and get an integer back. This integer acts as a signature that the ACME API will have to verify. Hypothetically we do not have access to the inner workings of these APIs and we really couldn't care less. We are just following the steps required to fulfill our order. (If interested you can find how the signature process works by viewing the PartsSupervisor and ACME singletons in the completed repo: <a href="https://github.com/kingreza/Swift-Strategy"> Swift - Strategy </a>)

Once we have the signature we pass it to ACME with the order, if it is added to the approved orders we then ask ACME to fulfill it. If the order is fulfilled and a true value is returned by ACME we set the ordered to fulfilled and return true.

And just like that we are done with our first vendor and our first strategy.

Lets look at our next vendor:

<em>PartsNStuff which provides parts for asians cars provides us with reseller discounts and requires each mechanic to provide their designated ID before finalizing orders</em>

We also know the following API is provided by PartsNStuff

````swift

func addApprovedMechanic(mechanicId: Int)

func fulfillOrder(order: Order, mechanicId: Int) -> Bool

````

We also know that internally we have a library that can provide us with the mechanic id associated with each order. This is needed if we want to fulfill an order through PartsNStuff

````swift

func getMechanicIdFromOrderId(orderId: Int) -> Int?

````

We have everything we need to build our PartsNStuff strategy. So let's do it

````swift
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

````

Like ACME, PartsNStuffStrategy implements OrderStrategy. In our fulfill order function we first get the mechanic id associated with the order by calling our MechanicOrderDataProvider. Again this is some API that can provide us with the mechanic id that is associated with an order. If you're interested in its inner working, take a look at the repo:  <a href="https://github.com/kingreza/Swift-Strategy"> Swift - Strategy </a>

If a mechanic id is returned we send the order and the mechanic id through the fulfillOrder API provided by PartsNStuff. If the mechanic id is in their list of approved mechanics they fulfill the order and return with a true value. If not, a false value is returned and our strategy informs the user by printing the error message to the console.

Two down, one more to go:

<em>AutoPart Co which provides parts for European cars, as part of their state of the art secure ordering,  sends us a number that we have to return true if even and false if odd before they can fulfill our orders.</em>

We also know that AutoPart provides the following API

````swift
func getVerifyingNumber() -> Int

func authenticateOrder(order: Order, response: Bool) -> Bool

func fulfillOrder(order: Order) -> Bool 
````

Thankfully we don't need any extra calls to figure out if a number is even or odd, we can do that in the orderStrategy itself.

````swift
class AutoPartsStrategy: OrderStrategy {

  func fulfillOrder(order: Order) -> Bool {
    let toBeVerified = AutoPart.instace.getVerifyingNumber()
    if AutoPart.instace.authenticateOrder(order, response: toBeVerified % 2 == 0) {
      if AutoPart.instace.fulfillOrder(order) {
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
````

Like our other strategies our AutoPartStrategy also implements OrderStrategy. We begin by getting the number that's needed to be verified from AutoPartStrategy. Once the number is received we send in the order along with the result of it being even or odd. If the order is authenticated then we ask AutoPart to fulfill it. If everything goes correctly we mark the order as fulfilled and return true. Otherwise we print out why the process failed and return false. 

We have all three strategies implemented and ready. 

Now we define an Order Manager object, responsible for calling the correct strategy depending on the car type associated with each order. The OrderManager will also hide away the complexity of each strategy from us and presents us with a simple fulfill order interface. 

````swift
class OrderManager {
  static var instance = OrderManager()
  private var acmeStrategy: OrderStrategy
  private var partsnstuffStrategy: OrderStrategy
  private var autopartsStrategy: OrderStrategy

  private init() {
    self.acmeStrategy = ACMEStrategy()
    self.partsnstuffStrategy = PartsNStuffStrategy()
    self.autopartsStrategy = AutoPartsStrategy()
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
````

We create an instance of each strategy and initialize them in our OrderManager initializer. Next  we delegate the task of fulfilling an order to the correct strategy based on the car type associated with the order. 

Let's test this out. Here is our main setup and with some test cases. 

````swift


var joe = Mechanic(mechanicId: 6653, name: "Joe Stevenson")
var mike = Mechanic(mechanicId: 7785, name: "Mike Rove")
var sam = Mechanic(mechanicId: 5421, name: "Sam Warren")
var tom = Mechanic(mechanicId: 99, name: "Tom Tanner")

PartsNStuff.instance.addApprovedMechanic(joe.mechanicId)

var order1 = OrderManager.instance.generateOrderForMechanic(
              joe,
              parts: [Part(name: "Brake pads", price: 15.22),
                      Part(name: "Brake Fluid", price: 18.99)],
              carType: .Asian)

var order2 = OrderManager.instance.generateOrderForMechanic(
               mike,
               parts: [Part(name: "5 qt Synthetic Oil", price: 15.99),
                       Part(name: "Standard Filters", price: 8.49)],
               carType: .European)

var order3 =  OrderManager.instance.generateOrderForMechanic(
               sam,
               parts: [Part(name: "Engine Coolant", price: 18.99)],
               carType: .Domestic)


OrderManager.instance.fulfillOrder(order1)
OrderManager.instance.fulfillOrder(order2)
OrderManager.instance.fulfillOrder(order3)

````

First we setup our mechanics. For this test we define four mechanics: Joe, Mike, Sam and Tom. Next we add Joe to PartsNStuff list of approved mechanics. This way any order associated with him will be approved through the PartsNStuff API. Next we generate some orders. It seems natural to have the process for generating orders take place in our OrderManager class. So let's add a generateOrderForMechanic in it. Here is how our OrderManager class after our new additions.

````swift
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
````

We add a currentOrder value that we increment with every new order. We define a generateOrderForMechanic function that takes in what's needed to create an order and creates it. (smells like another design pattern...)  We also add the mechanic id and order id to our MechanicOrderDataProvider which is used in the PartsNStuff Strategy. We then return the order. 

Finally we call our OrderManager.fulfill order with the orders that we have generated. 

Here is the output we get with the current setup

````

PartsNStuff strategy worked correctly, order fulfilled
Order: 1559 is fulfilled
Auto part strategy worked correctly, order fulfilled
Order: 1560 is fulfilled
ACME strategy worked correctly, order fulfilled
Order: 1561 is fulfilled

````


We can see that the correct order is mapped to the correct strategy. we see that each strategy goes through its own set of steps required to fulfill an order. Outside of our OrderManager none of the strategies are exposed to any other object or each other. We simply pass in an order and receive a true or false regarding the outcome. Our test case here present the happy path, try mocking around with our Orders and see how our Strategy Pattern responses. 

Congratulations you have just implemented the Strategy Design Pattern to solve a nontrivial problem

The repo for the complete project can be found here:<a href="https://github.com/kingreza/Swift-Strategy"> Swift - Strategy </a> Download a copy of it and play around with it. See if you can find ways to improve it. Here are some ideas to consider:

<ul>
  <li>Add a new strategy for PartCo, a parts company for asian cars. They don't have the same requirements as PartsNStuff. Change the system so if the order for PartsNStuff fails, PartCo will be used to fulfill it.</li>
  <li>This example takes advantage of another well known design pattern. Can you spot it?</li>
       <li>In our current solution our strategies are hard coded in the OrderManager. Write a system where new strategies for each car type can be added to the manager dynamically</li>
</ul>

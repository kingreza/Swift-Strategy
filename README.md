<h1>Design Patterns in Swift: Strategy</h1>
This repository is part of a series. For the full list check out <a href="https://shirazian.wordpress.com/2016/04/11/design-patterns-in-swift/">Design Patterns in Swift</a>

<h3>The problem:</h3>
The problem:

We order our parts from three different vendors. Each vendor has its own system for fulfilling parts orders.
<ol>
	<li>ACME Parts Co which provides parts for domestic cars requires authorization from our parts supervisor before it can finalize any orders.</li>
	<li>PartsNStuff which provides parts for asians cars provides us with reseller discounts and requires each mechanic to provide their designated ID before finalizing orders.</li>
	<li>AutoPart Co which provides parts for European cars, as part of their state of the art secure ordering,  sends us a number that we have to return true if even and false if odd before they can fulfill our orders.</li>
</ol>
We need a system that can fulfil mechanic's order from all our vendors.

<h3>The solution:</h3>

Link to the repo for the completed project: <a href="https://github.com/kingreza/Swift-Strategy"> Swift - Strategy </a>


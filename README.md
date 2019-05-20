# CoreML Swift Demo

<a href = test_ml2/AppDelegate.swift> Code here </a>

var allProducts = [
    Product(id:1,   name: "Maet"),
    Product(id:2,   name: "Coca"),
    Product(id:3,   name: "Pepsi"),
    Product(id:4,   name: "Beer"),
    Product(id:5,   name: "Vodka"),
    Product(id:6,   name: "Chocolate"),
    Product(id:7,   name: "Doshirak"),
    Product(id:8,   name: "Salt"),
    Product(id:9,   name: "Potato"),
    Product(id:10,  name: "Cucumber"), 
 ...
] 

var allChecks = [
    Check(id: 1, products: [Product(id: 1, name: "Meat"), Product(id:2, name: "Coca")]),
    Check(id: 2, products: [Product(id: 1, name: "Meat"), Product(id:2, name: "Coca"), Product(id:7, name: "Doshirak")]),
    Check(id: 3, products: [Product(id:2, name: "Coca"), Product(id:6, name: "Chocolate")])
]


found vector of existances:

[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 

augmentation...

[0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] -> 1

[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] -> 2

found vector of existances:

[1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

augmentation...

[0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] -> 1

[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] -> 2

[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] -> 7

found vector of existances:

[0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

augmentation...

[0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] -> 2

[0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] -> 6


Hello, Core ML!

checking of prediction of the check:

Check(id: 2, products: [test_ml2.Product(id: 1, name: Optional("Meet")), test_ml2.Product(id: 7, name: Optional("Doshirak"))])

found binary (string) shape of this:

10000010000000000000


Model predicted linked product:  Coca


Found probabilities: 

product:  Doshirak  ->  0.05500002309187479

product:  Coca  ->  0.8219056107743803

product:  Meet  ->  0.06432191996016502

product:  Chocolate  ->  0.058772446173580024


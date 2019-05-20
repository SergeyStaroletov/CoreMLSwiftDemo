//
//
//  Predict a corresponding product for retail receipts
//
//  Created by Sergey Staroletov on 18/05/2019.
//  Copyright © 2019 Sergey Staroletov. All rights reserved.
//

import Cocoa
import CreateML
import CoreML


//Receipt (check) structure, it consists products
struct Check {
    var id: Int
    var products: [Product]
}

//one product structure
struct Product {
    var id: Int
    var name: String?
}


//all products - should be selected from database
var allProducts = [
    Product(id:1,   name: "Meat"),
    Product(id:2,   name: "Coca"),
    Product(id:3,   name: "Pepsi"),
    Product(id:4,   name: "Beer"),
    Product(id:5,   name: "Vodka"),
    Product(id:6,   name: "Chocolate"),
    Product(id:7,   name: "Doshirak"),
    Product(id:8,   name: "Salt"),
    Product(id:9,   name: "Potato"),
    Product(id:10,  name: "Cucumber"), //just copy for long size of shape not fit to int test
    Product(id:11,   name: "Meet"),
    Product(id:12,   name: "Coca"),
    Product(id:13,   name: "Pepsi"),
    Product(id:14,   name: "Beer"),
    Product(id:15,   name: "Vodka"),
    Product(id:16,   name: "Chocolate"),
    Product(id:17,   name: "Doshirak"),
    Product(id:18,   name: "Salt"),
    Product(id:19,   name: "Potato"),
    Product(id:20,  name: "Cucumber"),
] //sorted by id


//all checks - should select be selected from database
var allChecks = [
    Check(id: 1, products: [Product(id: 1, name: "Meat"), Product(id:2, name: "Coca")]),
    Check(id: 2, products: [Product(id: 1, name: "Meat"), Product(id:2, name: "Coca"), Product(id:7, name: "Doshirak")]),
    Check(id: 3, products: [Product(id:2, name: "Coca"), Product(id:6, name: "Chocolate")])
]

//generate a .csv file with relations shape of state -> class of missing product
func generate() {
    //output file name. correct the user and touch it if it does not work
    let CSVfileName = "/Users/sergey/Library/Containers/me.test-ml2/Data/Products.csv"
    var cvsData = ""
    
    //captions in .csv
    cvsData.append("shape,class\n")
    
    for check in allChecks { //scan all the checks...
        var vectOfExistence: [Int] = [] //we will form a vector of all products size
        
        for prod in allProducts {
            if let _ = check.products.firstIndex(where: { $0.id ==  prod.id }) {
                vectOfExistence.append(1) //and we put 1 here if a particular product exists here in check
            } else {
                vectOfExistence.append(0)
            }
        }
        print("found vector of existances:")
        print(vectOfExistence)
        
        print("augmentation...")
        var index = 0
        
        for sign in vectOfExistence {
            if sign == 1 {
                var vecChg = vectOfExistence;
                vecChg[index] = 0; //simple remove existing products
                //we say for a check without this product result should be the removed product
                let output = allProducts[index].id;
                print(vecChg, "->", output);
                //write to cvs data
                for el in vecChg {
                    cvsData.append(String(el))
                }
                cvsData.append("," + String(output) + "\n")
            }
            index = index + 1
        }
    }
    
    do {
        try cvsData.write(to: URL(fileURLWithPath:CSVfileName), atomically: true, encoding: String.Encoding.utf8)
    } catch {
        print("Failed to create file")
        print("\(error)")
    }
}



//train a ML Classifier
func train() {
    print("Hello, Create ML!")
    do {
        // load generated CSV
        let inputData = try MLDataTable(contentsOf: URL(
            fileURLWithPath: "Products.csv"))
        //"class" is a result column name
        let model = try MLClassifier(trainingData: inputData, targetColumn: "class")
        
        let csvMetadata = MLModelMetadata(author: "Sergey", shortDescription: "do not use it", version: "0.0")
        try model.write(to: URL(fileURLWithPath: "ProductsMLModel.mlmodel"), metadata: csvMetadata)
        
    } catch {
        print("buggy ML!")
    }
}


func detect() {
    
    let checkToTest = Check(id: 2, products: [Product(id: 1, name: "Meet"), Product(id:7, name: "Doshirak")])
    
    print("Hello, Core ML!")
    
    print("checking of prediction of the check:")
    print(checkToTest)
    
    //create a shape for the check to test
    var shape = ""
    
    for prod in allProducts {
        if let _ = checkToTest.products.firstIndex(where: { $0.id ==  prod.id }) {
            shape.append("1")
        } else {
            shape.append("0")
        }
    }
    print("found binary (string) shape of this:")
    print(shape)
    
    do {
        let compiledUrl = try MLModel.compileModel(at: URL(fileURLWithPath: "ProductsMLModel.mlmodel"))
        print("compiled to : ", compiledUrl)
        let modelToPredict = try ProductsMLModel(contentsOf: compiledUrl)
        let predicton = try modelToPredict.prediction(shape: shape)
        
        let classFound = predicton.class_
        
        print("")
        
        if let index = allProducts.firstIndex(where: { $0.id == classFound}) {
            print("Model predicted linked product:  " + allProducts[index].name!)
        }
        
        print("")
        
        let probz = predicton.classProbability
        
        print("Found probabilities: ")
        for prob in probz {
            if let index = allProducts.firstIndex(where: { $0.id == prob.key}) {
                print("product: ", allProducts[index].name!, " -> ", prob.value)
            }
        }
        
    } catch {
        print("buggy Core ML!")
    }
    
}



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    //fuck the gui
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        generate()
        train()
        detect()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}


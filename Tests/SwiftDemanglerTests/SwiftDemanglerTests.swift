import XCTest
@testable import SwiftDemangler

final class SwiftDemanglerTests: XCTestCase {
    func testEx1() {
        XCTAssertEqual(demangle(name: "$S13ExampleNumber6isEven6numberSbSi_tF"),
                       "ExampleNumber.isEven(number: Swift.Int) -> Swift.Bool")
    }

    func testParser1() {
        var parser = Parser(name: "0")
        
        // 0
        XCTAssertEqual(parser.parseInt(), 0)
        XCTAssertEqual(parser.remains, "")
        
        // 1
        parser = Parser(name: "1")
        XCTAssertEqual(parser.parseInt(), 1)
        XCTAssertEqual(parser.remains, "")
        
        // 12
        parser = Parser(name: "12")
        XCTAssertEqual(parser.parseInt(), 12)
        XCTAssertEqual(parser.remains, "")
        
        // 12
        parser = Parser(name: "12A")
        XCTAssertEqual(parser.parseInt(), 12)
        XCTAssertEqual(parser.remains, "A")
        
        // 1
        parser = Parser(name: "1B2A")
        XCTAssertEqual(parser.parseInt(), 1)
        XCTAssertEqual(parser.remains, "B2A")
        XCTAssertEqual(parser.parseInt(), nil)
    }

    func testParser2() {
        let parser = Parser(name: "3ABC4DEFG")
        
        XCTAssertEqual(parser.parseInt(), 3)
        XCTAssertEqual(parser.remains, "ABC4DEFG")
        XCTAssertEqual(parser.parseIdentifier(length: 3), "ABC")
        XCTAssertEqual(parser.remains, "4DEFG")
        
        XCTAssertEqual(parser.parseInt(), 4)
        XCTAssertEqual(parser.remains, "DEFG")
        XCTAssertEqual(parser.parseIdentifier(length: 4), "DEFG")
    }
    
    func testParser3() {
        let parser = Parser(name: "3ABC4DEFG")
        XCTAssertEqual(parser.parseIdentifier(), "ABC")
        XCTAssertEqual(parser.remains, "4DEFG")
        XCTAssertEqual(parser.parseIdentifier(), "DEFG")
    }
    
    func testParser4() {
        let parser = Parser(name: "$S13ExampleNumber6isEven6number5countSbSi_tF")
//        let parser = Parser(name: "$S13ExampleNumber6isEven6numberSbSi_tF")
        let _ = parser.parsePrefix()
        XCTAssertEqual(parser.parseModule(), "ExampleNumber")
        XCTAssertEqual(parser.parseDeclName(), "isEven")
        XCTAssertEqual(parser.parseLabelList(), ["number", "count"])
    }
    
    func testParser5() {
        let parser = Parser(name: "$S13ExampleNumber6isEven6number5countSbSi_tF")
        //        let parser = Parser(name: "$S13ExampleNumber6isEven6numberSbSi_tF")
        let _ = parser.parsePrefix()
        XCTAssertEqual(parser.peek(), "1")
        XCTAssertEqual(parser.parseModule(), "ExampleNumber")
        XCTAssertEqual(parser.peek(), "6")
        parser.skip(length:7)
        XCTAssertEqual(parser.parseLabelList(), ["number", "count"])
    }

    func testParser6() {
        XCTAssertEqual(Parser(name: "Si").parseType(), Type.int)
        XCTAssertEqual(Parser(name: "Sb").parseType(), Type.bool)
        XCTAssertEqual(Parser(name: "SS").parseType(), Type.string)
        XCTAssertEqual(Parser(name: "Sf").parseType(), Type.float)
        XCTAssertEqual(Parser(name: "Sf_SfSft").parseType(), .list([Type.float, Type.float, Type.float]))
    }
    
    func testParser7() {
        XCTAssertEqual(Parser(name: "SbSi_t").parseFunctionSignature(), FunctionSignature(returnType: .bool, argsType: .list([.int])))
    }
    
    func testParser8() {
        let sig = FunctionSignature(returnType: .bool, argsType: .list([.int]))
        XCTAssertEqual(Parser(name: "13ExampleNumber6isEven6numberSbSi_tF").parseFunctionEntity(),
                       FunctionEntity(module: "ExampleNumber", declName: "isEven", labelList: ["number"], functionSignature: sig))
    }
//    static var allTests = [
//        ("testEx1", testEx1, testParser1, testParser2),
//    ]
}

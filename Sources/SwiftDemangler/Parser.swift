import Foundation

class Parser {
    private let name: String
    private var index: String.Index
    
    var remains: String { return String(name[index...]) }
    
    init(name: String) {
        self.name = name
        self.index = name.startIndex
    }
    
    private func plusIndex(count: Int) {
        index = name.index(index, offsetBy:count)
    }
}

extension Parser {
    func parseInt() -> Int? {
        let part = remains.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let num = Int(part[0])
        
        guard (num != nil) else {
            return nil
        }

        plusIndex(count: (String(num!).count))

        return num
    }
}

extension Parser {
    func parseIdentifier(length: Int) -> String {
        let value = String(name[index..<name.index(index, offsetBy:length)])
        plusIndex(count:length)

        return value
    }
}

extension Parser {
    func parseIdentifier() -> String? {
        let count = parseInt()
        
        guard (count != nil) else {
            return nil
        }
        
        return parseIdentifier(length: count!)
    }
}

extension Parser {
    func parsePrefix() -> String {
        if (remains.hasPrefix("$S")) {
            plusIndex(count: 2)
            return "$S"
        } else {
            abort()
        }
    }
}

extension Parser {
    func parseModule() -> String {
        return parseIdentifier() ?? ""
    }
}

extension Parser {
    func parseDeclName() -> String {
        return parseIdentifier() ?? ""
    }
}

extension Parser {
    func parseLabelList() -> [String] {
        var result = [String]()
        var identifer = parseIdentifier()
        
        while (identifer != nil) {
            result.append(identifer!)
            identifer = parseIdentifier()
        }
        
        return result
    }
}

extension Parser {
    func peek(count:Int=1) -> String {
        let lastIndex = name.index(index, offsetBy: count, limitedBy:name.endIndex)
        
        guard lastIndex != nil else {
            return ""
        }
        
        return String(name[index..<lastIndex!])
    }
}

extension Parser {
    // length分だけindexを進める
    func skip(length: Int) {
        plusIndex(count: length)
    }
}

extension Parser {
    func parseKnownType() -> Type {
        var result :Type? = nil
        let typeString = peek(count:2)
        
        switch typeString {
        case "Si":
            result = .int
        case "Sb":
            result = .bool
        case "SS":
            result = .string
        case "Sf":
            result = .float
        default :
            abort()
        }
        
        skip(length:2)
        return result!
    }
    
    func parseType() -> Type {
        let firstType = parseKnownType()
        
        if (peek() == "_") {
            skip(length: 1)
            var result = [Type]()
            result.append(firstType)

            while (peek() != "t") {
                result.append(parseKnownType())
            }
            
            skip(length: 1)
            
            return .list(result)
        } else {
            return firstType
        }
    }
}

extension Parser {
    func parseFunctionSignature() -> FunctionSignature {
        return FunctionSignature(
            returnType: parseType(),
            argsType: parseType()
        )
    }
}

extension Parser {
    func parseFunctionEntity() -> FunctionEntity {
        return FunctionEntity(
            module: parseModule(),
            declName: parseDeclName(),
            labelList: parseLabelList(),
            functionSignature: parseFunctionSignature()
        )
    }
}

extension Parser {
    func parse() -> FunctionEntity {
        let _ = self.parsePrefix()
        return self.parseFunctionEntity()
    }
}

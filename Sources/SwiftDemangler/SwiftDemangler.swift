public func demangle(name: String) -> String {
    let parser = Parser(name:name)
    let result = parser.parse()
    
    return convertString(entry: result)
}

private func isSwiftySymbol(name: String) -> Bool {
    return name.hasPrefix("$")
}

private func isFunctionEntitySpec(name:String) -> Bool {
    return name.hasSuffix("F")
}

private func convertString(entry:FunctionEntity) -> String {
    var paramaters = [String]()
    
    if case .list(let types) = entry.functionSignature.argsType {
        for i in 0 ..< entry.labelList.count {
            paramaters.append(String(format: "%@: %@", entry.labelList[i], types[i].description))
        }
    } else {
        paramaters.append(String(format: "%@: %@", entry.labelList[0], entry.functionSignature.argsType.description))
    }
    
    return String(format: "%@.%@(%@) -> %@",
                  entry.module,
                  entry.declName,
                  paramaters.joined(separator: ","),
                  entry.functionSignature.returnType.description
    )
}

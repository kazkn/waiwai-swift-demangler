enum Type {
    case bool
    case int
    case string
    case float
    case void
    indirect case list([Type])
}

extension Type: Equatable {
    static func == (lhs: Type, rhs: Type) -> Bool {
        switch (lhs, rhs) {
        case (.bool, .bool): return true
        case (.int, .int): return true
        case (.string, .string): return true
        case (.float, .float): return true
        case (.void, .void): return true
        case let (.list(list1), .list(list2)):
            return list1 == list2
        default:
            return false
        }
        
    }
}

extension Type: CustomStringConvertible {
    var description: String {
        switch self {
        case .bool:
            return "Swift.Bool"
        case .int:
            return "Swift.Int"
        case .string:
            return "Swift.String"
        case .float:
            return "Swift.Float"
        case .void:
            return "Swift.Void"
        case .list(let types):
            return types.map {$0.description }.joined(separator: ",")
        }
    }
}

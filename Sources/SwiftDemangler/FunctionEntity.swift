struct FunctionEntity: Equatable {
    let module: String
    let declName: String
    let labelList: [String]
    let functionSignature: FunctionSignature
}

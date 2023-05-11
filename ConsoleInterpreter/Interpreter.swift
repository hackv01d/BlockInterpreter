enum TokenType {
    case integer
    case plus
    case minus
    case multiply
    case divide
    case eof
    case leftBrace
    case rightBrace
    case modulo
    case equal
    case notEqual
    case greater
    case less
    case greaterEqual
    case lessEqual
    case logicalAnd
    case logicalOr
}


enum VariableType {
    case int
    case double
    case String
    case bool
    case another
}


enum AllTypes {
    case assign
    case ifBlock
    case begin
    case end
    case loop
    case function
    case variable
    case arithmetic
    case print
    case root
}


enum DelimiterType {
    case begin
    case end
}


struct BlockDelimiter: IBlock {
    let type: DelimiterType
}


protocol IBlock {

}

enum ConditionType {
    case ifBlock
    case elifBlock
    case elseBlock
}


struct Condition: IBlock {
    let id: Int
    let type: ConditionType
    let value: String
}


enum LoopType {
    case forLoop
    case whileLoop
}


struct Loop: IBlock {
    let id: Int
    let type: LoopType
    let value: String
}

struct Printing: IBlock {
    let id: Int
    let value: String
}



class Token {
    private var type: TokenType
    private var value: String?
 
    init(_ type: TokenType, _ value: String?) {
        self.type = type
        self.value = value
    }
 
    func getType() -> TokenType {
        return self.type
    }
 
    func setType(type: TokenType) {
        self.type = type
    }
 
    func setValue(value: String?) {
        self.value = value
    }
 
    func getValue() -> String? {
        return value
    }
}



struct Variable: IBlock {
    let id: Int
    let type: VariableType
    let name: String
    let value: String

     
    func getId() -> Int {
        return self.id
    }

    func getType() -> VariableType {
        return self.type
    }

    func getValue() -> String {
        return self.value
    }
    func getName() -> String {
        return self.name
    }
}





class Calculate {
    private var text: String
    private var position: Int
    private var currentToken: Token?
 
    init(_ text: String) {
        self.text = text
        position = 0
    }
 
    public func getText() -> String {
        return self.text
    }
 
    public func setText(text: String) {
        self.text = text
        self.position = 0
    }

    public func compare() -> Int {
        self.currentToken = self.getNextToken() 
        
        var result = self.term()
        let possibleTokens: [TokenType] = [
            TokenType.plus,
            TokenType.minus,
            TokenType.equal,
            TokenType.less, 
            TokenType.greater,
            TokenType.notEqual,
            TokenType.lessEqual,
            TokenType.greaterEqual,
            TokenType.logicalAnd,
            TokenType.logicalOr
        ]
        if self.currentToken == nil {
            return result
        }
        while let token = self.currentToken, possibleTokens.contains(token.getType()) {
            
            if token.getType() == .plus {
                moveToken(.plus)
                result += term()
            } else if token.getType() == .minus {
                moveToken(.minus)
                result -= term()
            } else if possibleTokens.contains(token.getType()){
                self.moveToken(token.getType())
                let factorValue = self.factor()

                switch token.getType() {
                case .equal:
                    result = result == factorValue ? 1 : 0
                case .notEqual:
                    result = result != factorValue ? 1 : 0
                case .greater:
                    result = result > factorValue ? 1 : 0
                case .less:
                    result = result < factorValue ? 1 : 0
                case .greaterEqual:
                    result = result >= factorValue ? 1 : 0
                case .lessEqual:
                    result = result <= factorValue ? 1 : 0
                case .logicalAnd:
                    result = result != 0  && factorValue != 0  ? 1 : 0
                case .logicalOr:
                    result = result != 0 || factorValue != 0  ? 1 : 0
                default:
                    fatalError("Invalid token type")
                }
            }
        }
        return result
    }

   
    
    private func term() -> Int {
        var result = self.factor()
        let possibleTokens: [TokenType] = [
            TokenType.modulo,
            TokenType.multiply,
            TokenType.divide,
        ]
        if self.currentToken == nil {
            return result
        }
        while let token = self.currentToken, possibleTokens.contains(token.getType()){
            switch token.getType() {
            case .modulo:
                self.moveToken(.modulo)
                result %= self.factor()
            case .multiply:
                self.moveToken(.multiply)
                result *= self.factor()

            case .divide:
                self.moveToken(.divide)
                result /= self.factor()
            
            default:
                fatalError("Invalid token type")
            }
        }
        return result
    }

    private func factor() -> Int {
        let token = self.currentToken!
        switch token.getType() {
            case .integer:
                self.moveToken(.integer)
                guard let value = token.getValue(), let intValue =
                        Int(value) else { fatalError("Error parsing input")
                }
                return intValue
            case .leftBrace:
                self.moveToken(.leftBrace)
                let result = self.compare()
                self.moveToken(.rightBrace)
                return result
            case .eof:
                return 0
            default:
                fatalError("Invalid syntax")
        }

    }
 

    private func getNextToken() -> Token? {
        guard self.position < self.text.count else {
            return Token(.eof, nil)
        }
 
        let currentChar = self.text[self.text.index(self.text.startIndex, offsetBy: self.position)]
        if self.isSpace(currentChar) {
            self.position += 1
            return self.getNextToken()
        }
 
        if self.isNumber(currentChar) {
            var integerString = String(currentChar)
            self.position += 1
 
            while self.position < self.text.count {
                let nextChar =
                self.text[self.text.index(self.text.startIndex, offsetBy: self.position)]
                if self.isNumber(nextChar) {
                    integerString += String(nextChar)
                    self.position += 1
                } else {
                    break
                }
            }

            return Token(.integer, integerString)
        }
        self.position += 1
        return getToken(currentChar)
        
    }

    private func getToken(_ currentChar: Character) -> Token{
        switch currentChar {
            case "+":
                return Token(.plus, "+")            
            case "-":
                return Token(.minus, "-")
            case "*":
                return Token(.multiply, "*")
            case "/":
                return Token(.divide, "/")
            case "%":
                return Token(.modulo, "%")
            case "(":
                return Token(.leftBrace, "(")
            case ")":
                return Token(.rightBrace, ")")
            case "=", "<", ">", "!", "&", "|":
                
                if position < text.count && text[text.index(text.startIndex, offsetBy: position)] == "=" {
                    position += 1
                    switch currentChar {
                        case "=":
                            return Token(.equal, "==")
                        case "!":
                            return Token(.notEqual, "!=")
                        case "<":
                            return Token(.lessEqual, "<=")
                        case ">":
                            return Token(.greaterEqual, ">=")
                        default:
                            fatalError("Invalid character")
                    }
                } else {
                    switch currentChar {
                        case "=":
                            return Token(.equal, "=")
                        case "<":
                            return Token(.less, "<")
                        case ">":
                            return Token(.greater, ">")
                        case "&":
                            if position < text.count && text[text.index(text.startIndex, offsetBy: position)] == "&" {
                                position += 1
                                return Token(.logicalAnd, "&&")
                            } else {
                                fatalError("Invalid character")
                            }
                            
                        case "|":
                            if position < text.count && text[text.index(text.startIndex, offsetBy: position)] == "|" {
                                position += 1
                                return Token(.logicalOr, "||")
                            } else {
                                fatalError("Invalid character")
                            }
                        default:
                            fatalError("Invalid character")
                    }
                }
            default:
                fatalError("Invalid character")
        }
    }
    private func moveToken(_ type: TokenType) {
        if let token = currentToken, token.getType() == type{
            if !(token.getType() == .leftBrace) {
                currentToken = getNextToken()
            }
        } else {
            fatalError("Invalid syntax")
        }
    }

    private func isNumber(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }

    private func isSpace(_ char: Character) -> Bool {
        return char == " "
    }
}





class AssignmentVariable {
    private var variableIntMap: [String: String]

    init(_ variableIntMap: [String: String]) {
        self.variableIntMap = variableIntMap
    }
 
    public func setMapOfVariable(_ mapOfVariable: [String: String]) {
        self.variableIntMap.merge(mapOfVariable){(_, new) in new}
    }
 
    public func assign(_ variable: Variable) -> String {
        if variable.getType() == .int {
            return assignInt(variable.getValue())
        } else if variable.getType() == .String {
            return assignString(variable.getValue())
        } else {
            fatalError("Invalid variable type")
        }
    }

    private func assignInt(_ variable: String) -> String {

        let normalizedString = normalizeInt(variable)
        let computedString = String(Calculate(normalizedString).compare())
        return computedString
    }

    private func assignString(_ variable: String) -> String {
        let normalizedString = normalizeString(variable)
        return normalizedString
    }

    private func normalizeString(_ name: String) -> String {
        var result = "" 
        let components = name.split(whereSeparator: { $0 == " " })
        for component in components {
            if let value = variableIntMap[String(component)] {
                result += "\(value)"
            } else {
                result += "\(component)"
            }
        }
        return result
    }
    private func normalizeInt(_ name: String) -> String {
        var result = "" 
        let components = name.split(whereSeparator: { $0 == " " })
        for component in components {
            if let intValue = Int(component) {
                result += "\(intValue)"
            } else if let value = variableIntMap[String(component)] {
                result += "\(value)"
            } else {
                result += "\(component)"
            }
        }
        return result
    }
}




class Node{
    private(set) var value: String
    private(set) var type: AllTypes
    private(set) var parent: Node?
    private(set) var children: [Node]
    private(set) var countWasHere: Int


    init(value: String, type: AllTypes) {
        self.value = value
        self.type = type
        self.countWasHere = 0
        self.children = []
    }


    func addChild(_ child: Node) {
        children.append(child)
        child.parent = self
    }
}



class Interpreter{
    private(set) var treeAST: Node
    internal var mapOfVariableStack: [[String: String]]
    private var assignmentVariableInstance = AssignmentVariable([:])
    private var printResult = ""

    init(_ treeAST: Node){
        self.treeAST = treeAST
        self.mapOfVariableStack = []
    }

    func traverseTree(_ treeAST: Node) -> String{ 
        switch treeAST.type{
        case .variable:
            return processVariableNode(treeAST)
        case .arithmetic:
            return processArithmeticNode(treeAST)
        case .assign:
            processAssignNode(treeAST)
        case .root:
            processRootNode(treeAST)
        case .ifBlock:
            processIfBlockNode(treeAST)
        case .loop:
            processLoopNode(treeAST)
        case .print:
            processPrintNode(treeAST)
        default:
            return "" // в этом случае нужно возвращать ID блока
        }
        
        return ""
    }
    private func processLoopNode(_ node: Node){
        print("processLoopNode")
        print(node.value)
    }

 
    private func processPrintNode(_ node: Node){
        let calculatedValue = calculateArithmetic(node.value)
        print(calculatedValue)
        print("processPrintNode")
        if let value = Int(calculatedValue) {
            printResult += "\(value)\n"
        } else {
            printResult += "\(node.value)\n"
        }
    }

    private func processIfBlockNode(_ node: Node){
        let calculatedValue = calculateArithmetic(node.value)

        guard let value = Int(calculatedValue) else {
            fatalError("Invalid syntax")
        }
        if value != 0{
            mapOfVariableStack.append([:])

            for child in node.children{
                let _ = traverseTree(child)

                if child.type == .ifBlock {
                    mapOfVariableStack.append([:])
                }

                if let lastDictionary = mapOfVariableStack.last {
                    mapOfVariableStack.removeLast()
            
                    for (key, value) in lastDictionary {
                        for (index, var dictionary) in mapOfVariableStack.enumerated().reversed() {
                            if dictionary[key] != nil {
                                dictionary[key] = value
                                mapOfVariableStack[index] = dictionary
                                break
                            }
                        }
                    }

                }
            }
        }
    }



    private func processRootNode(_ node: Node){
        mapOfVariableStack.append([:])
        for child in node.children{
            let _ = traverseTree(child)
        } 
        print(mapOfVariableStack)
        print(printResult)
    }

    private func processVariableNode(_ node: Node) -> String{
        return node.value
    }

    private func processAssignNode(_ node: Node){ 
    
        let varName = traverseTree(node.children[0])
        let assignValue = traverseTree(node.children[1])
        if var lastDictionary = mapOfVariableStack.last {
            lastDictionary[varName] = assignValue
            mapOfVariableStack[mapOfVariableStack.count - 1] = lastDictionary
        }
    }

    private func processArithmeticNode(_ node: Node) -> String {
        return calculateArithmetic(node.value)
    }

    private func calculateArithmetic(_ expression: String) -> String {
        var lastDictionary:[String: String] = [:]
        for dictionary in mapOfVariableStack {
            lastDictionary.merge(dictionary){(_, new) in new}
        }
        assignmentVariableInstance.setMapOfVariable(lastDictionary)

        let variableForInt = Variable(
            id: 1,
            type: VariableType.int,
            name: "temp",
            value: expression
            
        )
        let mapElement = assignmentVariableInstance.assign(variableForInt)
        if mapElement == "" {
            fatalError("Invalid syntax")
        } else if let intValue = Int(mapElement) {
            return "\(intValue)"
        } else {
            return mapElement
        }

        
    }
}

//! Tree for test 


class Tree {
    var rootNode: Node = Node(value: "Begin", type: AllTypes.root)
    var index: Int = 0
    var blocks: [IBlock]
    init(_ blocks: [IBlock]) {
        self.blocks = blocks
    }

    func setBlocks(_ blocks: [IBlock]) {
        self.blocks = blocks
    }

    func buildTree() {
        while index < blocks.count {
            let block = blocks[index]
            switch block {
            case let variableBlock as Variable:
                let variableNode = buildVariableNode(variable: variableBlock)
                rootNode.addChild(variableNode)
                index += 1
            case let printBlock as Printing:
                let printingNode = buildPrintingNode(printing: printBlock)
                rootNode.addChild(printingNode)
                index += 1
            case is Loop:
                if let loopNode = buildNode(getBlockAndMoveIndex(),
                        type: AllTypes.loop) {
                    rootNode.addChild(loopNode)
                }
            case is Condition:
                if let conditionNode = buildNode(getBlockAndMoveIndex(),
                        type: AllTypes.ifBlock) {
                    rootNode.addChild(conditionNode)
                }
            case is BlockDelimiter:
                index += 1
            default:
                index += 1
            }
        }
    }

    private func getMatchingDelimiterIndex() -> Int? {
        var countBegin = 0
        for i in (index + 1)..<blocks.count {
            guard let block = blocks[i] as? BlockDelimiter else {
                continue
            }
            countBegin += countForMatchingDelimiter(block)
            if countBegin == 0 {
                return i
            }
        }
        return nil
    }

    private func countForMatchingDelimiter(_ block: BlockDelimiter) -> Int {
        if isEndDelimiter(block) {
            return -1
        } else if isBeginDelimiter(block) {
            return 1
        }
        return 0
    }

    private func isBeginDelimiter(_ block: BlockDelimiter) -> Bool {
        block.type == DelimiterType.begin
    }

    private func isEndDelimiter(_ block: BlockDelimiter) -> Bool {
        block.type == DelimiterType.end
    }


    private func getBlockAndMoveIndex() -> [IBlock] {
        var wholeBlock: [IBlock] = []
        guard let endIndex = getMatchingDelimiterIndex() else {
            return wholeBlock
        }
        wholeBlock.append(blocks[index])
        wholeBlock += Array(blocks[(index + 1)...endIndex])
        index = endIndex + 1
        return wholeBlock
    }
    
    private func buildVariableNode(variable: Variable) -> Node {
        let node = Node(value: "", type: AllTypes.assign)
        let nameVariable = Node(value: variable.getName(), type: AllTypes.variable)
        let valueVariable = Node(value: variable.getValue(), type: AllTypes.arithmetic)
        node.addChild(nameVariable)
        node.addChild(valueVariable)
        return node
    }
    
    
    private func buildPrintingNode(printing: Printing) -> Node {
        let node = Node(value: printing.value, type: AllTypes.print)
        return node
    }

    private func buildNode(_ block: [IBlock], type: AllTypes) -> Node? {
        guard let firstBlock = block.first else {
            return nil
        }

        var node: Node?

        if type == AllTypes.ifBlock {
            guard let condition = firstBlock as? Condition else {
                return nil
            }
            node = Node(value: condition.value, type: type)
        } else if type == AllTypes.loop {
            guard let loop = firstBlock as? Loop else {
                return nil
            }
            node = Node(value: loop.value, type: type)
        }

        var index = 1

        while index < block.count {
            if block[index] is BlockDelimiter {
                index += 1
                continue
            } else if let variableBlock = block[index] as? Variable {
                let variableNode = buildVariableNode(variable: variableBlock)
                node?.addChild(variableNode)
            } else if let printBlock = block[index] as? Printing {
                let printingNode = buildPrintingNode(printing: printBlock)
                node?.addChild(printingNode)
            } else if let nestedConditionBlock = block[index] as? Condition {
                var nestedBlocks: [IBlock] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedConditionBlock)
                var countBegin: Int = 0
                while additionIndex < block.count {
                    if let blockEnd = block[additionIndex] as? BlockDelimiter {
                        countBegin += countForMatchingDelimiter(blockEnd)
                        if countBegin == 0 {
                            break
                        }
                    }
                    nestedBlocks.append(block[additionIndex])
                    additionIndex += 1
                }
                if let nestedNode = buildNode(nestedBlocks, type: .ifBlock) {
                    node?.addChild(nestedNode)
                }
                index = additionIndex
            } else if let nestedLoopBlock = block[index] as? Loop {
                var nestedBlocks: [IBlock] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedLoopBlock)
                var countBegin: Int = 0
                while additionIndex < block.count {
                    if let blockEnd = block[additionIndex] as? BlockDelimiter {
                        countBegin += countForMatchingDelimiter(blockEnd)
                        if countBegin == 0 {
                            break
                        }
                    }
                    nestedBlocks.append(block[additionIndex])
                    additionIndex += 1
                }
                if let nestedNode = buildNode(nestedBlocks, type: .loop) {
                    node?.addChild(nestedNode)
                }
                index = additionIndex
            }
            index += 1
        }
        return node
    }
}


// {
//    b = 10
//    a = 7 + b + 2
//    print(a)
//    for(int i = 0; i < 10; i++){
//         b = b + 10
//         a = a * 2
//    }
//     if (6 + 2) % 8 == 0 {
//         b = b + 100
//         if a != b {
//             b = b + 100
//         }
//     } 
// }


// var array: [IBlock] = []


// array.append(Variable(id: 1, type: .int, name: "b", value: "10"))
// array.append(Variable(id: 2, type: .int, name: "a", value: "7 + b + 2"))
// array.append(Printing(id: 3, value: "b"))
// array.append(Printing(id: 4, value: "a + b"))
// array.append(Loop(id: 5, type: LoopType.forLoop, value: "i in 0...10"))
// array.append(BlockDelimiter(type: DelimiterType.begin))
// array.append(Variable(id: 6, type: .int, name: "b", value: "b + 10"))
// array.append(Variable(id: 7, type: .int, name: "a", value: "a * 2"))

// array.append(BlockDelimiter(type: DelimiterType.end))
// array.append(Condition(id: 8, type: .ifBlock, value: "(6 + 2) % 8 == 0"))
// array.append(BlockDelimiter(type: .begin))
// array.append(Variable(id: 9, type: .int, name: "b", value: "b + 100"))
// array.append(Condition(id: 10, type: .ifBlock, value: "a != b"))
// array.append(BlockDelimiter(type: .begin))
// array.append(Variable(id: 11, type: .int, name: "c", value: "b + 100"))
// array.append(BlockDelimiter(type: .end))
// array.append(BlockDelimiter(type: .end))


// let tree = Tree(array)
// tree.buildTree()

// let interpreter = Interpreter(tree.rootNode)
// let _ = interpreter.traverseTree(tree.rootNode)


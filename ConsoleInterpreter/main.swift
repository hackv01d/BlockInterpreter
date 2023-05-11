import Foundation


var array: [IBlock] = []


array.append(Printing(id: 1, value: "a"))
array.append(Condition(id: 2, type: ConditionType.ifBlock, value: "i > 5"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Printing(id: 3, value: "b"))
array.append(Condition(id: 4, type: ConditionType.ifBlock, value: "i > 5"))
array.append(BlockDelimiter(type: DelimiterType.begin))

array.append(Loop(id: 5, type: LoopType.forLoop, value: "i in 0...10"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Printing(id: 6, value: "c"))

array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Printing(id: 7, value: "d"))

array.append(BlockDelimiter(type: DelimiterType.end))

array.append(Printing(id: 8, value: "e"))
array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Printing(id: 9, value: "f"))
array.append(Printing(id: 10, value: "ok"))


let tree = Tree(array)
tree.buildTree()
print("hi")

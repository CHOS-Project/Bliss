// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 13:23 BRT
// Last edited on July 08 of 2019, at 22:18 BRT

class MethodCallNode : Node {
	private var target : Node;
	
	method MethodCallNode(target : Node, args : List, filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
		Children.AddList(args);
		this.target = target;
	}
	
	public static method ParseArgs(parser : Parser, start : Token) : List {
		var ret : List = new List();																				// Create our return list
		
		while (!parser.EOF(0) && parser.Peek(0).GetType() != TokenType.CloseParen) {								// And let's parse this argument list
			var arg : Node = Expression.Parse(parser);																// Parse the current argument
			
			if (arg == null) {
				return null;																						// Oh, it failed :/
			}
			
			ret.Add(arg);																							// Add it to the argument list
			
			if (parser.EOF(0) ||
				(parser.Peek(0).GetType() != TokenType.CloseParen && parser.Accept(TokenType.Comma) == null)) {		// Expect a comma or the end of the argument list
				Parser.PrintError(parser.GetLast(start),
								  "expected the closing parentheses after the argument list");
				return null;
			}
		}
		
		return ret;
	}
	
	public method GetTarget : Node { return target; }
}
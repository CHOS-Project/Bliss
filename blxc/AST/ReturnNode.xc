// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 17:58 BRT
// Last edited on July 08 of 2019, at 22:18 BRT

class ReturnNode : Node {
	method ReturnNode(value : Node, filename : String, line, column) {
		super(filename, line, column);																			// Call the super/base class constructor
		
		if (value != null) {																					// Only add the val if it isn't null
			Children.Add(value);
		}
	}
	
	public static method Parse(parser : Parser, start : Token) : Node {
		if (parser.Accept(TokenType.Semicolon) != null) {														// Void return?
			return new ReturnNode(null, start.GetFilename(), start.GetLine(), start.GetColumn());				// Yeah, just create and return a return node with val = null
		}
		
		var val : Node = Expression.Parse(parser);																// Nope, parse the expression
		
		if (val == null) {
			return null;																						// Failed
		} else if (parser.Accept(TokenType.Semicolon) == null) {												// Expect the semicolon
			Parser.PrintError(parser.GetLast(start), "expected a semicolon in the end of the statement");
			return null;
		}
		
		return new ReturnNode(val, start.GetFilename(), start.GetLine(), start.GetColumn());					// Create and return the return node
	}
}

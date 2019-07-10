// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 18:05 BRT
// Last edited on July 10 of 2019, at 17:26 BRT

class SuperNode : Node {
	method SuperNode(args : List, filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
		Children.AddList(args);
	}
	
	public static method Parse(parser : Parser, start : Token) : Node {
		if (parser.Accept(TokenType.OpenParen) == null) {															// Expect the opening parentheses
			Parser.PrintError(parser.GetLast(start), "expected the opening parentheses after the super keyword");
			return null;
		}
		
		var args : List = MethodCallNode.ParseArgs(parser, start);													// Parse the argument list
		
		if (args == null) {
			return null;																							// Failed :/
		} else if (parser.Accept(TokenType.CloseParen) == null) {													// Expect the closing parentheses
			Parser.PrintError(parser.GetLast(start), "expected the closing parentheses after the argument list");
			return null;
		}
		
		return new SuperNode(args, start.GetFilename(), start.GetLine(), start.GetColumn());
	}
}
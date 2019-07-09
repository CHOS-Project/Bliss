// File author is Ítalo Lima Marconato Matias
//
// Created on July 07 of 2019, at 16:40 BRT
// Last edited on July 07 of 2019, at 22:21 BRT

class BreakNode : Node {
	method BreakNode(filename : String, line, column) {
		super(filename, line, column);																// Call the super/base class constructor
	}
	
	public static method Parse(parser : Parser, start : Token) : Node {
		if (parser.Accept(TokenType.Semicolon) == null) {											// Expect a semicolon after the break statement
			Parser.PrintError(start, "expected a semicolon after the break statement");				// ...
			return null;
		}
		
		return new BreakNode(start.GetFilename(), start.GetLine(), start.GetColumn());				// Create and return a break node
	}
}

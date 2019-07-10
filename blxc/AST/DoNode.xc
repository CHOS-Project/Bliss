// File author is Ítalo Lima Marconato Matias
//
// Created on July 07 of 2019, at 22:13 BRT
// Last edited on July 10 of 2019, at 12:167BRT

class DoNode : Node {
	method DoNode(cond : Node, body : Node, filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
		Children.Add(cond);
		Children.Add(body);
	}
	
	public static method Parse(parser : Parser, start : Token) : Node {
		var bstart : Token = parser.Accept(TokenType.OpenBrace), body : Node, ok;									// Let's see if have only one instruction here or a whole scope
		
		if (bstart != null) {
			body = new CodeNode(bstart.GetFilename(), bstart.GetLine(), bstart.GetColumn());						// Full scope!
			ok = CodeNode.ParseScope(parser, start, body.Children, "do-while");										// Parse it!
		} else {
			ok = (parser.Accept(TokenType.Semicolon) != null) ||
				 ((body = CodeNode.ParseSingle(parser, parser.Peek(0))) != null);									// Single instruction, parse it!
		}
		
		if (!ok) {																									// Failed?
			return null;																							// Yeah :(
		} else if (parser.AcceptVal(TokenType.Keyword, "while") == null) {											// Expect the while keyword after the body
			Parser.PrintError(parser.GetLast(start), "expected the while in the do-while statement");				// ...
			return null;
		} else if (parser.Accept(TokenType.OpenParen) == null) {													// Now, expect the opening parentheses
			Parser.PrintError(parser.GetLast(start),
							  "expected the opening parentheses after the while in the do-while statement");		// ...
			return null;
		}
		
		var cond : Node = Expression.Parse(parser);																	// Parse the condition
		
		if (cond == null) {
			return null;																							// Failed :(
		} else if (parser.Accept(TokenType.CloseParen) == null) {													// Expect the closing parentheses
			Parser.PrintError(parser.GetLast(start),
							  "expected the closing parentheses after the do-while statement");						// ...
			return null;
		}
		
		return new DoNode(cond, body, start.GetFilename(), start.GetLine(), start.GetColumn());						// Create and return the do node
	}
}

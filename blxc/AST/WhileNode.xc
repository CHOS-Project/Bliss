// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 20:49 BRT
// Last edited on July 08 of 2019, at 22:19 BRT

class WhileNode : Node {
	method WhileNode(cond : Node, body : Node, filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
		Children.Add(cond);
		Children.Add(body);
	}
	
	public static method Parse(parser : Parser, start : Token) : Node {
		if (parser.Accept(TokenType.OpenParen) == null) {															// Expect the opening parentheses
			Parser.PrintError(parser.GetLast(start),
							"expected the opening parentheses in the while statement");								// ...	
			return null;
		}
		
		var cond : Node = Expression.Parse(parser);																	// Let's parse the condition!
			
		if (cond == null) {
			return null;																							// Failed :(
		} else if (parser.Accept(TokenType.CloseParen) == null) {													// Expect the closing parentheses
			Parser.PrintError(parser.GetLast(start),
							  "expected the closing parentheses after the while condition");
			return null;
		}

		var bstart : Token = parser.Accept(TokenType.OpenBrace), body : Node, ok;									// Let's see if have only one instruction here or a whole scope
		
		if (bstart != null) {
			body = new CodeNode(bstart.GetFilename(), bstart.GetLine(), bstart.GetColumn());						// Full scope!
			ok = CodeNode.ParseScope(parser, start, body.Children, "while");										// Parse it!
		} else {
			ok = (body = CodeNode.ParseSingle(parser, parser.Peek(0))) == null;										// Single instruction, parse it!
		}
		
		if (!ok) {																									// Failed?
			return null;																							// Yeah :(
		}
		
		return new WhileNode(cond, body, start.GetFilename(), start.GetLine(), start.GetColumn());					// Create and return the while node
	}
}
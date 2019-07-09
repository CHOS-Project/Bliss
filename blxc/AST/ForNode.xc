// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 12:46 BRT
// Last edited on July 09 of 2019, at 16:17 BRT

class ForNode : Node {
	method ForNode(init : Node, cond : Node, after : Node, body : Node, filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
		Children.Add(init);
		Children.Add(cond);
		Children.Add(after);
		Children.Add(body);
	}
	
	public static method Parse(parser : Parser, start : Token) : Node {
		if (parser.Accept(TokenType.OpenParen) == null) {															// Expect the opening parentheses
			Parser.PrintError(parser.GetLast(start),
							"expected the opening parentheses in the for statement");								// ...	
			return null;
		}
		
		var init : Node = null;																						// First, let's parse the condition
		
		if (parser.Accept(TokenType.Semicolon) == null) {															// Do we have any?
			var tok : Token = parser.Peek(0);																		// Yes, let's see what it is
			
			if (tok != null && tok.GetType() == TokenType.Keyword && tok.GetValue() == "var") {						// Variable definition?
				init = VariableNode.Parse(parser, parser.Read(1), 1, 0);											// Yes, redirect to VariableNode.Parse!	
				
				if (init == null) {
					return null;																					// And we failed :(
				}
			} else {
				init = Expression.Parse(parser);																	// Expression! Let's parse it
				
				if (init == null) {
					return null;																					// Failed :(
				} else if (parser.Accept(TokenType.Semicolon) == null) {											// Expect the semicolon
					Parser.PrintError(parser.GetLast(start),
									  "expected a semicolon after the initial expression in the for statement");
					return null;
				}
			}
		}
		
		var cond : Node = null;																						// Now, let's parse the condition
		
		if (parser.Accept(TokenType.Semicolon) == null) {															// Do we have any?
			cond = Expression.Parse(parser);																		// Yes! Let's parse it
			
			if (cond == null) {
				return null;																						// Failed :(
			} else if (parser.Accept(TokenType.Semicolon) == null) {												// Expect the semicolon
				Parser.PrintError(parser.GetLast(start),
								  "expected a semicolon after the condition in the for statement");
				return null;
			}
		}
		
		var after : Node = null;																					// Finally, let's parse the after expression
		
		if (parser.Accept(TokenType.CloseParen) == null) {															// Do we have any?
			cond = Expression.Parse(parser);																		// Yes! Let's parse it
			
			if (cond == null) {
				return null;																						// Failed :(
			} else if (parser.Accept(TokenType.CloseParen) == null) {												// Expect the closing parentheses
				Parser.PrintError(parser.GetLast(start),
								  "expected the closing parentheses in the for statement");
				return null;
			}
		}
		
		var bstart : Token = parser.Accept(TokenType.OpenBrace), body : Node, ok;									// Let's see if have only one instruction here or a whole scope
		
		if (bstart != null) {
			body = new CodeNode(bstart.GetFilename(), bstart.GetLine(), bstart.GetColumn());						// Full scope!
			ok = CodeNode.ParseScope(parser, start, body.Children, "for");											// Parse it!
		} else {
			ok = (body = CodeNode.ParseSingle(parser, parser.Peek(0))) == null;										// Single instruction, parse it!
		}
		
		if (!ok) {																									// Failed?
			return null;																							// Yeah :(
		}
		
		return new ForNode(init, cond, after, body, start.GetFilename(), start.GetLine(), start.GetColumn());		// Create and return the for node
	}
}

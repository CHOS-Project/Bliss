// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 13:11 BRT
// Last edited on July 09 of 2019, at 20:15 BRT

class IfNode : Node {
	method IfNode(cond : Node, tbody : Node, fbody : Node, filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
		Children.Add(cond);
		Children.Add(tbody);
		Children.Add(fbody);
	}
	
	public static method Parse(parser : Parser, start : Token) : Node {
		if (parser.Accept(TokenType.OpenParen) == null) {															// Expect the opening parentheses
			Parser.PrintError(parser.GetLast(start),
							"expected the opening parentheses in the if statement");								// ...	
			return null;
		}
		
		var cond : Node = Expression.Parse(parser);																	// Let's parse the condition!
		
		if (cond == null) {
			return null;																							// Failed :(
		} else if (parser.Accept(TokenType.CloseParen) == null) {													// Expect the closing parentheses
			Parser.PrintError(parser.GetLast(start),
							  "expected the closing parentheses after the if condition");
			return null;
		}
		
		var bstart : Token = parser.Accept(TokenType.OpenBrace), tbody : Node, fbody : Node, ok;					// Let's see if have only one instruction here or a whole scope
		
		if (bstart != null) {
			tbody = new CodeNode(bstart.GetFilename(), bstart.GetLine(), bstart.GetColumn());						// Full scope!
			ok = CodeNode.ParseScope(parser, start, tbody.Children, "if");											// Parse it!
		} else {
			ok = (tbody = CodeNode.ParseSingle(parser, parser.Peek(0))) == null;									// Single instruction, parse it!
		}
		
		if (!ok) {																									// Failed?
			return null;																							// Yeah :(
		} else if (parser.AcceptVal(TokenType.Keyword, "else") != null) {											// Do we have a false/else body?
			bstart = parser.Accept(TokenType.OpenBrace);															// Yes, time to parse it!
			
			if (bstart != null) {
				fbody = new CodeNode(bstart.GetFilename(), bstart.GetLine(), bstart.GetColumn());					// Full scope!
				ok = CodeNode.ParseScope(parser, start, fbody.Children, "if");										// Parse it!
			} else {
				ok = (fbody = CodeNode.ParseSingle(parser, parser.Peek(0))) == null;								// Single instruction, parse it!
			}
			
			if (!ok) {
				return null;																						// Failed :(
			}
		} else {
			fbody = null;
		}
		
		return new IfNode(cond, tbody, fbody, start.GetFilename(), start.GetLine(), start.GetColumn());				// Create and return the if node
	}
}
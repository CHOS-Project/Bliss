// File author is Ítalo Lima Marconato Matias
//
// Created on July 07 of 2019, at 20:08 BRT
// Last edited on July 09 of 2019, at 16:14 BRT

class CodeNode : Node {
	method CodeNode(filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
	}
	
	public static method ParseNoScope(parser : Parser, clas : Int8) : Node {
		var tok : Token = parser.Peek(0);
		var ret : CodeNode = new CodeNode(tok.GetFilename(), tok.GetLine(), tok.GetColumn());						// Create the node that we're going to return
		
		while (tok != null && !(clas && tok.GetType() == TokenType.CloseBrace)) {									// Let's parse!
			if (!clas && tok.GetType() == TokenType.Keyword && 
				(tok.GetValue() == "private" || tok.GetValue() == "public" || tok.GetValue() == "static")) {		// Trying to use any class-only modifier outside of a class?
				Parser.PrintError(tok, "public, private and static modifiers can only be used inside of classes");	// Yeah, error out
				return null;
			}
			
			var stat = 0, pub = 1;																					// Let's get the attributes that we should apply to this method/variable
			
			if (parser.AcceptVal(TokenType.Keyword, "static") != null) {											// Static?
				stat = 1;																							// Yes
			}
			
			if (parser.AcceptVal(TokenType.Keyword, "private") != null) {											// Private?
				pub = 0;																							// Yes
			} else {
				parser.AcceptVal(TokenType.Keyword, "public");														// Public
			}
			
			tok = parser.Read(1);																					// Get the next token
			
			if (tok.GetType() == TokenType.Keyword) {																// Keyword?
				var val : String = tok.GetValue();																	// Yes, let's finally parse it!
				var node : Node = null;
				
				if (stat && val == "var") {																			// Trying to define a static variable?
					Parser.PrintError(tok, "static modifier can only be used inside of class methods");				// Yeah, but we don't support it yet
					return null;
				} else if (!clas && val == "class") {																// Class definition
					node = ClassNode.Parse(parser, tok);
				} else if (!clas && val == "enum") {																// Enum definition
					node = EnumNode.Parse(parser, tok);
				} else if (val == "method" || val == "native") {													// Method definition
					node = MethodNode.Parse(parser, tok, pub, stat);
				} else if (!clas && val == "typedef") {																// Type definition/mapping
					node = TypedefNode.Parse(parser, tok);
				} else if (val == "var") {																			// Variable definition
					node = VariableNode.Parse(parser, tok, pub, 0);
				} else if (clas) {																					// Invalid statement, are we inside of a class?
					Parser.PrintError(tok, "expected method or variable definition");								// Yes, print the message saying what we allow inside of classes
				} else {
					Parser.PrintError(tok, "expected typedef, class, enum, method or variable definition");			// No, print the message saying what we allow outside of classes
				}
				
				if (node == null) {
					return null;																					// Failed to parse it :(
				}
				
				ret.Children.Add(node);																				// Add the parsed node
			}
			
			tok = parser.Peek(0);																					// Get the next token
		}
		
		return ret;
	}
	
	public static method ParseScope(parser : Parser, start : Token, children : List, stmt : String) : Int8 {
		var ok = 0;
		
		while (!parser.EOF(0) && !(ok = parser.Accept(TokenType.CloseBrace) != null)) {								// Let's parse this scope until we find the end of it
			var tok : Token = parser.Peek(0);
			var node : Node = ParseSingle(parser, tok);																// Parse this statement
			
			if (node == null && tok.GetType() != TokenType.Semicolon) {
				return 0;																							// Failed :/
			} else if (node != null) {
				children.Add(node);																					// Add it to the method/whatever body
			}
		}
		
		if (!ok && (stmt == "method" || stmt == "scope")) {															// Found closing brace?
			Parser.PrintError(start, "expected the closing brace in the end of the " + stmt);						// Nope
		} else if (!ok) {
			Parser.PrintError(start, "expected the closing brace in the end of the " + stmt + " statement");		// Also no, lol
		}
		
		return ok;
	}
	
	public static method ParseSingle(parser : Parser, tok : Token) : Node {
		var ret : Node = null;
		
		if (tok != null && tok.GetType() == TokenType.Keyword) {													// Keyword?
			var val : String = tok.GetValue();																		// Yes, save the name and let's parse it
			
			if (val == "else") {																					// Else statement
				Parser.PrintError(tok, "else statement without previous if statement");								// Yeah, error out
			} else if (val == "break") {																			// Break statement
				ret = BreakNode.Parse(parser, parser.Read(1));
			} else if (val == "continue") {																			// Continue statement
				ret = ContinueNode.Parse(parser, parser.Read(1));
			} else if (val == "do") {																				// Do statement
				ret = DoNode.Parse(parser, parser.Read(1));
			} else if (val == "for") {																				// For statement
				ret = ForNode.Parse(parser, parser.Read(1));
			} else if (val == "if") {																				// If statement
				ret = IfNode.Parse(parser, parser.Read(1));
			} else if (val == "return") {																			// Return statement
				ret = ReturnNode.Parse(parser, parser.Read(1));
			} else if (val == "var") {																				// Variable definition
				ret = VariableNode.Parse(parser, parser.Read(1), 0, 0);
			} else if (val == "while") {																			// While statement
				ret = WhileNode.Parse(parser, parser.Read(1));
			} else {																								// Expression
				ret = Expression.Parse(parser);
				
				if (ret != null && !(parser.Accept(TokenType.Semicolon) == null)) {									// Semicolon in the end?
					Parser.PrintError(tok, "expected a semicolon after the expression");							// No...
					ret = null;
				}
			}
		} else if (tok != null && tok.GetType() == TokenType.OpenBrace) {											// Scope?
			parser.Read(1);																							// Yes, read the token/go to the next one
			
			ret = new CodeNode(tok.GetFilename(), tok.GetLine(), tok.GetColumn());									// Create our code node
			
			if (!ParseScope(parser, tok, ret.Children, "scope")) {													// And parse!
				ret = null;																							// Oh, it failed...
			}
		} else if (parser.Accept(TokenType.Semicolon) == null) {													// Expression
			ret = Expression.Parse(parser);
				
			if (ret != null && parser.Accept(TokenType.Semicolon) == null) {										// Semicolon in the end?
				Parser.PrintError(parser.GetLast(tok), "expected a semicolon after the expression");				// No...
				ret = null;
			}
		}
		
		return ret;
	}
}

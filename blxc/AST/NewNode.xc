// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 17:0 BRT
// Last edited on July 08 of 2019, at 17:40 BRT

class NewNode : Node {
	private var name : String, levels : List;
	
	method NewNode(name : String, levels : List, args : List, filename : String, line, column) {
		super(filename, line, column);																						// Call the super/base class constructor
		Children.AddList(args);
		this.name = name;
		this.levels = levels;
	}
	
	public static method Parse(parser : Parser, start : Token) : Node {
		var name : Token = parser.Accept(TokenType.Identifier);																// Try to get the type name
		
		if (name == null) {
			Parser.PrintError(parser.GetLast(start), "expected the type name");
			return null;
		} else if (parser.Peek(0).GetType() == TokenType.OpenBracket) {														// Is this an array?
			var levels : List = new List();																					// Yes, so we need to handle it in a different way
			
			while (parser.Accept(TokenType.OpenBracket) != null) {
				var cur : Token = parser.Accept(TokenType.Number);															// Try to get the current level
				
				if (cur == null) {
					Parser.PrintError(parser.GetLast(start), "expected the array size after the opening bracket");
					return null;
				}
				
				levels.Add(StringUtils.ToInt32(cur.GetValue()));															// Convert the value (that it's currently a string) to an int and add it
				
				if (parser.Accept(TokenType.CloseBracket) == null) {														// Now, expect the closing bracket
					Parser.PrintError(parser.GetLast(start), "expected the closing bracket after the array size");
					return null;
				}
			}
			
			return new NewNode(name.GetValue(), levels, null, start.GetFilename(), start.GetLine(), start.GetColumn());		// Create and return the new node
		} else if (parser.Accept(TokenType.OpenParen) == null) {															// Nah, so let's just handle it normally
			Parser.PrintError(parser.GetLast(start), "expected the opening parentheses after the type name");
			return null;
		}
		
		var args : List = MethodCallNode.ParseArgs(parser, start);															// Parse the argument list
		
		if (args == null) {
			return null;
		} else if (parser.Accept(TokenType.CloseParen) == null) {															// Finally, expect the closing parentheses
			Parser.PrintError(parser.GetLast(start), "expected the closing parentheses after the argument list");
			return null;
		}
		
		return new NewNode(name.GetValue(), null, args, start.GetFilename(), start.GetLine(), start.GetColumn());			// Create and return the new node
	}
	
	public method GetName : String { return name; }
	public method GetLevels : List { return levels; }
}
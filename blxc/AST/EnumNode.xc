// File author is Ítalo Lima Marconato Matias
//
// Created on July 07 of 2019, at 22:27 BRT
// Last edited on July 07 of 2019, at 22:42 BRT

class EnumNode : Node {
	private var name : String;
	public var Values : List = new List();
	
	method EnumNode(name : String, filename : String, line, column) {
		super(filename, line, column);																							// Call the super/base class constructor
		this.name = name;
	}
	
	public static method Parse(parser : Parser, start : Token) : Node {
		var name : Any = parser.Accept(TokenType.Identifier);																	// Try to get the enum name
		
		if (name == null) {
			Parser.PrintError(parser.GetLast(start), "expected the enum name");													// Failed :(
			return null;
		} else if (parser.Accept(TokenType.OpenBrace) == null) {																// Expect the opening brace
			Parser.PrintError(parser.GetLast(start), "expected the opening brace after the enum name");							// ...
			return null;
		}
		
		var enu : EnumNode = new EnumNode((name : Token).GetValue(), start.GetFilename(), start.GetLine(), start.GetColumn());	// Create the enum node
		
		while (!(parser.EOF(0) || parser.Peek(0).GetType() == TokenType.CloseBrace)) {											// Parse the enum items
			name = parser.Accept(TokenType.Identifier);
			
			if (name == null) {
				Parser.PrintError(parser.GetLast(start), "expected the enum item name");										// ...
				return null;
			}
			
			name = (name : Token).GetValue();																					// Get the actual name
			
			if (enu.Values.Contains(name)) {																					// Let's see if this isn't a repeated one
				Parser.PrintError(parser.GetLast(start), "redefinition of the enum item '" + name + "'");						// Yes, it is :/
				return null;
			} else if (parser.Accept(TokenType.Comma) == null && parser.Peek(0).GetType() != TokenType.CloseBrace) {			// Expect the comma or the end of the enum
				Parser.PrintError(parser.GetLast(start), "expected a comma after the enum item");								// ...
				return null;
			}
			
			enu.Values.Add(name);
		}
		
		if (parser.Accept(TokenType.CloseBrace) == null) {																		// Expect the closing brace
			Parser.PrintError(parser.GetLast(start), "expected the closing brace in the end of the enum");
			return null;
		}
		
		return enu;
	}
	
	public method GetName : String { return name; }
}

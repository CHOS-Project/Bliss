// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 18:10 BRT
// Last edited on July 08 of 2019, at 18:25 BRT

class TypedefNode : Node {
	private var type : String, name : String;
	
	method TypedefNode(type : String, name : String, filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
		this.type = type;
		this.name = name;
	}
	
	public static method Parse(parser : Parser, start : Token) : Node {
		var type : Any = parser.Accept(TokenType.Identifier);														// First, let's get the original type name
		
		if (type == null) {
			Parser.PrintError(parser.GetLast(start), "expected the original type name");							// ...
			return null;
		}
		
		type = (type : Token).GetValue();																			// Get the actual name using the .GetValue() from the token
		
		while (parser.AcceptVal(TokenType.Operator, "*") != null) {													// Keep on consuming the asterisks
			type += "*";
		}
		
		var name : Token = parser.Accept(TokenType.Identifier);														// Get the "new" type name
		
		if (name == null) {
			Parser.PrintError(parser.GetLast(start), "expected the new type name");									// ... :/
			return null;
		}
		
		return new TypedefNode(type, name.GetValue(), start.GetFilename(), start.GetLine(), start.GetColumn());		// Create and return the typedef node
	}
	
	public method GetType : String { return type; }
	public method GetName : String { return name; }
}

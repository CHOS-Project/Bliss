// File author is Ítalo Lima Marconato Matias
//
// Created on July 07 of 2019, at 22:09 BRT
// Last edited on July 10 of 2019, at 17:34 BRT

class ConvertNode : Node {
	private var type : String;
	
	method ConvertNode(value : Node, type : String, filename : String, line, column) {
		super(filename, line, column);																			// Call the super/base class constructor
		Children.Add(value);
		this.type = type;
	}
	
	public static method ParseType(parser : Parser, start : Token) : String {
		var type : Any = parser.Accept(TokenType.Identifier);													// Let's try to get the name
		
		if (type == null) {
			Parser.PrintError(parser.GetLast(start), "expected the destination type of the conversion");		// :/
			return null;
		}
		
		type = (type : Token).GetValue();																		// Get the actual name
		
		while (parser.AcceptVal(TokenType.Operator, "*") != null) {												// Add all the asterisks that we need (they mean that this is a pointer)
			type += "*";
		}
		
		return type;																							// Return the type
	}
	
	public method GetType : String { return type; }
}

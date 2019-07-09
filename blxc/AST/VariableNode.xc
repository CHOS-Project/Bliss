// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 18:17 BRT
// Last edited on July 09 of 2019, at 16:05 BRT

class VariableNode : Node {
	private var pub, name : String, type : String;
	
	method VariableNode(pub, name : String, type : String, value : Node, filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
		
		this.pub = pub;
		this.name = name;
		this.type = type;
		
		if (value != null) {																						// Only add the val if it isn't null
			Children.Add(value);
		}
	}
	
	public static method Parse(parser : Parser, start : Token, pub, arg) : Node {
		var vars : List = new List();																				// Create the list were we are going to put the variables
		var err : String;																							// Create this string for helping in the error messages
		
		if (arg) {
			err = " argument ";
		} else {
			err = " variable ";
		}
		
		while (!parser.EOF(0) && Check(parser, vars, arg)) {														// And let's go!
			var name : Token = parser.Accept(TokenType.Identifier), type : Any = "Int32", value : Node = null;		// Get the name of this variable
			
			if (name == null) {
				Parser.PrintError(parser.GetLast(start), "expected the" + err + "name");							// ...
				return null;
			} else if (parser.Accept(TokenType.Colon) != null) {													// Set the type?
				type = parser.Accept(TokenType.Identifier);															// Yes, get the type name
				
				if (type == null) {
					Parser.PrintError(parser.GetLast(start), "expected the" + err + "type");						// Failed...
					return null;
				}
				
				type = (type : Token).GetValue();																	// Get the actual type name
				
				while (parser.AcceptVal(TokenType.Operator, "*") != null) {											// Keep on consuming the asterisks
					type += "*";
				}
			}
			
			if (!arg && parser.AcceptVal(TokenType.Operator, "=") != null) {										// Set the initial value?
				 value = Expression.Parse(parser);																	// Yup
				 
				 if (value == null) {
					return null;
				 }
			}
			
			if (!arg && parser.Accept(TokenType.Comma) == null &&
						parser.Peek(0).GetType() != TokenType.Semicolon) {											// Expect a comma or the end of this var def
				Parser.PrintError(parser.GetLast(start),
								  "expected a semicolon or comma after the variable definition");
				return null;
			}
			
			vars.Add(new VariableNode(pub, name.GetValue(), type, value,
									  start.GetFilename(), start.GetLine(), start.GetColumn()));					// Create and add the var node
		}
		
		if (vars.GetLength() > 1) {																					// Variable group?
			return new VariableGroupNode(vars, start.GetFilename(), start.GetLine(), start.GetColumn());			// Yes, create the variable group node and return it
		}
		
		return vars.Get(0);																							// No, just a normal variable, return it
	}
	
	private static method Check(parser : Parser, vars : List, arg) : Int8 {
		if (arg) {																									// Is this an argument inside of a method?
			return vars.GetLength() != 1;																			// Yes, then we can only accept one variable (no variable groups)
		}
		
		return parser.Accept(TokenType.Semicolon) == null;															// Nope, so we just need to check if this isn't a semicolon
	}
	
	public method IsPublic : Int32 { return pub; }
	public method GetName : String { return name; }
	public method GetType : String { return type; }
}

class VariableGroupNode : Node {
	method VariableGroupNode(vars : List, filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
		Children.AddList(vars);
	}
}

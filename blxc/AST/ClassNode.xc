// File author is Ítalo Lima Marconato Matias
//
// Created on July 07 of 2019, at 16:55 BRT
// Last edited on July 10 of 2019, at 17:21 BRT

class ClassNode : Node {
	private var name : String, inherits : String;
	public var Methods : List = new List(), Variables : List = new List();
	
	method ClassNode(name : String, inherits : String, filename : String, line, column) {
		super(filename, line, column);																							// Call the super/base class constructor
		this.name = name;
		this.inherits = inherits;
	}
	
	public static method Parse(parser : Parser, start : Token) : Node {
		var name : Any = parser.Accept(TokenType.Identifier);																	// Try to get the class name
		
		if (name == null) {
			Parser.PrintError(parser.GetLast(start), "expected the class name");												// Failed, error out and return null
			return null;
		}
		
		name = (name : Token).GetValue();																						// Get the actual name
		
		var inherits : Any = null;																								// Alright, let's see if we are inheriting any class
		
		if (parser.Accept(TokenType.Colon) != null) {
			inherits = parser.Accept(TokenType.Identifier);																		// Yes, we are! Let's try to get the name of the inherited class
			
			if (inherits == null) {
				Parser.PrintError(parser.GetLast(start), "expected the base class name");										// Failed :(
				return null;
			}
			
			inherits = (inherits : Token).GetValue();																			// Get the actual name
		}
		
		if (parser.Accept(TokenType.OpenBrace) == null) {																		// Expect the opening brace
			Parser.PrintError(parser.GetLast(start), "expected the opening brace before the class body");						// ...
			return null;
		}
		
		var clas : ClassNode = new ClassNode(name, inherits, start.GetFilename(), start.GetLine(), start.GetColumn());			// Create our class node
		var code : Node = CodeNode.ParseNoScope(parser, 1);																		// And parse the class code!
		
		if (code == null) {
			return null;
		} else if (parser.Accept(TokenType.CloseBrace) == null) {																// Expect the closing brace
			Parser.PrintError(parser.GetLast(start), "expected the closing brace after the class body");						// ...
			return null;
		}
		
		for (var i = 0; i < code.Children.GetLength(); i++) {																	// Now, let's add all the variables and methods to the class node
			var node : Node = code.Children.Get(i);
			
			if (node is MethodNode || node is NativeMethodNode) {																// Is this a method?
				clas.Methods.Add(node);																							// Yes :)
			} else if (node is VariableNode) {																					// Variable?
				clas.Variables.Add(node);																						// Yes :)
			} else if (node is VariableGroupNode) {																				// So it's probably a variable group
				for (var j = 0; j < node.Children.GetLength(); j++) {															// Just add all the variables from the group
					clas.Variables.Add(node.Children.Get(j));
				}
			}
		}
		
		return clas;
	}
	
	public method GetName : String { return name; }
	public method GetInherits : String { return inherits; }
}

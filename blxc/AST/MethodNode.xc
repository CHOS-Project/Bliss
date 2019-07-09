// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 13:32 BRT
// Last edited on July 08 of 2019, at 20:44 BRT

class MethodNode : Node {
	private var pub, stat, name : String, type : String, args : List;
	
	method MethodNode(pub, stat, name : String, type : String, args : List, filename : String, line, column) {
		super(filename, line, column);																					// Call the super/base class constructor
		this.pub = pub;
		this.stat = stat;
		this.name = name;
		this.type = type;
		this.args = args;
	}
	
	public static method Parse(parser : Parser, start : Token, pub, stat) : Node {
		var name : Token = parser.Accept(TokenType.Identifier), type : Any = "Void", args : List = new List();			// This will: try to get the method name, set the type to Void (the default type) and init the args list
		
		if (name == null) {
			Parser.PrintError(parser.GetLast(start), "expected the method name");										// Failed to get the name
			return null;
		} else if (parser.Accept(TokenType.OpenParen) != null) {														// Do we arguments?
			while (!parser.EOF(0) && parser.Accept(TokenType.CloseParen) == null) {										// And let's parse this argument list
				var arg : Node = VariableNode.Parse(parser, parser.Peek(0), 0, 1);										// Parse the current argument
				
				if (arg == null) {
					return null;																						// Oh, it failed :/
				}
				
				args.Add(arg);																							// Add it to the argument list
				
				if (parser.EOF(0) ||
					(parser.Peek(0).GetType() != TokenType.CloseParen && parser.Accept(TokenType.Comma) == null)) {		// Expect a comma or the end of the argument list
					Parser.PrintError(parser.GetLast(start),
									  "expected the closing parentheses after the argument list");
					return null;
				}
			}
		}
		
		if (parser.Accept(TokenType.Colon) != null) {																	// Use the default type?
			type = parser.Accept(TokenType.Identifier);																	// Nope!
			
			if (type == null) {
				Parser.PrintError(parser.GetLast(start), "expected the method return type");							// ...
				return null;
			}
			
			type = (type : Token).GetValue();																			// Get the actual type
			
			while (parser.AcceptVal(TokenType.Operator, "*") != null) {													// Keep on consuming the asterisks!
				type += "*";
			}
		}
		
		if (start.GetValue() == "native") {																				// Is this a native method?
			if (parser.AcceptVal(TokenType.Operator, "=") == null) {													// Yes, expect the equals sign
				Parser.PrintError(parser.GetLast(start), "expected a equal sign followed by the native method index");	// ...
				return null;
			}
			
			var num : Token = parser.Accept(TokenType.Number);															// Get the index
			
			if (num == null) {
				Parser.PrintError(parser.GetLast(start), "expected a equal sign followed by the native method index");	// Failed
				return null;
			} else if (parser.Accept(TokenType.Semicolon) == null) {													// Finally, expect the semicolon
				Parser.PrintError(parser.GetLast(start), "expected a semicolon after the native method declaration");
				return null;
			}
			
			return new NativeMethodNode(pub, stat, name.GetValue(), type, args, StringUtils.ToInt32(num.GetValue()),
										start.GetFilename(), start.GetLine(), start.GetColumn());						// Create and return the native method node
		}
		
		var met : MethodNode = new MethodNode(pub, stat, name.GetValue(), type, args,
											  start.GetFilename(), start.GetLine(), start.GetColumn());					// No, let's create the method node
		
		if (parser.Accept(TokenType.OpenBrace) == null) {																// Expect the opening brace
			Parser.PrintError(parser.GetLast(start), "expected the opening brace before the method body");				// ...
			return null;
		} else if (!CodeNode.ParseScope(parser, start, met.Children, "method")) {										// Parse the method body!
			return null;
		}
		
		return met;
	}
	
	public method IsPublic : Int32 { return pub; }																		// Getters for the private variables
	public method IsStatic : Int32 { return stat; }
	public method GetName : Int32 { return name; }
	public method GetType : Int32 { return type; }
	public method GetArgs : Int32 { return args; }
}

class NativeMethodNode : MethodNode {
	private var idx;
	
	method NativeMethodNode(pub, stat, name : String, type : String, args : List, idx, filename : String, line, column) {
		super(pub, stat, name, type, args, filename, line, column);														// Call the super/base class constructor
		this.idx = idx;
	}
	
	public method GetIndex : Int32 { return idx; }
}
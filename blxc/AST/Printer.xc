// File author is Ítalo Lima Marconato Matias
//
// Created on July 09 of 2019, at 16:24 BRT
// Last edited on July 09 of 2019, at 21:15 BRT

class ASTPrinter {
	public static method Print(ast : Node) {
		PrintNode(ast, 0);																				// Redirect to the PrintNode function
	}
	
	private static method PrintNode(node : Node, tabs) {
		if (node is ArrayNode) {																		// Array
			Out.Write(GetTabs(tabs) + "Array\r\n");
			PrintChildren(node, tabs + 1);																// Print the items
		} else if (node is BinaryOperationNode) {														// Binary Operation
			Out.Write(GetTabs(tabs) + "Binary Operation\r\n");
			Out.Write(GetTabs(tabs + 1) + "Type: " +
					  BinaryOperationNode.BinaryOperationToString(
					  (node : BinaryOperationNode).GetType()) + "\r\n");								// Print the type
			Out.Write(GetTabs(tabs + 1) + "Left:\r\n");
			PrintNode(node.Children.Get(0), tabs + 2);													// Print the left value
			
			if (node.Children.GetLength() > 1) {														// We have a right value?
				Out.Write(GetTabs(tabs + 1) + "Right:\r\n");											// Yes, print it
				PrintNode(node.Children.Get(0), tabs + 2);
			}
		} else if (node is BreakNode) {																	// Break
			Out.Write(GetTabs(tabs) + "Break\r\n");
		} else if (node is ClassNode) {																	// Class
			var clas : ClassNode = node : ClassNode;													// Get our ClassNode
			
			Out.Write(GetTabs(tabs) + "Class '" + clas.GetName() + "'\r\n");
			
			if (clas.GetInherits() != null) {															// Do we inherit anyone?
				Out.Write(GetTabs(tabs + 1) + "Inherits: " + clas.GetInherits() + "\r\n");				// Yes, print it
			}
			
			if (clas.Variables.GetLength() != 0) {														// Do we have any variable?
				Out.Write(GetTabs(tabs + 1) + "Variables:\r\n");										// Yes!
				
				for (var i = 0; i < clas.Variables.GetLength(); i++) {
					PrintNode(clas.Variables.Get(i), tabs + 2);
				}
			}
			
			if (clas.Methods.GetLength() != 0) {														// Do we have any method?
				Out.Write(GetTabs(tabs + 1) + "Methods:\r\n");											// Yes!
				
				for (var i = 0; i < clas.Methods.GetLength(); i++) {
					PrintNode(clas.Methods.Get(i), tabs + 2);
				}
			}
		} else if (node is CodeNode) {																	// Scope
			PrintChildren(node, tabs);
		} else if (node is ContinueNode) {																// Continue
			Out.Write(GetTabs(tabs) + "Continue\r\n");
		} else if (node is ConvertNode) {																// Conversion
			Out.Write(GetTabs(tabs) + "Conversion to '" + (node : ConvertNode).GetType() + "'\r\n");
			PrintNode(node.Children.Get(0), tabs + 1);													// Print the value
		} else if (node is DoNode) {																	// Do Statement
			Out.Write(GetTabs(tabs) + "Do Statement" + "\r\n");
			Out.Write(GetTabs(tabs + 1) + "Condition:\r\n");											// Let's print the condition
			PrintNode(node.Children.Get(0), tabs + 2);
			
			var body : Node = node.Children.Get(1);														// Now let's print the body (if it isn't null)
			
			if (body != null) {
				Out.Write(GetTabs(tabs + 1) + "Body:\r\n");
				PrintNode(body, tabs + 2);
			}
		} else if (node is EnumNode) {																	// Enum
			var enu : EnumNode = node : EnumNode;														// Get our EnumNode
			
			Out.Write(GetTabs(tabs) + "Enum '" + enu.GetName() + "'\r\n");
			
			for (var i = 0; i < enu.Values.GetLength(); i++) {											// Print the values
				Out.Write(GetTabs(tabs + 1) + enu.Values.Get(i) + "\r\n");
			}
		} else if (node is ForNode) {																	// For Statement
			Out.Write(GetTabs(tabs) + "For Statement" + "\r\n");
			
			var init : Node = node.Children.Get(0), cond : Node = node.Children.Get(1),
				after : Node = node.Children.Get(2), body : Node = node.Children.Get(3);				// Get everything
			
			if (init != null) {																			// Print the init if it isn't null
				Out.Write(GetTabs(tabs + 1) + "Init:\r\n");
				PrintNode(init, tabs + 2);
			}
			
			if (cond != null) {																			// Print the cond if it isn't null
				Out.Write(GetTabs(tabs + 1) + "Condition:\r\n");
				PrintNode(cond, tabs + 2);
			}
			
			if (after != null) {																		// Print the after if it isn't null
				Out.Write(GetTabs(tabs + 1) + "After:\r\n");
				PrintNode(after, tabs + 2);
			}
			
			if (body != null) {																			// Print the body if it isn't null
				Out.Write(GetTabs(tabs + 1) + "Body:\r\n");
				PrintNode(body, tabs + 2);
			}
		} else if (node is IdentifierNode) {															// Identifier
			Out.Write(GetTabs(tabs) + "Identifier: " + (node : IdentifierNode).GetValue() + "\r\n");
		} else if (node is IfNode) {																	// If Statement
			Out.Write(GetTabs(tabs) + "If Statement" + "\r\n");
			Out.Write(GetTabs(tabs + 1) + "Condition:\r\n");											// Let's print the condition
			PrintNode(node.Children.Get(0), tabs + 2);
			Out.Write(GetTabs(tabs + 1) + "Body:\r\n");													// Print the body
			PrintNode(node.Children.Get(1), tabs + 2);
			
			var fbody : Node = node.Children.Get(2);													// Print the else body (if it isn't null)
			
			if (fbody != null) {
				Out.Write(GetTabs(tabs + 1) + "Else Body:\r\n");
				PrintNode(fbody, tabs + 2);
			}
		} else if (node is IndexerNode) {																// Array Access
			Out.Write(GetTabs(tabs) + "Array Access" + "\r\n");
			Out.Write(GetTabs(tabs + 1) + "Target:\r\n");												// Let's print the target
			PrintNode(node.Children.Get(0), tabs + 2);
			Out.Write(GetTabs(tabs + 1) + "Index:\r\n");												// Print the index
			PrintNode(node.Children.Get(1), tabs + 2);
		} else if (node is IsNode) {																	// Is Statement
			Out.Write(GetTabs(tabs) + "Is '" + (node : IsNode).GetType() + "'\r\n");
			PrintNode(node.Children.Get(0), tabs + 1);													// Print the value
		} else if (node is MemberAccessNode) {															// Member Access
			Out.Write(GetTabs(tabs) + "Member Access" + "\r\n");
			Out.Write(GetTabs(tabs + 1) + "Target:\r\n");												// Let's print the target
			PrintNode(node.Children.Get(0), tabs + 2);
			Out.Write(GetTabs(tabs + 1) + "Member:\r\n");												// Print the member
			PrintNode(node.Children.Get(1), tabs + 2);
		} else if (node is MethodCallNode) {															// Method Call
			Out.Write(GetTabs(tabs) + "Method Call" + "\r\n");
			Out.Write(GetTabs(tabs + 1) + "Target:\r\n");												// Let's print the target
			PrintNode((node : MethodCallNode).GetTarget(), tabs + 2);
			
			if (node.Children.GetLength() != 0) {														// We have arguments?
				Out.Write(GetTabs(tabs + 1) + "Arguments:\r\n");										// Yes, print them
				PrintChildren(node, tabs + 2);
			}
		} else if (node is MethodNode || node is NativeMethodNode) {									// Method
			var met : MethodNode = node : MethodNode;													// Get our MethodNode
			
			if (node is NativeMethodNode) {																// Native method?
				Out.Write(GetTabs(tabs) + "Native Method '" + met.GetName() + "'");						// Yes
			} else {
				Out.Write(GetTabs(tabs) + "Method '" + met.GetName() + "'");							// Nope
			}
			
			Out.Write(" with type '" + met.GetType() + "'\r\n");										// Print the type
			
			if (!met.IsPublic()) {																		// Public?
				Out.Write(GetTabs(tabs + 1) + "Private\r\n");											// Nope
			}
			
			if (met.IsStatic()) {																		// Static?
				Out.Write(GetTabs(tabs + 1) + "Static\r\n");											// Yes
			}
			
			var args : List = met.GetArgs();															// Get the args
			
			if (args.GetLength() != 0) {																// We have arguments?
				Out.Write(GetTabs(tabs + 1) + "Arguments:\r\n");										// Yes, print them
				
				for (var i = 0; i < args.GetLength(); i++) {											// And print them!
					PrintNode(args.Get(i), tabs + 2);
				}
			}
			
			if (node is NativeMethodNode) {																// Native method?
				Out.Write(GetTabs(tabs + 1) + "Index: " +
						  (node : NativeMethodNode).GetIndex() + "\r\n");
			} else if (node.Children.GetLength() != 0) {												// We have a body?
				Out.Write(GetTabs(tabs + 1) + "Body:\r\n");												// Yes, print it
				PrintChildren(node, tabs + 2);
			}
		} else if (node is NewNode) {																	// New Statement
			var newn : NewNode = node : NewNode;														// Get our NewNode
			
			if (newn.GetLevels() != null) {																// New array?
				Out.Write(GetTabs(tabs) + "New '" + newn.GetName() +
						  GetLevels(newn.GetLevels()) + "'\r\n");										// Yes
			} else {
				Out.Write(GetTabs(tabs) + "New '" + newn.GetName() + "'\r\n");							// Nope, so let's also print the arguments (if we have any)
				
				if (node.Children.GetLength() != 0) {
					PrintChildren(node, tabs + 1);
				}
			}
		} else if (node is NullNode) {																	// Null
			Out.Write(GetTabs(tabs) + "Null\r\n");
		} else if (node is NumberNode) {																// Number
			var num : NumberNode = node : NumberNode;													// Get our NumberNode
			
			if (num.IsSigned()) {																		// Signed number?
				Out.Write(GetTabs(tabs) + "Signed Number: " + num.GetSValue() + "\r\n");				// Yes
			} else {
				Out.Write(GetTabs(tabs) + "Unsigned Number: " + num.GetUValue() + "\r\n");				// Nope, it's unsigned
			}
		} else if (node is FloatNode) {																	// Float
			Out.Write(GetTabs(tabs) + "Float: " + (node : FloatNode).GetValue() + "\r\n");
		} else if (node is ReturnNode) {																// Return
			Out.Write(GetTabs(tabs) + "Return\r\n");
			
			if (node.Children.GetLength() > 1) {														// We have a value?
				PrintNode(node.Children.Get(0), tabs + 1);												// Yes, print it!
			}
		} else if (node is StringNode) {																// String
			Out.Write(GetTabs(tabs) + "String: " + (node : StringNode).GetValue() + "\r\n");
		} else if (node is SuperNode) {																	// Super/Base
			Out.Write(GetTabs(tabs) + "Super\r\n");
			
			if (node.Children.GetLength() != 0) {														// Arguments?
				PrintChildren(node, tabs + 1);															// Yes, print them
			}
		} else if (node is ThisNode) {																	// This
			Out.Write(GetTabs(tabs) + "This\r\n");
		} else if (node is TypedefNode) {																// Typedef
			var td : TypedefNode = node : TypedefNode;													// Get our TypedefNode
			Out.Write(GetTabs(tabs) + "Typedef '" + td.GetName() +
					  "' from '" + td.GetType() + "'\r\n");
		} else if (node is VariableNode) {																// Variable Definition
			var varn : VariableNode = node : VariableNode;												// Get our VariableNode
			
			if (varn.IsPublic()) {																		// Public
				Out.Write(GetTabs(tabs + 1));															// Yes :)
			} else {
				Out.Write(GetTabs(tabs + 1) + "Private ");												// Nope
			}
			
			Out.Write("Variable '" + varn.GetName() + "' with type '" + varn.GetType() + "'\r\n");
			
			if (node.Children.GetLength() > 1) {														// We have a value?
				PrintNode(node.Children.Get(0), tabs + 1);												// Yes, print it!
			}
		} else if (node is WhileNode) {																	// While Statement
			Out.Write(GetTabs(tabs) + "While Statement" + "\r\n");
			Out.Write(GetTabs(tabs + 1) + "Condition:\r\n");											// Let's print the condition
			PrintNode(node.Children.Get(0), tabs + 2);
			
			var body : Node = node.Children.Get(1);														// Now let's print the body (if it isn't null)
			
			if (body != null) {
				Out.Write(GetTabs(tabs + 1) + "Body:\r\n");
				PrintNode(body, tabs + 2);
			}
		} else {
			Out.Write(GetTabs(tabs) + "Unknown\r\n");
		}
	}
	
	private static method PrintChildren(node : Node, tabs) {
		for (var i = 0; i < node.Children.GetLength(); i++) {											// Print all the children nodes
			PrintNode(node.Children.Get(i), tabs);
		}
	}
	
	private static method GetTabs(tabs) : String {
		var ret : String = "";																			// Create the string that we gonna put our spaces/tabs
		
		for (var i = 0; i < tabs; i++) {																// And let's add all the spaces/tabs to it
			ret += "    ";
		}
		
		return ret;
	}
	
	private static method GetLevels(levels : List) : String {
		var ret : String = "";																			// Create the string that we gonna put the string representation of the levels
		
		for (var i = 0; i < levels.GetLength(); i++) {													// Let's do it!
			ret += "[" + levels.Get(i) + "]";
		}
		
		return ret;
	}
}

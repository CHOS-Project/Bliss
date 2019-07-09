// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 20:51 BRT
// Last edited on July 08 of 2019, at 22:27 BRT

class Expression {
	public static method Parse(parser : Parser) : Node {
		return ParseAssign(parser);																									// Let's start this method chain!
	}
	
	private static method ParseAssign(parser : Parser) : Node {
		var left : Node = ParseBooleanOr(parser, null);																				// Get the l-val
		
		if (left == null) {
			return null;
		}
		
		if (parser.AcceptVal(TokenType.Operator, "=") != null) {																	// Simple assignment
			var right : Node = ParseAssign(parser);																					// Parse the r-val
			
			if (right == null) {
				return null;
			}
			
			return new BinaryOperationNode(BinaryOperation.Assignment, left, right,
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Create and return the binary operation node
		} else if (parser.AcceptVal(TokenType.Operator, "+=") != null) {															// Addition + Assignment
			var right : Node = ParseAssign(parser);																					// Parse the r-val
			
			if (right == null) {
				return null;
			}
			
			return new BinaryOperationNode(BinaryOperation.Assignment, left,
										   new BinaryOperationNode(BinaryOperation.Addition, left, right,
																   left.GetFilename(), left.GetLine(), left.GetColumn()),
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Create and return the binary operation node
		} else if (parser.AcceptVal(TokenType.Operator, "-=") != null) {															// Subtraction + Assignment
			var right : Node = ParseAssign(parser);																					// Parse the r-val
			
			if (right == null) {
				return null;
			}
			
			return new BinaryOperationNode(BinaryOperation.Assignment, left,
										   new BinaryOperationNode(BinaryOperation.Subtraction, left, right,
																   left.GetFilename(), left.GetLine(), left.GetColumn()),
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Create and return the binary operation node
		} else if (parser.AcceptVal(TokenType.Operator, "*=") != null) {															// Multiplication + Assignment
			var right : Node = ParseAssign(parser);																					// Parse the r-val
			
			if (right == null) {
				return null;
			}
			
			return new BinaryOperationNode(BinaryOperation.Assignment, left,
										   new BinaryOperationNode(BinaryOperation.Multiplication, left, right,
																   left.GetFilename(), left.GetLine(), left.GetColumn()),
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Create and return the binary operation node
		} else if (parser.AcceptVal(TokenType.Operator, "/=") != null) {															// Division + Assignment
			var right : Node = ParseAssign(parser);																					// Parse the r-val
			
			if (right == null) {
				return null;
			}
			
			return new BinaryOperationNode(BinaryOperation.Assignment, left,
										   new BinaryOperationNode(BinaryOperation.Division, left, right,
																   left.GetFilename(), left.GetLine(), left.GetColumn()),
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Create and return the binary operation node
		} else if (parser.AcceptVal(TokenType.Operator, "%=") != null) {															// Modulus + Assignment
			var right : Node = ParseAssign(parser);																					// Parse the r-val
			
			if (right == null) {
				return null;
			}
			
			return new BinaryOperationNode(BinaryOperation.Assignment, left,
										   new BinaryOperationNode(BinaryOperation.Modulus, left, right,
																   left.GetFilename(), left.GetLine(), left.GetColumn()),
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Create and return the binary operation node
		} else if (parser.AcceptVal(TokenType.Operator, "&=") != null) {															// And + Assignment
			var right : Node = ParseAssign(parser);																					// Parse the r-val
			
			if (right == null) {
				return null;
			}
			
			return new BinaryOperationNode(BinaryOperation.Assignment, left,
										   new BinaryOperationNode(BinaryOperation.BinaryAnd, left, right,
																   left.GetFilename(), left.GetLine(), left.GetColumn()),
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Create and return the binary operation node
		} else if (parser.AcceptVal(TokenType.Operator, "|=") != null) {															// Or + Assignment
			var right : Node = ParseAssign(parser);																					// Parse the r-val
			
			if (right == null) {
				return null;
			}
			
			return new BinaryOperationNode(BinaryOperation.Assignment, left,
										   new BinaryOperationNode(BinaryOperation.BinaryOr, left, right,
																   left.GetFilename(), left.GetLine(), left.GetColumn()),
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Create and return the binary operation node
		} else if (parser.AcceptVal(TokenType.Operator, "^=") != null) {															// Xor + Assignment
			var right : Node = ParseAssign(parser);																					// Parse the r-val
			
			if (right == null) {
				return null;
			}
			
			return new BinaryOperationNode(BinaryOperation.Assignment, left,
										   new BinaryOperationNode(BinaryOperation.BinaryXor, left, right,
																   left.GetFilename(), left.GetLine(), left.GetColumn()),
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Create and return the binary operation node
		} else if (parser.AcceptVal(TokenType.Operator, "<<=") != null) {															// Left Shift + Assignment
			var right : Node = ParseAssign(parser);																					// Parse the r-val
			
			if (right == null) {
				return null;
			}
			
			return new BinaryOperationNode(BinaryOperation.Assignment, left,
										   new BinaryOperationNode(BinaryOperation.LeftShift, left, right,
																   left.GetFilename(), left.GetLine(), left.GetColumn()),
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Create and return the binary operation node
		} else if (parser.AcceptVal(TokenType.Operator, ">>=") != null) {															// Right Shift + Assignment
			var right : Node = ParseAssign(parser);																					// Parse the r-val
			
			if (right == null) {
				return null;
			}
			
			return new BinaryOperationNode(BinaryOperation.Assignment, left,
										   new BinaryOperationNode(BinaryOperation.RightShift, left, right,
																   left.GetFilename(), left.GetLine(), left.GetColumn()),
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Create and return the binary operation node
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseBooleanOr(parser : Parser, lval : Node) : Node {
		var left : Node;																											// Let's get the l-val
		
		if (lval == null) {
			left = ParseBooleanAnd(parser, null);
		} else {
			left = lval;
		}
		
		if (left == null) {
			return null;
		}
		
		if (parser.AcceptVal(TokenType.Operator, "||") != null) {																	// Boolean Or
			var right : Node = ParseBooleanAnd(parser, null);																		// Get the r-val
			
			if (right == null) {
				return null;
			}
			
			var ret : Node = new BinaryOperationNode(BinaryOperation.BooleanOr, left, right,
													 left.GetFilename(), left.GetLine(), left.GetColumn());							// Create our node
			
			if (!parser.EOF(0) && parser.Peek(0).GetType() == TokenType.Operator && parser.Peek(0).GetValue() == "||") {			// Should we call ourselves again?
				return ParseBooleanOr(parser, ret);																					// Yes :)
			}
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseBooleanAnd(parser : Parser, lval : Node) : Node {
		var left : Node;																											// Let's get the l-val
		
		if (lval == null) {
			left = ParseOr(parser, null);
		} else {
			left = lval;
		}
		
		if (left == null) {
			return null;
		}
		
		if (parser.AcceptVal(TokenType.Operator, "&&") != null) {																	// Boolean And
			var right : Node = ParseOr(parser, null);																				// Get the r-val
			
			if (right == null) {
				return null;
			}
			
			var ret : Node = new BinaryOperationNode(BinaryOperation.BooleanAnd, left, right,
													 left.GetFilename(), left.GetLine(), left.GetColumn());							// Create our node
			
			if (!parser.EOF(0) && parser.Peek(0).GetType() == TokenType.Operator && parser.Peek(0).GetValue() == "&&") {			// Should we call ourselves again?
				return ParseBooleanAnd(parser, ret);																				// Yes :)
			}
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseOr(parser : Parser, lval : Node) : Node {
		var left : Node;																											// Let's get the l-val
		
		if (lval == null) {
			left = ParseXor(parser, null);
		} else {
			left = lval;
		}
		
		if (left == null) {
			return null;
		}
		
		if (parser.AcceptVal(TokenType.Operator, "|") != null) {																	// Or
			var right : Node = ParseXor(parser, null);																				// Get the r-val
			
			if (right == null) {
				return null;
			}
			
			var ret : Node = new BinaryOperationNode(BinaryOperation.BinaryOr, left, right,
													 left.GetFilename(), left.GetLine(), left.GetColumn());							// Create our node
			
			if (!parser.EOF(0) && parser.Peek(0).GetType() == TokenType.Operator && parser.Peek(0).GetValue() == "|") {				// Should we call ourselves again?
				return ParseOr(parser, ret);																						// Yes :)
			}
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseXor(parser : Parser, lval : Node) : Node {
		var left : Node;																											// Let's get the l-val
		
		if (lval == null) {
			left = ParseAnd(parser, null);
		} else {
			left = lval;
		}
		
		if (left == null) {
			return null;
		}
		
		if (parser.AcceptVal(TokenType.Operator, "^") != null) {																	// Xor
			var right : Node = ParseAnd(parser, null);																				// Get the r-val
			
			if (right == null) {
				return null;
			}
			
			var ret : Node = new BinaryOperationNode(BinaryOperation.BinaryXor, left, right,
													 left.GetFilename(), left.GetLine(), left.GetColumn());							// Create our node
			
			if (!parser.EOF(0) && parser.Peek(0).GetType() == TokenType.Operator && parser.Peek(0).GetValue() == "|") {				// Should we call ourselves again?
				return ParseXor(parser, ret);																						// Yes :)
			}
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseAnd(parser : Parser, lval : Node) : Node {
		var left : Node;																											// Let's get the l-val
		
		if (lval == null) {
			left = ParseEquals(parser, null);
		} else {
			left = lval;
		}
		
		if (left == null) {
			return null;
		}
		
		if (parser.AcceptVal(TokenType.Operator, "&") != null) {																	// And
			var right : Node = ParseEquals(parser, null);																				// Get the r-val
			
			if (right == null) {
				return null;
			}
			
			var ret : Node = new BinaryOperationNode(BinaryOperation.BinaryAnd, left, right,
													 left.GetFilename(), left.GetLine(), left.GetColumn());							// Create our node
			
			if (!parser.EOF(0) && parser.Peek(0).GetType() == TokenType.Operator && parser.Peek(0).GetValue() == "&") {				// Should we call ourselves again?
				return ParseAnd(parser, ret);																						// Yes :)
			}
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseEquals(parser : Parser, lval : Node) : Node {
		var left : Node;																											// Let's get the l-val
		
		if (lval == null) {
			left = ParseLoGr(parser, null);
		} else {
			left = lval;
		}
		
		if (left == null) {
			return null;
		}
		
		var token : Token = parser.AcceptVal(TokenType.Operator, "=="), type : BinaryOperation;										// Let's try to get if this is a equals sign
		
		if (token == null) {
			token = parser.AcceptVal(TokenType.Operator, "!=");																		// Try to get if this is a not equals sign
			type = BinaryOperation.NotEqualsTo;
		} else {
			type = BinaryOperation.Equals;
		}
		
		if (token != null) {
			var right : Node = ParseLoGr(parser, null);																				// Ok! Let's get the r-val
			
			if (right == null) {
				return null;
			}
			
			var ret : Node = new BinaryOperationNode(type, left, right, left.GetFilename(), left.GetLine(), left.GetColumn());		// Create our node
			
			if (!parser.EOF(0) && parser.Peek(0).GetType() == TokenType.Operator &&
				(parser.Peek(0).GetValue() == "==" || parser.Peek(0).GetValue() == "!=")) {											// Should we call ourselves again?
				return ParseEquals(parser, ret);																					// Yes :)
			}
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseLoGr(parser : Parser, lval : Node) : Node {
		var left : Node;																											// Let's get the l-val
		
		if (lval == null) {
			left = ParseShift(parser, null);
		} else {
			left = lval;
		}
		
		if (left == null) {
			return null;
		}
		
		var token : Token = parser.AcceptVal(TokenType.Operator, ">"), type : BinaryOperation;										// Let's try to get if this is a greater than sign
		
		if (token == null) {
			token = parser.AcceptVal(TokenType.Operator, "<");																		// Try to get if this is a less than sign
			
			if (token == null) {
				token = parser.AcceptVal(TokenType.Operator, ">=");																	// Try to get if this is a greater or equal sign
				
				if (token == null) {
					token = parser.AcceptVal(TokenType.Operator, "<=");																// ... Try to get if this is a lesser or equal sign
					type = BinaryOperation.LesserOrEqual;
				} else {
					type = BinaryOperation.GreaterOrEqual;
				}
			} else {
				type = BinaryOperation.LessThan;
			}
		} else {
			type = BinaryOperation.GreaterThan;
		}
		
		if (token != null) {
			var right : Node = ParseShift(parser, null);																			// Ok! Let's get the r-val
			
			if (right == null) {
				return null;
			}
			
			var ret : Node = new BinaryOperationNode(type, left, right, left.GetFilename(), left.GetLine(), left.GetColumn());		// Create our node
			
			if (!parser.EOF(0) && parser.Peek(0).GetType() == TokenType.Operator &&
				(parser.Peek(0).GetValue() == "<" || parser.Peek(0).GetValue() == ">" ||
				 parser.Peek(0).GetValue() == "<=" || parser.Peek(0).GetValue() == ">=")) {											// Should we call ourselves again?
				return ParseLoGr(parser, ret);																						// Yes :)
			}
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseShift(parser : Parser, lval : Node) : Node {
		var left : Node;																											// Let's get the l-val
		
		if (lval == null) {
			left = ParseAddSub(parser, null);
		} else {
			left = lval;
		}
		
		if (left == null) {
			return null;
		}
		
		var token : Token = parser.AcceptVal(TokenType.Operator, "<<"), type : BinaryOperation;										// Let's try to get if this is a left shift
		
		if (token == null) {
			token = parser.AcceptVal(TokenType.Operator, ">>");																		// Try to get if this is a right shift
			type = BinaryOperation.RightShift;
		} else {
			type = BinaryOperation.LeftShift;
		}
		
		if (token != null) {
			var right : Node = ParseAddSub(parser, null);																			// Ok! Let's get the r-val
			
			if (right == null) {
				return null;
			}
			
			var ret : Node = new BinaryOperationNode(type, left, right, left.GetFilename(), left.GetLine(), left.GetColumn());		// Create our node
			
			if (!parser.EOF(0) && parser.Peek(0).GetType() == TokenType.Operator &&
				(parser.Peek(0).GetValue() == "<<" || parser.Peek(0).GetValue() == ">>")) {											// Should we call ourselves again?
				return ParseShift(parser, ret);																						// Yes :)
			}
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseAddSub(parser : Parser, lval : Node) : Node {
		var left : Node;																											// Let's get the l-val
		
		if (lval == null) {
			left = ParseMulDivMod(parser, null);
		} else {
			left = lval;
		}
		
		if (left == null) {
			return null;
		}
		
		var token : Token = parser.AcceptVal(TokenType.Operator, "+"), type : BinaryOperation;										// Let's try to get if this is an addition
		
		if (token == null) {
			token = parser.AcceptVal(TokenType.Operator, "-");																		// Try to get if this is a subtraction
			type = BinaryOperation.Subtraction;
		} else {
			type = BinaryOperation.Addition;
		}
		
		if (token != null) {
			var right : Node = ParseMulDivMod(parser, null);																		// Ok! Let's get the r-val
			
			if (right == null) {
				return null;
			}
			
			var ret : Node = new BinaryOperationNode(type, left, right, left.GetFilename(), left.GetLine(), left.GetColumn());		// Create our node
			
			if (!parser.EOF(0) && parser.Peek(0).GetType() == TokenType.Operator &&
				(parser.Peek(0).GetValue() == "+" || parser.Peek(0).GetValue() == "-")) {											// Should we call ourselves again?
				return ParseAddSub(parser, ret);																					// Yes :)
			}
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseMulDivMod(parser : Parser, lval : Node) : Node {
		var left : Node;																											// Let's get the l-val
		
		if (lval == null) {
			left = ParseUnary(parser, null);
		} else {
			left = lval;
		}
		
		if (left == null) {
			return null;
		}
		
		var token : Token = parser.AcceptVal(TokenType.Operator, "*"), type : BinaryOperation;										// Let's try to get if this is an addition
		
		if (token == null) {
			token = parser.AcceptVal(TokenType.Operator, "/");																		// Try to get if this is a subtraction
			
			if (token == null) {
				token = parser.AcceptVal(TokenType.Operator, "%");
				type = BinaryOperation.Modulus;
			} else {
				type = BinaryOperation.Division;
			}
		} else {
			type = BinaryOperation.Multiplication;
		}
		
		if (token != null) {
			var right : Node = ParseUnary(parser, null);																			// Ok! Let's get the r-val
			
			if (right == null) {
				return null;
			}
			
			var ret : Node = new BinaryOperationNode(type, left, right, left.GetFilename(), left.GetLine(), left.GetColumn());		// Create our node
			
			if (!parser.EOF(0) && parser.Peek(0).GetType() == TokenType.Operator &&
				(parser.Peek(0).GetValue() == "*" || parser.Peek(0).GetValue() == "/" || parser.Peek(0).GetValue() == "%")) {		// Should we call ourselves again?
				return ParseMulDivMod(parser, ret);																					// Yes :)
			}
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseUnary(parser : Parser, lval : Node) : Node {
		var token : Token = parser.AcceptVal(TokenType.Operator, "-"), type : BinaryOperation, decinc = 0;							// Let's try to get if this is a unary minus
		
		if (token == null) {
			token = parser.AcceptVal(TokenType.Operator, "~");																		// Try to get if this is a binary negation
			
			if (token == null) {
				token = parser.AcceptVal(TokenType.Operator, "!");																	// Try to get if this is a boolean negation
				
				if (token == null) {
					token = parser.AcceptVal(TokenType.Operator, "++");																// Try to get if this is a pre increment
					
					if (token == null) {
						token = parser.AcceptVal(TokenType.Operator, "--");															// ... Try to get if this is a pre decrement
						type = BinaryOperation.Subtraction;
						decinc = 1;
					} else {
						type = BinaryOperation.Addition;
						decinc = 1;
					}
				} else {
					type = BinaryOperation.BooleanNegation;
				}
			} else {
				type = BinaryOperation.Complement;
			}
		} else {
			type = BinaryOperation.Negation;
		}
		
		var left : Node;																											// Let's get the l-val
		
		if (lval == null) {
			left = ParseMethodCall(parser, null);
		} else {
			left = lval;
		}
		
		if (left == null) {
			return null;
		} else if (token != null && decinc) {																						// Pre increment/decrement?
			return new BinaryOperationNode(BinaryOperation.Assignment, left,
										   new BinaryOperationNode(type, left, new NumberNode(1, 0, 1,
																   left.GetFilename(), left.GetLine(), left.GetColumn()),
																   left.GetFilename(), left.GetLine(), left.GetColumn()),
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Yes :)
		} else if (token != null) {
			return new BinaryOperationNode(type, left, null, left.GetFilename(), left.GetLine(), left.GetColumn());					// No, it's just a normal unary operation :)
		} else if (parser.AcceptVal(TokenType.Operator, "++") != null) {															// Post increment?
			return new BinaryOperationNode(BinaryOperation.PostIncrement, left, null,
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Yes :)
		} else if (parser.AcceptVal(TokenType.Operator, "--") != null) {															// Post decrement?
			return new BinaryOperationNode(BinaryOperation.PostDecrement, left, null,
										   left.GetFilename(), left.GetLine(), left.GetColumn());									// Yes :)
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseMethodCall(parser : Parser, lval : Node) : Node {
		var left : Node;																											// Let's get the l-val
		
		if (lval == null) {
			left = ParseTerm(parser);
		} else {
			left = lval;
		}
		
		if (left == null) {
			return null;
		}
		
		var token : Token = parser.Accept(TokenType.OpenParen);																		// First, let's check if this is a method call
		
		if (token != null) {
			var args : List = MethodCallNode.ParseArgs(parser, token);																// Yes, it is! Let's parse the arg list
			
			if (args == null) {
				return null;
			} else if (parser.Accept(TokenType.CloseParen) == null) {																// Now, expect the closing parentheses
				Parser.PrintError(parser.GetLast(token), "expected the closing parentheses after the argument list");
				return null;
			}
			
			return ParseMethodCall(parser, new MethodCallNode(left, args, left.GetFilename(), left.GetLine(), left.GetColumn()));	// Create the method call node and recursevly call ourselves
		} else if ((token = parser.Accept(TokenType.OpenBracket)) != null) {														// Trying to access an array?
			var idx : Node = Parse(parser);																							// Yes, parse the index
			
			if (idx == null) {
				return null;
			} else if (parser.Accept(TokenType.CloseBracket) == null) {																// Now, expect the closing bracket
				Parser.PrintError(parser.GetLast(token), "expected the closing bracket");
				return null;
			}
			
			return ParseMethodCall(parser, new IndexerNode(left, idx, left.GetFilename(), left.GetLine(), left.GetColumn()));		// Create the indexer node and recursevly call ourselves
		} else if ((token = parser.Accept(TokenType.Dot)) != null) {																// Trying to access a member of something?
			var tok : Token = parser.Accept(TokenType.Identifier);																	// Yes, get the member name
			
			if (tok == null) {
				Parser.PrintError(parser.GetLast(token), "expected the member name");
				return null;
			}
			
			var name : Node = new IdentifierNode(tok.GetValue(), tok.GetFilename(), tok.GetLine(), tok.GetColumn());				// Create an identifier node using the name
			
			if (parser.Accept(TokenType.OpenParen) != null) {																		// Method call?
				var args : List = MethodCallNode.ParseArgs(parser, token);															// Yes, parse the argument list
				
				if (args == null) {
					return null;
				} else if (parser.Accept(TokenType.CloseParen) == null) {															// Now, expect the closing parentheses
					Parser.PrintError(parser.GetLast(token), "expected the closing parentheses after the argument list");
					return null;
				}
				
				return ParseMethodCall(parser, new MemberAccessNode(left, new MethodCallNode(name, args,
																    left.GetFilename(), left.GetLine(), left.GetColumn()),
																	left.GetFilename(), left.GetLine(), left.GetColumn()));			// Create the method call node, the member access node and finally recursevly call ourselves with it
			} else {
				return ParseMethodCall(parser, new MemberAccessNode(left, name,
																	left.GetFilename(), left.GetLine(), left.GetColumn()));			// Nope
			}
		} else if ((token = parser.Accept(TokenType.Colon)) != null) {																// Conversion?
			var type : String = ConvertNode.ParseType(parser, token);																// Yes, parse the type
			
			if (type == null) {
				return null;
			}
			
			return ParseMethodCall(parser, new ConvertNode(left, type, left.GetFilename(), left.GetLine(), left.GetColumn()));		// Create the convert node and recursevly call ourselves with it
		} else if ((token = parser.AcceptVal(TokenType.Keyword, "is")) != null) {													// Is statement/operation?
			var tok : Token = parser.Accept(TokenType.Identifier);																	// Yes, parse the type name
			
			if (tok == null) {
				Parser.PrintError(parser.GetLast(token), "expected the type");														// ...
				return null;
			}
			
			return ParseMethodCall(parser, new IsNode(left, tok.GetValue(), left.GetFilename(), tok.GetLine(), tok.GetColumn()));	// Create the is node and do what we have been doing in all the other cases of this function
		}
		
		return left;																												// Nothing to do here, just return the l-val
	}
	
	private static method ParseTerm(parser : Parser) : Node {
		var token : Token = parser.Accept(TokenType.Identifier);																	// First, let's see if this is an identifier
		
		if (token != null) {
			return new IdentifierNode(token.GetValue(), token.GetFilename(), token.GetLine(), token.GetColumn());					// Yes, it is!
		} else if ((token = parser.Accept(TokenType.Number)) != null) {																// Number
			return NumberNode.Parse(token);
		} else if ((token = parser.Accept(TokenType.Float)) != null) {																// Float
			return FloatNode.Parse(token);
		} else if ((token = parser.Accept(TokenType.String)) != null) {																// String
			return new StringNode(token.GetValue(), token.GetFilename(), token.GetLine(), token.GetColumn());
		} else if ((token = parser.Accept(TokenType.OpenParen)) != null) {															// Expression
			var ret : Node = Parse(parser);																							// Parse it
			
			if (ret == null) {
				return null;
			} else if (parser.Accept(TokenType.CloseParen) == null) {																// And expect the closing parentheses
				Parser.PrintError(parser.GetLast(token), "expected the closing parentheses after the expression list");
				return null;
			}
			
			return ret;
		} else if ((token = parser.Accept(TokenType.OpenBrace)) != null) {															// Array
			var ret : Node = new ArrayNode(token.GetFilename(), token.GetLine(), token.GetColumn());								// Create the array node
			
			while (parser.Accept(TokenType.CloseBrace) == null) {																	// Let's parse the elements!
				var val : Node = Parse(parser);																						// Parse this element
				
				if (val == null) {
					return null;
				}
				
				ret.Children.Add(val);																								// Add it to the array
				
				if (parser.EOF(0) ||
					(parser.Peek(0).GetType() != TokenType.CloseBrace && parser.Accept(TokenType.Comma) == null)) {					// Expect a comma or the end of the array
					Parser.PrintError(token, "expected the closing brace after the array");	
					return null;
				}
			}
			
			return ret;																												// Finally, return
		}
		
		Parser.PrintError(parser.Peek(0), "invalid expression term");																// ... We should not get here lol
		
		return null;
	}
}

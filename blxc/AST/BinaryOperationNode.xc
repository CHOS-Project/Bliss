// File author is Ítalo Lima Marconato Matias
//
// Created on July 07 of 2019, at 16:36 BRT
// Last edited on July 08 of 2019, at 21:48 BRT

enum BinaryOperation {
	Assignment,
	Addition,
	Subtraction,
	Division,
	Multiplication,
	Modulus,
	PostIncrement,
	PostDecrement,
	Equals,
	NotEqualsTo,
	LessThan,
	GreaterThan,
	LesserOrEqual,
	GreaterOrEqual,
	BinaryAnd,
	BinaryOr,
	BinaryXor,
	BooleanAnd,
	BooleanOr,
	LeftShift,
	RightShift,
	Negation,
	Complement,
	BooleanNegation
}

class BinaryOperationNode : Node {
	private var type : BinaryOperation;
	
	method BinaryOperationNode(type : BinaryOperation, left : Node, right : Node, filename : String, line, column) {
		super(filename, line, column);													// Call the super/base class constructor
		Children.Add(left);																// The l-val should always not be null, so we don't need to check it
		
		if (right != null) {															// The r-val may be null, so let's check it
			Children.Add(right);														// And add it if it's not null
		}
		
		this.type = type;
	}
	
	public method GetType : BinaryOperation { return type; }
}

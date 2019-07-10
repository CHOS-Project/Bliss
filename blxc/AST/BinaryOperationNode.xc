// File author is Ítalo Lima Marconato Matias
//
// Created on July 07 of 2019, at 16:36 BRT
// Last edited on July 09 of 2019, at 20:45 BRT

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
	
	public static method BinaryOperationToString(type : BinaryOperation) : String {
		if (type == BinaryOperation.Assignment) {										// As our enums don't have ant kind of "to string" function, we need to do it manually
			return "Assignment";
		} else if (type == BinaryOperation.Addition) {
			return "Addition";
		} else if (type == BinaryOperation.Subtraction) {
			return "Subtraction";
		} else if (type == BinaryOperation.Division) {
			return "Division";
		} else if (type == BinaryOperation.Multiplication) {
			return "Multiplication";
		} else if (type == BinaryOperation.PostIncrement) {
			return "Increment";
		} else if (type == BinaryOperation.PostDecrement) {
			return "Decrement";
		} else if (type == BinaryOperation.Equals) {
			return "Equals";
		} else if (type == BinaryOperation.NotEqualsTo) {
			return "Not Equals";
		} else if (type == BinaryOperation.LessThan) {
			return "Less Than";
		} else if (type == BinaryOperation.GreaterThan) {
			return "Greater Than";
		} else if (type == BinaryOperation.LesserOrEqual) {
			return "Lesser Or Equal";
		} else if (type == BinaryOperation.GreaterOrEqual) {
			return "Greater Or Equal";
		} else if (type == BinaryOperation.BinaryAnd) {
			return "And";
		} else if (type == BinaryOperation.BinaryOr) {
			return "Or";
		} else if (type == BinaryOperation.BinaryXor) {
			return "Xor";
		} else if (type == BinaryOperation.BooleanAnd) {
			return "Boolean And";
		} else if (type == BinaryOperation.BooleanOr) {
			return "Boolean Or";
		} else if (type == BinaryOperation.LeftShift) {
			return "Left Shift";
		} else if (type == BinaryOperation.RightShift) {
			return "Right Shift";
		} else if (type == BinaryOperation.Negation) {
			return "Negation";
		} else if (type == BinaryOperation.Complement) {
			return "Complement";
		} else if (type == BinaryOperation.BooleanNegation) {
			return "Boolean Negation";
		} else {
			return "Unknown";
		}
	}
	
	public method GetType : BinaryOperation { return type; }
}

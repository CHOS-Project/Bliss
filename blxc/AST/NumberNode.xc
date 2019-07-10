// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 17:47 BRT
// Last edited on July 10 of 2019, at 16:09 BRT

class NumberNode : Node {
	private var sval, uval : UInt32, signed;
	
	method NumberNode(sval, uval : UInt32, signed, filename : String, line, column) {
		super(filename, line, column);																					// Call the super/base class constructor
		this.sval = sval;
		this.uval = uval;
		this.signed = signed;
	}
	
	public static method Parse(token : Token) : Node {
		var sval : Any* = new Any[1];																					// First, let's try to parse this as a signed value
		
		if (StringUtils.TryToInt32(token.GetValue(), sval) < 1) {
			return new NumberNode(0, StringUtils.ToUInt32(token.GetValue()), 0,
								  token.GetFilename(), token.GetLine(), token.GetColumn());								// Failed, parse this as an unsigned number
		}
		
		return new NumberNode(sval[0], 0, 1, token.GetFilename(), token.GetLine(), token.GetColumn());					// It's a signed number :)
	}
	
	public method GetSValue : Int32 { return sval; }
	public method GetUValue : UInt32 { return uval; }
	public method IsSigned : Int32 { return signed; }
}

class FloatNode : Node {
	private var value : Float;
	
	method FloatNode(value : Float, filename : String, line, column) {
		super(filename, line, column);																					// Call the super/base class constructor
		this.value = value;
	}
	
	public static method Parse(token : Token) : Node {
		return new FloatNode(StringUtils.ToFloat(token.GetValue()),
							 token.GetFilename(), token.GetLine(), token.GetColumn());									// Parse the float number, create the float node and return it
	}
	
	public method GetValue : Float { return value; }
}

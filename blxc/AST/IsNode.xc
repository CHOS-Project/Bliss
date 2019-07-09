// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 13:19 BRT
// Last edited on July 08 of 2019, at 13:20 BRT

class IsNode : Node {
	private var type : String;
	
	method IsNode(value : Node, type : String, filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
		Children.Add(value);
		this.type = type;
	}
	
	public method GetType : String { return type; }
}
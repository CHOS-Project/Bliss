// File author is Ítalo Lima Marconato Matias
//
// Created on July 07 of 2019, at 14:05 BRT
// Last edited on July 07 of 2019, at 16:40 BRT

class Node {
	public var Children : List = new List();
	private var filename : String, line, column;
	
	method Node(filename : String, line, column) {
		this.filename = filename;
		this.line = line;
		this.column = column;
	}
	
	public method GetFilename : String { return filename; }			// Getters for the private variables
	public method GetLine : Int32 { return line; }
	public method GetColumn : Int32 { return column; }
}

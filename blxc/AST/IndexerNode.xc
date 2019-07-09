// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 13:16 BRT
// Last edited on July 08 of 2019, at 13:16 BRT

class IndexerNode : Node {
	method IndexerNode(target : Node, idx : Node, filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
		Children.Add(target);
		Children.Add(idx);
	}
}
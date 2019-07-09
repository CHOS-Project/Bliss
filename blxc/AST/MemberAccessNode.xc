// File author is Ítalo Lima Marconato Matias
//
// Created on July 08 of 2019, at 13:20 BRT
// Last edited on July 08 of 2019, at 13:21 BRT

class MemberAccessNode : Node {
	method MemberAccessNode(target : Node, member : Node, filename : String, line, column) {
		super(filename, line, column);																				// Call the super/base class constructor
		Children.Add(target);
		Children.Add(member);
	}
}
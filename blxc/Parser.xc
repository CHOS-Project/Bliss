// File author is Ítalo Lima Marconato Matias
//
// Created on July 07 of 2019, at 15:44 BRT
// Last edited on July 07 of 2019, at 21:49 BRT

class Parser {
	private var tokens : List, position = 0;
	
	method Parser(tokens : List) {
		this.tokens = tokens;
	}
	
	public static method Parse(tokens : List) : Node {
		return CodeNode.ParseNoScope(new Parser(tokens), 0);									// Create a new parser and redirect to CodeNode.ParseNoScope
	}
	
	public method EOF(pos) : Int8 {
		return position + pos >= tokens.GetLength();											// Check if we are at the end of the token list
	}
	
	public method Peek(pos) : Token {
		if (EOF(pos) || position + pos < 0) {													// Can we get the token from this position?
			return null;																		// Nope :(
		}
		
		return tokens.Get(position + pos);														// Yes :)
	}
	
	public method Read(amount) : Token {
		var ret : Token = Peek(0);																// Get the current token
		position += amount;																		// Increase the current position
		return ret;																				// And return the read token
	}
	
	public method Accept(type : TokenType) : Token {
		var token : Token = Peek(0);															// Get the current token
		
		if (token != null && token.GetType() == type) {											// Check if we aren't at the end of the file and if the type is correct
			Read(1);																			// Everything seems to be OK, let's return the go to the next token and return the read one!
			return token;
		}
		
		return null;																			// Oh, so let's just return null
	}
	
	public method AcceptVal(type : TokenType, value : String) : Token {
		var token : Token = Peek(0);															// Get the current token
		
		if (token != null && token.GetType() == type && token.GetValue() == value) {			// Check if we aren't at the end of the file and if the type is correct
			Read(1);																			// Everything seems to be OK, let's return the go to the next token and return the read one!
			return token;
		}
		
		return null;																			// Oh, so let's just return null
	}
	
	public method GetLast(start : Token) : Token {
		if (EOF(0)) {																			// Can we return the current token?
			return start;																		// Nope, so let's return whatever the user put as the first argument
		}
		
		return Peek(0);																			// Yes, we can! Return the current token
	}
	
	public static method PrintError(tok : Token, msg : String) {
		Out.Write("\e[31m" + tok.GetFilename() + ":" + tok.GetLine() + ":" + tok.GetColumn() +
				  ": error: \e[0m" + msg + "\r\n");												// Print the error message (duh)
	}
}

// File author is Ítalo Lima Marconato Matias
//
// Created on July 06 of 2019, at 15:33 BRT
// Last edited on July 06 of 2019, at 17:48 BRT

enum TokenType {
	Identifier,
	Keyword,
	Number,
	Float,
	String,
	Operator,
	OpenParen,
	CloseParen,
	OpenBrace,
	CloseBrace,
	OpenBracket,
	CloseBracket,
	Colon,
	Semicolon,
	Comma,
	Dot
}

class Token {
	private var type : TokenType, value : String, filename : String, line, column;							// TODO: Implement some type of special attribute, so we don't need to use getters for those variables
	
	method Token(type : TokenType, value : String, filename : String, line, column) {
		this.type = type;
		this.value = value;
		this.filename = filename;
		this.line = line;
		this.column = column;
	}
	
	public static method TokenTypeToString(type : TokenType) : String {
		if (type == TokenType.Identifier) {																	// As our enums don't have ant kind of "to string" function, we need to do it manually
			return "Identifier";
		} else if (type == TokenType.Keyword) {
			return "Keyword";
		} else if (type == TokenType.Number) {
			return "Number";
		} else if (type == TokenType.Float) {
			return "Float";
		} else if (type == TokenType.String) {
			return "String";
		} else if (type == TokenType.Operator) {
			return "Operator";
		} else if (type == TokenType.OpenParen) {
			return "Opening Parentheses";
		} else if (type == TokenType.CloseParen) {
			return "Closing Parentheses";
		} else if (type == TokenType.OpenBrace) {
			return "Opening Brace";
		} else if (type == TokenType.CloseBrace) {
			return "Closing Brace";
		} else if (type == TokenType.OpenBracket) {
			return "Opening Bracket";
		} else if (type == TokenType.CloseBracket) {
			return "Closing Bracket";
		} else if (type == TokenType.Colon) {
			return "Colon";
		} else if (type == TokenType.Semicolon) {
			return "Semicolon";
		} else if (type == TokenType.Comma) {
			return "Comma";
		} else if (type == TokenType.Dot) {
			return "Dot";
		} else {
			return "Unknown";
		}
	}
	
	public static method TokenToString(tok : Token) : String {
		return tok.filename + ":" + tok.line + ":" + tok.column + ": " + TokenTypeToString(tok.type) +
			   ": " + tok.value;																			// Just return a string with all the informations about this token
	}
	
	public method GetType : TokenType { return type; }														// Getters for the private variables
	public method GetValue : String { return value; }
	public method GetFilename : String { return filename; }
	public method GetLine : Int32 { return line; }
	public method GetColumn : Int32 { return line; }
}

class Lexer {
	private var code : String, position = 0, line = 1, column = 1;
	
	method Lexer(code : String) {
		this.code = code;
	}
	
	public static method Lex(filename : String, code : String) : List {
		var lexer : Lexer = new Lexer(code), ret : List = new List();										// Create the lexer and the return list
		
		while (!lexer.EOF(0)) {																				// Let's process all the characters until we hit the EOF
			while (IsWhitespace(lexer.PeekChar(0))) {														// First, consume the whitespaces
				lexer.ReadChar(1);
			}
			
			if (lexer.EOF(0)) {																				// Check if we aren't in the EOF now
				return ret;
			}
			
			var line = lexer.line, column = lexer.column;													// Save the line and the column
			
			if (lexer.PeekChar(0) == "/" && lexer.PeekChar(1) == "/") {										// Single line comment?
				lexer.ReadChar(2);																			// Yes, read the two slashes
				
				while (!lexer.EOF(0) && lexer.PeekChar(0) != "\n") {										// And keep on reading until we reach the EOF or the end of the line
					lexer.ReadChar(1);
				}
			} else if (lexer.PeekChar(0) == "/" && lexer.PeekChar(1) == "*") {								// Multiple line comment?
				lexer.ReadChar(2);																			// Yes, read the slash and the asterisk
				
				while (!lexer.EOF(1) && !(lexer.PeekChar(0) == "*" && lexer.PeekChar(1) == "/")) {			// And keep on reading until we reach the EOF or the end tag
					lexer.ReadChar(1);
				}
				
				lexer.ReadChar(2);
			} else if (IsLetter(lexer.PeekChar(0)) || lexer.PeekChar(0) == "_") {							// Identifier/Keyword?
				var value : String = "";																	// Yes! Let's read all the character from it
				
				while (IsAlphaNumeric(lexer.PeekChar(0)) || lexer.PeekChar(0) == "_") {
					value += lexer.ReadChar(1);
				}
				
				if (value == "break" || value == "class" || value == "continue" || value == "do" ||
					value == "else" || value == "enum" || value == "for" || value == "if" ||
					value == "is" || value == "method" || value == "native" || value == "new" ||
					value == "null" || value == "private" || value == "public" ||
					value == "return" || value == "static" || value == "super" || value == "this" ||
					value == "typedef" || value == "var" || value == "while") {								// Keyword?
					ret.Add(new Token(TokenType.Keyword, value, filename, line, column));					// Yes, then we need to set the type to TokenType.Keyword
				} else {
					ret.Add(new Token(TokenType.Identifier, value, filename, line, column));				// No, so we need to set the type to TokenType.Identifier
				}
			} else if (lexer.PeekChar(0) == "0" && lexer.PeekChar(1) == "b") {								// Binary number?
				var value : String = "0b";																	// Yes, init our value string
				
				lexer.ReadChar(2);																			// Read the first two characters (0 and b)
				
				if (lexer.EOF(0) || !IsBinary(lexer.PeekChar(0))) {											// Do we have anything to read now?
					value += "0";																			// No, so add a zero in the end
				} else {
					while (IsBinary(lexer.PeekChar(0))) {													// Yes, so let's read it!
						value += lexer.ReadChar(1);
					}
				}
				
				ret.Add(new Token(TokenType.Number, value, filename, line, column));						// Create and add the token
			} else if (lexer.PeekChar(0) == "0" && lexer.PeekChar(1) == "o") {								// Octal number?
				var value : String = "0o";																	// Yes, init our value string
				
				lexer.ReadChar(2);																			// Read the first two characters (0 and o)
				
				if (lexer.EOF(0) || !IsOctal(lexer.PeekChar(0))) {											// Do we have anything to read now?
					value += "0";																			// No, so add a zero in the end
				} else {
					while (IsOctal(lexer.PeekChar(0))) {													// Yes, so let's read it!
						value += lexer.ReadChar(1);
					}
				}
				
				ret.Add(new Token(TokenType.Number, value, filename, line, column));						// Create and add the token
			} else if (lexer.PeekChar(0) == "0" && lexer.PeekChar(1) == "x") {								// Octal number?
				var value : String = "0x";																	// Yes, init our value string
				
				lexer.ReadChar(2);																			// Read the first two characters (0 and o)
				
				if (lexer.EOF(0) || !IsHex(lexer.PeekChar(0))) {											// Do we have anything to read now?
					value += "0";																			// No, so add a zero in the end
				} else {
					while (IsHex(lexer.PeekChar(0))) {													// Yes, so let's read it!
						value += lexer.ReadChar(1);
					}
				}
				
				ret.Add(new Token(TokenType.Number, value, filename, line, column));						// Create and add the token
			} else if (IsNumber(lexer.PeekChar(0))) {														// Number?
				var value : String = "", isfloat = 0, first = 0;											// Yes, let's start reading it!
				
				while (IsNumber(lexer.PeekChar(0)) || (!isfloat && lexer.PeekChar(0) == ".")) {
					if (lexer.PeekChar(0) == ".") {															// Float number?
						isfloat = first = 1;																// Yes!
					}
					
					value += lexer.ReadChar(1);																// Add the character
					
					if (first && isfloat) {																	// Check if we need to add a zero in the end?
						if (lexer.EOF(0) || !IsNumber(lexer.PeekChar(0))) {									// Yes, check it
							value += "0";																	// Yes, we need to add it
						}
						
						first = 0;
					}
				}
				
				if (isfloat) {																				// Float number?
					ret.Add(new Token(TokenType.Float, value, filename, line, column));						// Yes, so we need to set the type to TokenType.Float
				} else {
					ret.Add(new Token(TokenType.Number, value, filename, line, column));					// Yes, so we need to set the type to TokenType.Number
				}
			} else if (lexer.PeekChar(0) == "'") {															// Character?
				var value : String = "";																	// Yes!
				
				lexer.ReadChar(1);
				
				while (!lexer.EOF(0) && lexer.PeekChar(0) != "'") {											// Let's keep on reading until we find the end of the file or the closing tag
					var val : String;
					
					if (lexer.PeekChar(0) == "\\") {														// Escape sequence?
						val = ParseEscape(lexer.PeekChar(1), filename, column, line);						// Yes, let's parse it!
						lexer.ReadChar(2);
					} else {
						val = lexer.ReadChar(1);															// No, just read it
					}
					
					if (val == null) {																		// Failed?
						return null;																		// Yes :(
					} else {
						value += val;																		// No, so let's append it to the value :)
					}
				}
				
				if (lexer.EOF(0)) {																			// Reached EOF?
					Out.Write("\e[31m" + filename + ":" + line + ":" + column +								// ... error out and return null
							  ": error:\e[0m unterminated character literal\r\n");
					return null;
				} else if (value.Length > 1) {																// Multi-character literal?
					Out.Write("\e[31m" + filename + ":" + line + ":" + column +								// Yes, but we don't support them yet
							  ": error:\e[0m multi-character literal\r\n");
					return null;
				}
				
				lexer.ReadChar(1);																			// Read the close tag
				ret.Add(new Token(TokenType.Number, value[0] : String, filename, line, column));			// Finally, create and add the token
			} else if (lexer.PeekChar(0) == "\"") {															// String?
				var value : String = "";																	// Yes!
				
				lexer.ReadChar(1);
				
				while (!lexer.EOF(0) && lexer.PeekChar(0) != "\"") {										// Let's keep on reading until we find the end of the file or the closing tag
					var val : String;
					
					if (lexer.PeekChar(0) == "\\") {														// Escape sequence?
						val = ParseEscape(lexer.PeekChar(1), filename, column, line);						// Yes, let's parse it!
						lexer.ReadChar(2);
					} else {
						val = lexer.ReadChar(1);															// No, just read it
					}
					
					if (val == null) {																		// Failed?
						return null;																		// Yes :(
					} else {
						value += val;																		// No, so let's append it to the value :)
					}
				}
				
				if (lexer.EOF(0)) {																			// Reached EOF?
					Out.Write("\e[31m" + filename + ":" + line + ":" + column +								// ... error out and return null
							  ": error:\e[0m unterminated string literal\r\n");
					return null;
				}
				
				lexer.ReadChar(1);																			// Read the close tag
				ret.Add(new Token(TokenType.String, value, filename, line, column));						// Finally, create and add the token
			} else if (lexer.PeekChar(0) == "(") {															// Now, we have lots of single character tokens :)
				ret.Add(new Token(TokenType.OpenParen, lexer.ReadChar(1), filename, line, column));
			} else if (lexer.PeekChar(0) == ")") {
				ret.Add(new Token(TokenType.CloseParen, lexer.ReadChar(1), filename, line, column));
			} else if (lexer.PeekChar(0) == "{") {
				ret.Add(new Token(TokenType.OpenBrace, lexer.ReadChar(1), filename, line, column));
			} else if (lexer.PeekChar(0) == "}") {
				ret.Add(new Token(TokenType.CloseBrace, lexer.ReadChar(1), filename, line, column));
			} else if (lexer.PeekChar(0) == "[") {
				ret.Add(new Token(TokenType.OpenBracket, lexer.ReadChar(1), filename, line, column));
			} else if (lexer.PeekChar(0) == "]") {
				ret.Add(new Token(TokenType.CloseBracket, lexer.ReadChar(1), filename, line, column));
			} else if (lexer.PeekChar(0) == ":") {
				ret.Add(new Token(TokenType.Colon, lexer.ReadChar(1), filename, line, column));
			} else if (lexer.PeekChar(0) == ";") {
				ret.Add(new Token(TokenType.Semicolon, lexer.ReadChar(1), filename, line, column));
			} else if (lexer.PeekChar(0) == ",") {
				ret.Add(new Token(TokenType.Comma, lexer.ReadChar(1), filename, line, column));
			} else if (lexer.PeekChar(0) == ".") {
				ret.Add(new Token(TokenType.Dot, lexer.ReadChar(1), filename, line, column));
			} else {
				Out.Write("\e[31m" + filename + ":" + line + ":" + column +									// Invalid/unrecognized character, error out and return null
						  ": error:\e[0m unrecognized character '" + lexer.PeekChar(0) + "'\r\n");
				return null;
			}
		}
		
		return ret;
	}
	
	private static method IsWhitespace(value : String) : Int8 {
		return value == " " || value == "\n" || value == "\r" || value == "\t" || value == "\v";			// Just check if the value is any of the whitespace characters
	
	}
	
	private static method IsLetter(value : String) : Int8 {
		return value.Length == 1 && ((value[0] >= 'a' && value[0] <= 'z') ||
									(value[0] >= 'A' && value[0] <= 'Z'));									// First, check if the length is one, after that, check if it's a valid letter
	}
	
	private static method IsNumber(value : String) : Int8 {
		return value.Length == 1 && (value[0] >= '0' && value[0] <= '9');									// First, check if the length is one, after that, check if it's a valid number
	}
	
	private static method IsBinary(value : String) : Int8 {
		return value == "0" || value == "1";																// Check if the value is zero or one
	}
	
	private static method IsOctal(value : String) : Int8 {
		return value.Length == 1 && (value[0] >= '0' && value[0] <= '7');									// First, check if the length is one, after that, check if it's in the range of the octal numbers
	}
	
	private static method IsHex(value : String) : Int8 {
		return value.Length == 1 && ((value[0] >= '0' && value[0] <= '9') ||
									 (value[0] >= 'a' && value[0] <= 'f') ||
									 (value[0] >= 'A' && value[0] <= 'F'));									// First, check if the length is one, after that, check if it's a valid hexadecimal number
	}
	
	private static method IsAlphaNumeric(value : String) : Int8 {
		return IsLetter(value) || IsNumber(value);															// Check if it's a letter or a number
	}
	
	private static method ParseEscape(value : String, filename : String, column, line) : String {
		if (value == "a") {																					// Let's check if this escape sequence is valid
			return "\a";
		} else if (value == "b") {
			return "\b";
		} else if (value == "e") {
			return "\e";
		} else if (value == "f") {
			return "\f";
		} else if (value == "n") {
			return "\n";
		} else if (value == "r") {
			return "\r";
		} else if (value == "t") {
			return "\t";
		} else if (value == "v") {
			return "\v";
		} else if (value == "\\") {
			return "\\";
		} else if (value == "'") {
			return "'";
		} else if (value == "\"") {
			return "\"";
		} else if (value == null) {																			// Unterminated escape sequence?
			Out.Write("\e[31m" + filename + ":" + line + ":" + column +
					  ": error:\e[0m unterminated escape sequence\r\n");									// Yes, error out and return null
			return null;
		} else {
			Out.Write("\e[31m" + filename + ":" + line + ":" + column +
					  ": error:\e[0m invalid escape sequence '\\" + value + "'\r\n");							// Invalid escape sequence, error out and return null
			return null;
		}
	}
	
	private method EOF(pos) : Int8 {
		return position + pos >= code.Length;																// Check if we are at the end of the file
	}
	
	private method PeekChar(pos) : String {
		if (EOF(pos) || position + pos < 0) {																// Can we get the character from this position?
			return "";																						// Nope :(
		}
		
		return ({ code[position + pos] }) : String;															// Yes :)
	}
	
	private method ReadChar(amount) : String {
		var cur : String = PeekChar(0);																		// Get the current char
		
		if (cur == "\n") {																					// Go to the next line?
			line++;																							// Yes, also set the column to 1
			column = 1;
		} else if (cur == "\t") {																			// Tab?
			column = (column + 4) & ~3;																		// Yes, go to the next 4-aligned position
		} else {
			column++;																						// Just increase the column
		}
		
		position += amount;																					// Increase the current position
		
		return cur;
	}
}

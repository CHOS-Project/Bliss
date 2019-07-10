// File author is Ítalo Lima Marconato Matias
//
// Created on July 06 of 2019, at 18:00 BRT
// Last edited on July 10 of 2019, at 16:09 BRT

class StringUtils {
	public static method Contains(str : String, value : String) : Int8 {
		if (str == null || value == null) {															// First, let's do a null pointer check
			return 0;
		} else if (str.Length < value.Length) {														// Now, let's check the string size
			return 0;
		}
		
		for (var i = 0; i < str.Length; i++) {														// Pretty inefficient, but, let's mount lot of strings to see if we find a 'value' somewhere
			if (StartsWith(SubString(str, i), value)) {												// Found?
				return 1;																			// Yes!
			}
		}
		
		return 0;																					// Not found :(
	}
	
	public static method StartsWith(str : String, value : String) : Int8 {
		if (str == null || value == null) {															// First, let's do a null pointer check
			return 0;
		} else if (str.Length < value.Length) {														// Now, let's check the string size
			return 0;
		}
		
		for (var i = 0; i < value.Length; i++) {													// Finally, let's check if the characters match
			if (str[i] != value[i]) {
				return 0;																			// They don't match :(
			}
		}
		
		return 1;																					// THEY MATCH!
	}
	
	public static method SubString(str : String, start) : String {
		if (str == null) {																			// First, let's do a null pointer check
			return 0;
		} else if (start == 0) {																	// Now, if start is 0, just return str
			return str;
		}
		
		var ret : String = "";																		// Again, it's inefficient, but let's mount our new string!
		
		for (var i = start; i < str.Length; i++) {
			ret += "0";
			ret[i - start] = str[i];
		}
		
		return ret;																					// And return it!
	}
	
	public static method ToInt32(str : String) : Int32 {
		return ToInt(str, null, 1);
	}
	
	public static method ToUInt32(str : String) : UInt32 {
		return ToInt(str, null, 0);
	}
	
	public static method TryToInt32(str : String, out : Int32*) : Int8 {
		return ToInt(str, out, 1);
	}
	
	public static method TryToUInt32(str : String, out : UInt32*) : Int8 {
		return ToInt(str, out, 0);
	}
	
	public static method ToFloat(str : String) : Float {
		if (str == null) {																			// First, null pointer check
			return 0;
		}
		
		var res : Float = 0, start = 0, point = 0, neg = 0, sign = 0;								// Let's see what is the start position (it will be 0 or 1)
		
		if (StartsWith(str, "-") || StartsWith(str, "+")) {
			start++;																				// Push the start a bit forward
			neg = StartsWith(str, "-");
			sign = 1;
		}
		
		for (var i = start; i < str.Length &&
							((str[i] >= '0' && str[i] <= '9') ||
							 (!point && str[i] == '.')); i++) {										// Now, let's convert!
			if (str[i] == '.') {																	// The floating point?
				point = str.Length - i - 1;															// Yeah :)
			} else {
				res = res * 10 + str[i] - '0';														// Get the new value
			}
		}
		
		if (point != 0) {																			// Need to handle the floating point?													
			res /= Math.Pow(10, point);																// Yes
		}
		
		if (neg) {																					// Negative number?
			res *= -1;																				// Yes
		}
		
		return res;
	}
	
	private static method ToInt(str : String, out : Any*, signed) : Any {
		if (str == null) {																			// First, null pointer check
			return 0;
		}
		
		var base = 10, start = 0, neg = 0, res : Any;												// Let's get the base
		
		if (StartsWith(str, "0b") ||
			(signed && StartsWith(str, "-0b")) || (signed && StartsWith(str, "+0b"))) {				// Binary
			base = 2;
			start += 2;
		} else if (StartsWith(str, "0o") ||
				   (signed && StartsWith(str, "-0o")) || (signed && StartsWith(str, "+0o")) ){		// Octal
			base = 8;
			start += 2;
		} else if (StartsWith(str, "0x") ||
				   (signed && StartsWith(str, "-0x")) || (signed && StartsWith(str, "+0x"))) {
			return ToHex(str, out, signed);															// Hexadecimal, but it needs special treatment
		}
		
		if ((signed && StartsWith(str, "-")) || StartsWith(str, "+")) {
			start++;																				// Push the start a bit forward
			neg = StartsWith(str, "-");
		}
		
		if (signed) {																				// Signed?
			res = 0;																				// Yes, init res with a Int32
		} else {
			res = 0 : UInt32;																		// Nope, init res with a UInt32
		}
		
		for (var i = start; i < str.Length && str[i] >= '0' && str[i] <= ('0' + base - 1); i++) {	// Now, let's convert!
			var old = res;																			// Save the old value
			
			res = res * base + str[i] - '0';														// Get the new value
			
			if (res < old && out != null) {															// And check if it overflows
				return -1;
			} else if (res < old) {
				return 0;
			}
		}
		
		if (signed && neg) {																		// Negative number?
			res *= -1;																				// Yes
		}
		
		if (out != null && out.Length != 0) {														// Return 1 or the result?
			out[0] = res;																			// Return 1
			return 1;
		}
		
		return res;																					// Return the result
	}
	
	private static method ToHex(str : String, out : Any*, signed) : Any {
		var start = 2, res : Any, neg = 0;															// First, let's get the start position
		
		if ((signed && StartsWith(str, "-")) || StartsWith(str, "+")) {
			start++;																				// Push the start a bit forward
			neg = StartsWith(str, "-");
		}
		
		if (signed) {																				// Signed?
			res = 0;																				// Yes, init res with a Int32
		} else {
			res = 0 : UInt32;																		// Nope, init res with a UInt32
		}
		
		for (var i = start; i < str.Length && ((str[i] >= '0' && str[i] <= '9') ||
											   (str[i] >= 'a' && str[i] <= 'f') ||
											   (str[i] >= 'A' && str[i] <= 'F')); i++) {			// Now, let's convert!
			var old = res;																			// Save the old value
			
			res *= 16;																				// Move the value to the left
			
			if (str[i] >= '0' && str[i] <= '9') {													// We need to handle the hex specific numbers/characters differently, so, let's check if it's 0 to 9 or a/A to f/F
				res += str[i] - '0';																// 0 to 9 :)
			} else if (str[i] >= 'a' && str[i] <= 'f') {
				res += str[i] - 'a' + 10;															// a to f :)
			} else {
				res += str[i] - 'A' + 10;															// A to F :)
			}
			
			if (res < old && out != null) {															// And check if it overflows
				return -1;
			} else if (res < old) {
				return 0;
			}
		}
		
		if (signed && neg) {																		// Negative number?
			res *= -1;																				// Yes
		}
		
		if (out != null && out.Length != 0) {														// Return 1 or the result?
			out[0] = res;																			// Return 1
			return 1;
		}
		
		return res;																					// Return the result
	}
}

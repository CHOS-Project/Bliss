// File author is Ítalo Lima Marconato Matias
//
// Created on July 06 of 2019, at 18:00 BRT
// Last edited on July 06 of 2019, at 18:21 BRT

class StringUtils {
	public static method Contains(str : String, value : String) : Int8 {
		if (str == null || value == null) {													// First, let's do a null pointer check
			return 0;
		} else if (str.Length < value.Length) {												// Now, let's check the string size
			return 0;
		}
		
		for (var i = 0; i < str.Length; i++) {												// Pretty inefficient, but, let's mount lot of strings to see if we find a 'value' somewhere
			if (StartsWith(SubString(str, i), value)) {										// Found?
				return 1;																	// Yes!
			}
		}
		
		return 0;																			// Not found :(
	}
	
	public static method StartsWith(str : String, value : String) : Int8 {
		if (str == null || value == null) {													// First, let's do a null pointer check
			return 0;
		} else if (str.Length < value.Length) {												// Now, let's check the string size
			return 0;
		}
		
		for (var i = 0; i < value.Length; i++) {											// Finally, let's check if the characters match
			if (str[i] != value[i]) {
				return 0;																	// They don't match :(
			}
		}
		
		return 1;																			// THEY MATCH!
	}
	
	public static method SubString(str : String, start) : String {
		if (str == null) {																	// First, let's do a null pointer check
			return 0;
		} else if (start == 0) {															// Now, if start is 0, just return str
			return str;
		}
		
		var ret : String = "";																// Again, it's inefficient, but let's mount our new string!
		
		for (var i = start; i < str.Length; i++) {
			ret += "0";
			ret[i - start] = str[i];
		}
		
		return ret;																			// And return it!
	}
}

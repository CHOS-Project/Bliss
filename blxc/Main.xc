// File author is Ítalo Lima Marconato Matias
//
// Created on July 06 of 2019, at 13:58 BRT
// Last edited on July 10 of 2019, at 12:06 BRT

method Main(args : String*) : Int32 {
	if (args.Length == 0) {																							// This application needs at least one argument, do we have it?
		Out.Write("\e[31mblxc: error:\e[0m expected at least one input file (or the -h/--help command)\r\n");		// No, print the error message and return
		return 1;
	}
	
	var inputs : List = new List(), output : String = "a.bliss";													// Create our input file list and the output file string (that may change if the user pass -o/--output)
	
	for (var i = 0; i < args.Length; i++) {																			// Let's parse the arguments!
		if (args[i] == "-h" || args[i] == "--help") {																// Help?
			Out.Write("Usage: blxc [options] inputs\r\n");															// Yes, print the help message and exit
			Out.Write("Options:\r\n");
			Out.Write("    -h | --help      Show this help message\r\n");
			Out.Write("    -o | --output    Set the output file\r\n");
			return 0;
		} else if (args[i] == "-o" || args[i] == "--output") {														// Set the output filename?
			if (args.Length >= i + 1) {																				// Yes, but, did the user passed the output filename?
				Out.Write("\e[31mblxc: error:\e[0m expected the output filename after '" + args[i] + "'\r\n");		// No, error out and return
				return 1;
			} else {
				output = args[++i];																					// Yes, let's save it!
			}
		} else if (args[i][0] == '-') {																				// Unknown option?
			Out.Write("\e[31mblxc: error:\e[0m unknown option '" + args[i] + "'\r\n");								// Yeah, error out and return
			return 1;
		} else if (inputs.Contains(args[i])) {																		// Is this file already in the input file list?
			Out.Write("\e[31mblxc: error:\e[0m duplicated input file '" + args[i] + "'\r\n");						// Yes, error out and return
			return 1;
		} else if (!File.Exists(args[i])) {																			// This file exists?
			Out.Write("\e[31mblxc: error:\e[0m inexistent input file '" + args[i] + "'\r\n");						// No, error out and return
			return 1;
		} else {
			inputs.Add(args[i]);																					// Ok, add this file to the input file list!
		}
	}
	
	for (var i = 0; i < inputs.GetLength(); i++) {																	// Time to compile everything
		var file : String = inputs.Get(i), tokens : List = Lexer.Lex(file, File.ReadAll(file));						// Get the filename and lex the file!
		
		if (tokens == null) {
			return 1;																								// Failed :(
		}
		
		var ast : Node = Parser.Parse(tokens);																		// Parse it!
		
		if (ast == null) {
			return 1;																								// Failed :(
		}
		
		ASTPrinter.Print(ast);																						// Print the AST!
	}
	
	return 0;
}

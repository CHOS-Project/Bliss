// File author is Ítalo Lima Marconato Matias
//
// Created on June 29 of 2019, at 13:32 BRT
// Last edited on June 29 of 2019, at 13:34 BRT

method Main(args : String*) {
	if (args.Length < 1) {																		// Do we have at least one argument?
		WriteString("Please enter your name as the first argument\r\n");						// No, so let's print the error message
	} else {
		WriteString("Hello, " + args[0] + "!\r\n");												// Yes! Print the first argument back
	}
}

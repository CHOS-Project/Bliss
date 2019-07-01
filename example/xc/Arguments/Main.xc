// File author is Ítalo Lima Marconato Matias
//
// Created on June 29 of 2019, at 13:32 BRT
// Last edited on July 01 of 2019, at 13:03 BRT

method Main(args : String*) {
	if (args.Length < 1) {																		// Do we have at least one argument?
		Out.Write("Please enter your name as the first argument\r\n");							// No, so let's print the error message
	} else {
		Out.Write("Hello, " + args[0] + "!\r\n");												// Yes! Print the first argument back
	}
}

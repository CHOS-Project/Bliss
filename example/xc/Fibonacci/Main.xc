// File author is Ítalo Lima Marconato Matias
//
// Created on June 28 of 2019, at 15:54 BRT
// Last edited on July 01 of 2019, at 13:11 BRT

method Fibonacci(num) : Int32 {
	if (num <= 1) {																		// If num is 0 or 1, we don't need to do anything
		return num;
	} else {
		return Fibonacci(num - 1) + Fibonacci(num - 2);									// Else, we need to return Fibonacci(num - 1) + Fibonacci(num + 2)
	}
}

method Main {
	Out.Write("Printing the first 10 terms of the Fibonacci sequence\r\n");
	
	for (var i = 0; i < 10; i++) {
		Out.Write(Fibonacci(i) + "\r\n");												// We don't need to convert it manually to a string, as we are appending a string in the end (this will automatically transform the int result into a string)
	}
}

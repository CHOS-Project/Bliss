// File author is Ítalo Lima Marconato Matias
//
// Created on July 01 of 2019, at 12:34 BRT
// Last edited on July 01 of 2019, at 18:12 BRT

class File {
	private var id, read, write, closed;								// Basic informations about the file
	
	private static native OpenFile(path : String) : Int32 = 0; 			// Native functions that communicate with the Bliss VM
	private static native CreateFile(path : String) : Int32 = 1;
	private static native CloseFile(id) = 2;
	private static native ReadFile(id, length) : Int8* = 3;	
	private static native WriteFile(id, data : Int8*) = 4;
	
	method File(id, read, write, closed) {
		this.id = id;													// Init the basic informations about this file (the ID, and what operations we should allow)
		this.read = read;
		this.write = write;
		this.closed = closed;
	}
	
	public static method Open(path : String) : File {
		var id = OpenFile(path);										// Try to open the file and get the id
		
		if (id == 0) {
			return new File(0, 0, 0, 1);								// Failed, return an empty and closed file
		}
		
		return new File(id, 1, 1, 0);									// Return the opened file!
	}
	
	public static method Create(path : String) : File {
		var id = CreateFile(path);										// Try to create the file, open it, and get the id
		
		if (id == 0) {
			return new File(0, 0, 0, 1);								// Failed, return an empty and closed file
		}
		
		return new File(id, 1, 1, 0);									// Return the opened file!
	}
	
	public method Close {
		if (!closed && id > 2) {										// Can we close this file?
			CloseFile(id);												// Yes, close it and set the closed variable to 1
			closed = 1;
		}
	}
	
	public method Read(length) : Int8* {
		if (closed || !read) {											// We can read from this file?
			return "";													// Nope, return an empty string
		}
		
		return ReadFile(id, length);									// Redirect to the native method
	}
	
	public method Write(data : Int8*) {
		if (closed || !write) {											// We can write to this file?
			return;														// Nope :(
		}
		
		WriteFile(id, data);											// Redirect to the native method
	}
}

var In : File = new File(0, 1, 0, 0);									// Create the Input, Output, and Error files
var Out : File = new File(1, 0, 1, 0);
var Error : File = new File(2, 0, 1, 0);

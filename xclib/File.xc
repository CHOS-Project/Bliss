// File author is Ítalo Lima Marconato Matias
//
// Created on July 01 of 2019, at 12:34 BRT
// Last edited on July 01 of 2019, at 13:02 BRT

class File {
	private var id, read, write;								// Basic informations about the file
	
	private native ReadFile(id, length) : Int8* = 3;			// Native functions that communicate with the Bliss VM
	private native WriteFile(id, data : Int8*) = 4;
	
	method File(id, read, write) {
		this.id = id;											// Init the basic informations about this file (the ID, and what operations we should allow)
		this.read = read;
		this.write = write;
	}
	
	public method Read(length) : Int8* {
		if (!read) {											// We can read from this file?
			return "";											// Nope, return an empty string
		}
		
		return ReadFile(id, length);							// Redirect to the native method
	}
	
	public method Write(data : Int8*) {
		if (!write) {											// We can write to this file?
			return;												// Nope :(
		}
		
		WriteFile(id, data);									// Redirect to the native method
	}
}

var In : File = new File(0, 1, 0);								// Create the Input, Output, and Error files
var Out : File = new File(1, 0, 1);
var Error : File = new File(2, 0, 1);

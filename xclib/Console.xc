// File author is Ítalo Lima Marconato Matias
//
// Created on June 28 of 2019, at 15:50 BRT
// Last edited on June 29 of 2019, at 11:03 BRT

method WriteCharacter(data : Int8) {
	WriteFile(1, { data });
}

method WriteString(data : String) {
	WriteFile(1, data);
}

method ReadLine : String {
	return ReadFile(0, 0);
}

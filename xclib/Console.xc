// File author is Ítalo Lima Marconato Matias
//
// Created on June 28 of 2019, at 15:50 BRT
// Last edited on June 28 of 2019, at 15:51 BRT

method WriteCharacter(data : Int8) {
	WriteFile(1, { data });
}

method WriteString(data : Int8*) {
	WriteFile(1, data);
}

method ReadLine : Int8* {
	return ReadFile(0, 0);
}

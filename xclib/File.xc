// File author is Ítalo Lima Marconato Matias
//
// Created on June 28 of 2019, at 15:48 BRT
// Last edited on June 28 of 2019, at 15:50 BRT

native OpenFile(path : Int8*) : Int32 = 0;
native CreateFile(path : Int8*) : Int32 = 1;
native CloseFile(file) = 2;
native ReadFile(file, length) : Int8* = 3;
native WriteFile(file, data : Int8*) = 4;
native GetFilePosition(file) : Int32 = 5;
native SetFilePosition(file, off, origin) = 6;

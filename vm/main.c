// File author is Ítalo Lima Marconato Matias
//
// Created on July 12 of 2019, at 17:18 BRT
// Last edited on July 13 of 2019, at 21:52 BRT

#include <bliss.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void *read_file(char *fname, long *outl) {
	FILE *file = fopen(fname, "rb");																	// Try to open the file
	
	if (file == NULL) {
		return NULL;																					// Failed...
	}
	
	fseek(file, 0, SEEK_END);																			// Go to the end of the file (to get the length)
	
	long length = ftell(file);																			// Get the current position!
	void *buf = malloc(length);																			// Try to alloc our buffer
	
	if (buf == NULL) {
		fclose(file);
		return NULL;
	}
	
	rewind(file);																						// Rewind it back to the beginning
	
	if (!fread(buf, length, 1, file)) {																	// Try to read it!
		free(buf);																						// Failed...
		fclose(file);
		return NULL;
	}
	
	fclose(file);																						// Close the file
	
	if (outl != NULL) {																					// Should we save the length?
		*outl = length;																					// Yes!
	}
	
	return buf;																							// Return the buffer!
}

static short get_int16(char *file, int pos) { return *((short*)&file[pos]); }							// Helper functions, the only one that we don't need is the get_int8
static int get_int32(char *file, int pos) { return *((int*)&file[pos]); }
static uint8_t get_uint8(char *file, int pos) { return *((uint8_t*)&file[pos]); }
static uint16_t get_uint16(char *file, int pos) { return *((uint16_t*)&file[pos]); }
static uint32_t get_uint32(char *file, int pos) { return *((uint32_t*)&file[pos]); }
static float get_float(char *file, int pos) { return *((float*)&file[pos]); }

int main(int argc, char **argv) {
	char *input = NULL;
	
	if (argc < 2) {																						// Check if we have any arguments
		printf("\e[31mblvm: error:\e[0m expected at least the input file\r\n");							// We don't have any :(
		return 1;
	}
	
	for (int i = 1; i < argc; i++) {																	// Let's parse the arguments!
		if (input == NULL) {																			// It's the input?
			input = argv[i];																			// Yes!
		} else {
			printf("\e[31mblvm: error:\e[0m arguments aren't implemented yet\r\n");						// Argument to the main function!
			return 1;
		}
	}
	
	long length;
	char *file = read_file(input, &length);																// Let's try to read the input file
	
	if (file == NULL) {
		printf("\e[31mblvm: error:\e[0m inexistent input file '%s'\r\n", input);						// It doesn't exists, error out
		return 1;
	} else if (length < 20) {																			// Does it have at least the size of the bliss executable header?
		printf("\e[31mblvm: error:\e[0m corrupted input file '%s'\r\n", input);							// Nope, error out
		free(file);
		return 1;
	} else if (file[0] != 0x42 || file[1] != 0x4C || file[2] != 0x56 || file[3] != 0x4D) {				// Check the file header magic number
		printf("\e[31mblvm: error:\e[0m corrupted input file '%s'\r\n", input);							// Invalid, error out
		free(file);
		return 1;
	}
	
	bliss_module_t *module = bliss_create_module(get_int32(file, 4), get_int32(file, 8),
												 get_int32(file, 12));									// Create the module
	
	if (module == NULL) {
		free(file);																						// Failed :(
		return 1;
	}
	
	int pos = 16;																						// Let's add all the methods
	
	for (int i = 0; i < module->method_count; i++) {
		bliss_method_t *method = &module->methods[i];													// Get the method
		int nlen = get_int32(file, pos + 8);															// Get the name length
		char *name = malloc(nlen + 1);																	// Let's get the name
		
		if (name == NULL) {
			printf("\e[31mblvm: error:\e[0m out of memory\r\n");										// Failed, error out
			free(module);
			return 1;
		}
		
		name[nlen] = 0;																					// Zero end it
		memcpy(name, file + pos + 12, nlen);															// Copy the name
		bliss_init_method(method, get_int32(file, pos), get_int32(file, pos + 4), name,
						  get_int32(file, pos + nlen + 12));											// Init the method struct
		
		pos += nlen + 16;																				// Increase the position
		
		for (int j = 0; j < method->body_length; j++) {													// Let's add all the instructions
			bliss_instr_t *instr = &method->body[j];													// Get the instruction
			
			bliss_init_instr(instr, get_int32(file, pos), get_int32(file, pos + 4));					// Init the instr struct
			
			pos += 8;																					// Increase the position
			
			for (int k = 0; k < instr->op_count; k++) {													// Finally, add the operands
				bliss_operand_t *oper = &instr->operands[k];											// Get the operand
				int type = get_int32(file, pos);														// Get the type
				int stype = get_int32(file, pos + 4);													// Get the subtype
				bliss_value_t value;
				
				pos += 8;																				// Increase the position
				
				switch (type) {																			// Let's get the value
					case BLISS_OPERAND_INT8: {															// Signed 8-bits integer
						value.int8_value = file[pos++];
						break;
					}
					case BLISS_OPERAND_INT16: {															// Signed 16-bits integer
						value.int16_value = get_int16(file, pos);
						pos += 2;
						break;
					}
					case BLISS_OPERAND_INT32:
					case BLISS_OPERAND_COND:
					case BLISS_OPERAND_STRING:
					case BLISS_OPERAND_LOCAL:
					case BLISS_OPERAND_GLOBAL:
					case BLISS_OPERAND_ARG:
					case BLISS_OPERAND_METHOD: {														// Signed 32-bits integer
						value.int32_value = get_int32(file, pos);
						pos += 4;
						break;
					}
					case BLISS_OPERAND_UINT8: {															// Unsigned 8-bits integer
						value.uint8_value = get_uint8(file, pos++);
						break;
					}
					case BLISS_OPERAND_UINT16: {														// Unsigned 16-bits integer
						value.uint16_value = get_uint16(file, pos);
						pos += 2;
						break;
					}
					case BLISS_OPERAND_UINT32: {														// Unsigned 32-bits integer
						value.uint32_value = get_uint32(file, pos);
						pos += 4;
						break;
					}
					case BLISS_OPERAND_FLOAT: {															// Float
						value.float_value = get_float(file, pos);
						pos += 4;
						break;
					}
				}
				
				bliss_init_operand(oper, type, stype, value);											// Init the operand struct
			}
		}
	}
	
	module->string_count = get_int32(file, pos);														// Get the amount of strings
	module->strings = malloc(module->string_count * sizeof(char*));										// Allocate the space for the strings
	
	if (module->string_count != 0 && module->strings == NULL) {
		printf("\e[31mblvm: error:\e[0m out of memory\r\n");											// Failed, error out
		module->string_count = 0;
		bliss_free_module(module);
		return 0;
	}
	
	pos += 4;																							// Increase the position
	
	for (int i = 0; i < module->string_count; i++) {													// Let's add all the strings
		int slen = get_int32(file, pos);																// Get the string length
		char *string = malloc(slen + 1);																// Let's get the string
		
		if (string == NULL) {
			printf("\e[31mblvm: error:\e[0m out of memory\r\n");										// Failed, error out
			module->string_count = i;
			bliss_free_module(module);
			return 0;
		}
		
		memcpy(string, file + pos + 4, slen);															// Copy the string
		
		string[slen] = 0;																				// Zero end it
		module->strings[i] = string;
		pos += slen + 4;																				// Increase the position
	}
	
	free(file);																							// We don't need the loaded file bytes anymore
	bliss_free_module(module);																			// Free the module
	
	return 0;
}

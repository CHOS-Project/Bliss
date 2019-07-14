// File author is Ítalo Lima Marconato Matias
//
// Created on July 13 of 2019, at 16:33 BRT
// Last edited on July 13 of 2019, at 21:45 BRT

#include <bliss.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void bliss_init_operand(bliss_operand_t *oper, int type, int subtype, bliss_value_t value) {
	oper->type = type;																							// Setup all the fields
	oper->subtype = subtype;
	oper->value = value;
}

int bliss_init_instr(bliss_instr_t *instr, int type, int opers) {
	instr->type = type;																							// Setup all the fields
	instr->op_count = opers;
	instr->operands = malloc(sizeof(bliss_operand_t) * opers);													// Allocate the space for the operands
	
	if (instr->operands == NULL && opers != 0) {
		printf("\e[31mblvm: error:\e[0m out of memory\r\n");													// Failed, error out
		return 0;
	}
	
	return 1;
}

void bliss_free_instr(bliss_instr_t *instr) {
	if (instr != NULL && instr->operands != NULL) {																// We need to free the operands?
		free(instr->operands);																					// Yes
	}
}

int bliss_init_method(bliss_method_t *method, int args, int locals, char *name, int blength) {
	method->args = args;																						// Setup all the fields
	method->locals = locals;
	method->name = name;
	method->body_length = blength;
	method->body = malloc(sizeof(bliss_instr_t) * blength);														// Allocate the space for the instructions
	
	if (method->body == NULL && blength != 0) {
		printf("\e[31mblvm: error:\e[0m out of memory\r\n");													// Failed, error out
		return 0;
	}
	
	return 1;
}

void bliss_free_method(bliss_method_t *method) {
	if (method != NULL) {																						// We need to free something?
		free(method->name);																						// Yes, start by freeing the name
		
		if (method->body != NULL) {																				// And free the body
			for (int i = 0; i < method->body_length; i++) {
				bliss_free_instr(&method->body[i]);
			}
			
			free(method->body);
		}
	}
}

bliss_module_t *bliss_create_module(int entry, int globals, int methods) {
	bliss_module_t *module = malloc(sizeof(bliss_module_t));													// Alloc the memory
	
	if (module == NULL) {
		printf("\e[31mblvm: error:\e[0m out of memory\r\n");													// Failed, error out
		return NULL;
	}
	
	module->entry = entry;																						// Setup all the fields
	module->globals = globals;
	module->method_count = methods;
	module->methods = malloc(sizeof(bliss_method_t) * methods);													// Allocate the space for the methods
	
	if (module->methods == NULL) {
		printf("\e[31mblvm: error:\e[0m out of memory\r\n");													// Failed, error out
		free(module);
		return NULL;
	}
	
	return module;
}

void bliss_free_module(bliss_module_t *module) {
	if (module != NULL) {																						// Valid module?
		if (module->methods != NULL) {																			// Yes, free the methods
			for (int i = 0; i < module->method_count; i++) {
				bliss_free_method(&module->methods[i]);
			}
			
			free(module->methods);
		}
		
		if (module->strings != NULL) {																			// Free the strings
			for (int i = 0; i < module->string_count; i++) {
				free(module->strings[i]);
			}
		}
		
		free(module);																							// Free the module struct
	}
}

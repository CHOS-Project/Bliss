// File author is Ítalo Lima Marconato Matias
//
// Created on July 13 of 2019, at 13:54 BRT
// Last edited on July 13 of 2019, at 21:45 BRT

#ifndef __BLISS_H__
#define __BLISS_H__

#include <stdint.h>

#define BLISS_COND_EQUALS 0x00						// Values for BLISS_OPERAND_COND
#define BLISS_COND_NEQUALS 0x01
#define BLISS_COND_GREATER 0x02
#define BLISS_COND_NGREATER 0x03
#define BLISS_COND_LOWER 0x04
#define BLISS_COND_NLOWER 0x05
#define BLISS_COND_GREQ 0x06
#define BLISS_COND_NGREQ 0x07
#define BLISS_COND_LOEQ 0x08
#define BLISS_COND_NLOEQ 0x09

#define BLISS_OPERAND_VOID 0x00						// Values for bliss_operand_t.type and bliss_operand_t.subtype
#define BLISS_OPERAND_INT8 0x01
#define BLISS_OPERAND_INT16 0x02
#define BLISS_OPERAND_INT32 0x03
#define BLISS_OPERAND_UINT8 0x04
#define BLISS_OPERAND_UINT16 0x05
#define BLISS_OPERAND_UINT32 0x06
#define BLISS_OPERAND_FLOAT 0x07
#define BLISS_OPERAND_ARRAY 0x08
#define BLISS_OPERAND_ANY 0x09
#define BLISS_OPERAND_COND 0x0A
#define BLISS_OPERAND_STRING 0x0B
#define BLISS_OPERAND_LOCAL 0x0C
#define BLISS_OPERAND_GLOBAL 0x0D
#define BLISS_OPERAND_ARG 0x0E
#define BLISS_OPERAND_RETVAL 0x0F
#define BLISS_OPERAND_METHOD 0x10
#define BLISS_OPERAND_NULL 0x11

#define BLISS_INSTR_MOV 0x00						// Values for bliss_instr_t.type
#define BLISS_INSTR_ADD 0x01
#define BLISS_INSTR_SUB 0x02
#define BLISS_INSTR_MUL 0x03
#define BLISS_INSTR_DIV 0x04
#define BLISS_INSTR_MOD 0x05
#define BLISS_INSTR_SHL 0x06
#define BLISS_INSTR_SHR 0x07
#define BLISS_INSTR_AND 0x08
#define BLISS_INSTR_OR 0x09
#define BLISS_INSTR_XOR 0x0A
#define BLISS_INSTR_ROUND 0x0B
#define BLISS_INSTR_SQRT 0x0C
#define BLISS_INSTR_LOG 0x0D
#define BLISS_INSTR_POW 0x0E
#define BLISS_INSTR_CMP 0x0F
#define BLISS_INSTR_CMPR 0x10
#define BLISS_INSTR_NOT 0x11
#define BLISS_INSTR_NEG 0x12
#define BLISS_INSTR_LNOT 0x13
#define BLISS_INSTR_BR 0x14
#define BLISS_INSTR_BRC 0x15
#define BLISS_INSTR_CALL 0x16
#define BLISS_INSTR_RETURN 0x17
#define BLISS_INSTR_NEWARR 0x18
#define BLISS_INSTR_RSZARR 0x19
#define BLISS_INSTR_APPENDARR 0x1A
#define BLISS_INSTR_ARRSIZE 0x1B
#define BLISS_INSTR_ARRSUBST 0x1C
#define BLISS_INSTR_READARR 0x1D
#define BLISS_INSTR_WRITEARR 0x1E
#define BLISS_INSTR_NCALL 0x1F

struct bliss_operand_s;

typedef union {
	char int8_value;
	short int16_value;
	int int32_value;
	uint8_t uint8_value;
	uint16_t uint16_value;
	uint32_t uint32_value;
	float float_value;
	struct bliss_operand_s *array_value;
} bliss_value_t;

typedef struct bliss_operand_s {
	int type;
	int subtype;
	bliss_value_t value;
} bliss_operand_t;

typedef struct {
	int type;
	int op_count;
	bliss_operand_t *operands;
} bliss_instr_t;

typedef struct {
	int args;
	int locals;
	char *name;
	int body_length;
	bliss_instr_t *body;
} bliss_method_t;

typedef struct {
	int entry;
	int globals;
	int method_count;
	bliss_method_t *methods;
	int string_count;
	char **strings;
} bliss_module_t;

void bliss_init_operand(bliss_operand_t *oper, int type, int subtype, bliss_value_t value);
int bliss_init_instr(bliss_instr_t *instr, int type, int opers);
int bliss_init_method(bliss_method_t *method, int args, int locals, char *name, int blength);
bliss_module_t *bliss_create_module(int entry, int globals, int methods);
void bliss_free_instr(bliss_instr_t *instr);
void bliss_free_method(bliss_method_t *method);
void bliss_free_module(bliss_module_t *module);

#endif		// __BLISS_H__

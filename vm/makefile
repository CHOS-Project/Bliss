# File author is Ítalo Lima Marconato Matias
#
# Created on July 12 of 2019, at 17:18 BRT
# Last edited on July 13 of 2019, at 16:33 BRT

VERBOSE ?= false
DEBUG ?= false

OBJECTS := bliss.c.o main.c.o

OBJECTS := $(addprefix build/,$(OBJECTS))
OUTPUT := build/blvm

ifneq ($(VERBOSE),true)
NOECHO := @
endif

all: $(OUTPUT)

clean:
	$(NOECHO)rm -f $(OBJECTS) $(OUTPUT)

clean-all:
	$(NOECHO)rm -rf build

remake: clean all

$(OUTPUT): $(OBJECTS)
	$(NOECHO)echo Linking $@
	$(NOECHO)if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
	$(NOECHO)gcc -O3 -o $@ $(OBJECTS) $(LDFLAGS) -lm

build/%.c.o: %.c
	$(NOECHO)echo Compiling $<
	$(NOECHO)if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
ifeq ($(DEBUG),yes)
	$(NOECHO)gcc -g -std=gnu11 -DDEBUG -DARCH=\"$(ARCH)\" -Iinclude -O0 -Wall -Wextra $(CFLAGS) -c $< -o $@
else
	$(NOECHO)gcc -std=gnu11 -DARCH=\"$(ARCH)\" -Iinclude -O3 -Wall -Wextra -Wno-stringop-truncation $(CFLAGS) -c $< -o $@
endif


<p align=center>

<a href="https://github.com/CHOSTeam/Bliss/releases/latest">
  <img alt="Download the latest version"
       src="https://img.shields.io/badge/Download-latest-green.svg"/>
</a>

</p>

## What is Bliss?

Bliss is an bytecode virtual machine for creating portable applications, it will be bundled with <a href="https://github.com/CHOSTeam/CHicago">CHicago</a> but will also support Windows, Linux, macOS and other platforms.

The blasm folder contains the source code of the assembler.

The blxc folder contains the source code of the ExtendedC compiler.

The asmlib folder contains the source code of the core library for creating applications using the Bliss Assembler.

The xclib folder contains the source code of the core library for creating applications using the ExtendedC compiler.

The example folder contains some examples, like a Fibonacci sequence implementation, and how to access the arguments passed to Main.

The vm folder contains the virtual machine.


## Where is the virtual machine and the toolchain?

For now, they are closed source and made in C# (they are completely uncommented and unoptimized).

I will port the virtual machine to C and implement a JIT compiler for it, also, I will port the toolchain to ExtendedC (a C-like language that I'm still developing).

// Copyright Danny Arends 2020.
// Distributed under the Boost Software License, Version 1.0.
// (See: http://www.boost.org/LICENSE_1_0.txt)

module bindbc.gles.egltypes;

import core.stdc.stdint;

alias EGLNativeDisplayType = void*;

enum : ubyte {
    EGL_FALSE        = 0,
    EGL_TRUE         = 1,
}

alias EGLint = int;
alias EGLBoolean = uint;
alias EGLenum = uint;
alias EGLConfig = void*;
alias EGLContext = void*;
alias EGLDisplay = void*;
alias EGLSurface = void*;
alias EGLClientBuffer = void*;
alias EGLSync = void*;
alias EGLAttrib = intptr_t;
alias EGLTime = ulong;
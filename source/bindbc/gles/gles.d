// Copyright Danny Arends 2020.
// Distributed under the Boost Software License, Version 1.0.
// (See: http://www.boost.org/LICENSE_1_0.txt)

module bindbc.gles.gles;

import bindbc.loader;

public import bindbc.gles.config,
              bindbc.gles.glestypes,
              bindbc.gles.glesconstants;

private {
    SharedLib lib;
    GLESSupport contextVersion = GLESSupport.noContext;
    GLESSupport loadedVersion = GLESSupport.noContext;
}

void unloadGLES()
{
    if(lib != invalidHandle) {
        lib.unload();
        contextVersion = loadedVersion = GLESSupport.noContext;
    }
}

GLESSupport loadGLES()
{
    version(Windows) {
        const(char)[][1] libNames = ["libglesv2.dll"];
    }
    else version(Posix) {
        const(char)[][2] libNames = [
            "libGLESv2.so.2",
            "libGLESv2.so"
        ];
    }
    else static assert(0, "bindbc-gles is not yet supported on this platform");

    GLESSupport ret;
    foreach(name; libNames) {
        ret = loadGLES(name.ptr);
        if(ret != GLESSupport.noLibrary) break;
    }
    return ret;
}

GLESSupport loadGLES(const(char)* libName)
{
    // If the library isn't yet loaded, load it now.
    if(lib == invalidHandle) {
        lib = load(libName);
        if(lib == invalidHandle) {
            return GLESSupport.noLibrary;
        }
    }
    if(!lib.loadGLES()) return GLESSupport.badLibrary;
    return loadedVersion;
}


extern(System) @nogc nothrow {
    // V1.0
    alias pglActiveTexture = void function( GLenum );
    alias pglAlphaFunc = void function(GLenum, GLfloat);
    alias pglBindBuffer = void function( GLenum, GLuint );
    alias pglBindTexture = void function( GLenum, GLuint );
    alias pglBlendFunc = void function( GLenum, GLenum );
    alias pglBufferData = void function( GLenum, GLsizeiptr, const void*, GLenum );
    alias pglBufferSubData = void function( GLenum, GLintptr, GLsizeiptr, const void* );
    alias pglClear = void function( GLbitfield );
    alias pglClearColor = void function( GLfloat, GLfloat, GLfloat, GLfloat );
    alias pglClearDepthf = void function( GLfloat );
    alias pglClearStencil = void function( GLint );
    alias pglClientActiveTexture = void function(GLenum);
    alias pglClipPlanef = void function(GLenum, const(GLfloat)*);
    alias pglColor4f = void function(GLfloat, GLfloat, GLfloat, GLfloat);
    alias pglColor4ub = void function(GLubyte, GLubyte, GLubyte, GLubyte);
    alias pglColor4x = void function(GLfixed, GLfixed, GLfixed, GLfixed);
    alias pglColorMask = void function(GLboolean, GLboolean, GLboolean, GLboolean);
    alias pglColorPointer = void function(GLint, GLenum, GLsizei, const(void)*);
    alias pglCompressedTexImage2D = 
                void function(GLenum, GLint, GLenum, GLsizei, GLsizei, GLint, GLsizei, const(void)*);
    alias pglCompressedTexSubImage2D = 
                void function(GLenum, GLint, GLint, GLint, GLsizei, GLsizei, GLenum, GLsizei, const(void)*);
    alias pglCopyTexImage2D = void function(GLenum, GLint, GLenum, GLint, GLint, GLsizei, GLsizei, GLint);
    alias pglCopyTexSubImage2D = void function(GLenum, GLint, GLint, GLint, GLint, GLint, GLsizei, GLsizei);
    alias pglCullFace = void function(GLenum);
    //glCurrentPaletteMatrix
    alias pglDeleteBuffers = void function(GLsizei, const(GLuint)*);
    alias pglDeleteTextures = void function(GLsizei, const(GLuint)*);
    alias pglDepthFunc = void function(GLenum);
    alias pglDepthMask = void function(GLboolean);
    alias pglDepthRangef = void function(GLfloat, GLfloat);
    alias pglDepthRangex = void function(GLfixed, GLfixed);
    alias pglDrawArrays = void function( GLenum, GLint, GLsizei );
    alias pglDrawElements = void function( GLenum, GLsizei, GLenum, const void* );
    //glDrawTex
    alias pglEnable = void function(GLenum);
    alias pglEnableClientState = void function(GLenum);
    alias pglFinish = void function();
    alias pglFlush = void function();
    alias pglFogf = void function(GLenum, GLfloat);
    alias pglFogfv = void function(GLenum, const(GLfloat)*);
    alias pglFogx = void function(GLenum, GLfixed);
    alias pglFogxv = void function(GLenum, const(GLfixed)*);
    alias pglFrontFace = void function(GLenum);
    alias pglFrustumf = void function(GLfloat, GLfloat, GLfloat, GLfloat, GLfloat, GLfloat);
    alias pglFrustumx = void function(GLfixed, GLfixed, GLfixed, GLfixed, GLfixed, GLfixed);
    alias pglGenBuffers = void function(GLsizei, GLuint*);
    alias pglGenTextures = void function(GLsizei, GLuint*);
    //glGet
    alias pglGetBufferParameteriv = void function(GLenum, GLenum, GLint*);
    alias pglGetClipPlanex = void function(GLenum, GLfixed*);
    alias pglGetClipPlanef = void function(GLenum, GLfloat*);
    alias pglGetError = GLenum function();
    alias pglGetFixedv = void function(GLenum, GLfixed*);
    alias pglGetIntegerv = void function(GLenum, GLint*);
    alias pglGetLightfv = void function(GLenum, GLenum, GLfloat*);
    alias pglGetLightxv = void function(GLenum, GLenum, GLfixed*);
    alias pglGetMaterialfv = void function(GLenum, GLenum, GLfloat*);
    alias pglGetMaterialxv = void function(GLenum, GLenum, GLfixed*);
    alias pglGetPointerv = void function(GLenum, void**);
    alias pglGetString = const( char )* function( GLenum );
    alias pglGetTexEnvfv = void function(GLenum, GLenum, GLfloat*);
    alias pglGetTexEnviv = void function(GLenum, GLenum, GLint*);
    alias pglGetTexEnvxv = void function(GLenum, GLenum, GLfixed*);
    alias pglGetTexParameterfv = void function(GLenum, GLenum, GLfloat*);
    alias pglGetTexParameteriv = void function(GLenum, GLenum, GLint*);
    alias pglGetTexParameterxv = void function(GLenum, GLenum, GLfixed*);
    alias pglHint = void function(GLenum, GLenum);
    //glIntro
    alias pglIsBuffer = GLboolean function(GLuint);
    alias pglIsEnabled = GLboolean function(GLenum);
    alias pglIsTexture = GLboolean function(GLuint);
    alias pglLightf = void function(GLenum, GLenum, GLfloat);
    alias pglLightfv = void function(GLenum, GLenum, const(GLfloat)*);
    alias pglLightx = void function(GLenum, GLenum, GLfixed);
    alias pglLightxv = void function(GLenum, GLenum, const(GLfixed)*);    
    alias pglLightModelf = void function(GLenum, GLfloat);
    alias pglLightModelfv = void function(GLenum, const(GLfloat)*);
    alias pglLightModelx = void function(GLenum, GLfixed);
    alias pglLightModelxv = void function(GLenum, const(GLfixed)*);
    alias pglLineWidth = void function(GLfloat);
    alias pglLineWidthx = void function(GLfixed);
    alias pglLoadIdentity = void function();
    alias pglLoadMatrixf = void function(const(GLfloat)*);
    alias pglLoadMatrixx = void function(const(GLfixed)*);
    //glLoadPaletteFromModelViewMatrix
    //glLogicOp
    alias pglMaterialf = void function(GLenum, GLenum, GLfloat);
    alias pglMaterialfv = void function(GLenum, GLenum, const(GLfloat)*);
    alias pglMaterialx = void function(GLenum, GLenum, GLfixed);
    alias pglMaterialxv = void function(GLenum, GLenum, const(GLfixed)*);
    //glMatrixIndexPointer
    alias pglMatrixMode = void function(GLenum);
    alias pglMultiTexCoord4f = void function(GLenum, GLfloat, GLfloat, GLfloat, GLfloat);
    alias pglMultiTexCoord4x = void function(GLenum, GLfixed, GLfixed, GLfixed, GLfixed);
    alias pglMultMatrixf = void function(const(GLfloat)*);
    alias pglMultMatrixx = void function(const(GLfixed)*);
    alias pglNormal3f = void function(GLfloat, GLfloat, GLfloat);
    alias pglNormal3x = void function(GLfixed, GLfixed, GLfixed);
    alias pglNormalPointer = void function(GLenum, GLsizei, const(void)*);
    alias pglOrthof = void function(GLfloat, GLfloat, GLfloat, GLfloat, GLfloat, GLfloat);
    alias pglOrthox = void function(GLfixed, GLfixed, GLfixed, GLfixed, GLfixed, GLfixed);
    alias pglPixelStorei = void function(GLenum, GLint);
    alias pglPointParameterf = void function(GLenum, GLfloat);
    alias pglPointParameterfv = void function(GLenum, const(GLfloat)*);
    alias pglPointParameterx = void function(GLenum, GLfixed);
    alias pglPointParameterxv = void function(GLenum, const(GLfixed)*);
    alias pglPointSize = void function(GLfloat);
    alias pglPointSizex = void function(GLfixed);
    //glPointSizePointerOES
    alias pglPolygonOffset = void function(GLfloat, GLfloat);
    alias pglPolygonOffsetx = void function(GLfixed, GLfixed);
    alias pglPushMatrix = void function();
    //glQueryMatrix
    alias pglReadPixels = void function(GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, void*);
    alias pglRotatef = void function(GLfloat, GLfloat, GLfloat, GLfloat);
    alias pglRotatex = void function(GLfixed, GLfixed, GLfixed, GLfixed);
    alias pglSampleCoverage = void function(GLfloat, GLboolean);
    alias pglSampleCoveragex = void function(GLclampx, GLboolean);
    alias pglScalex = void function(GLfixed, GLfixed, GLfixed);
    alias pglScissor = void function(GLint, GLint, GLsizei, GLsizei);
    alias pglShadeModel = void function(GLenum);
    alias pglStencilFunc = void function(GLenum, GLint, GLuint);
    alias pglStencilMask = void function(GLuint);
    alias pglStencilOp = void function(GLenum, GLenum, GLenum);
    alias pglTexCoordPointer = void function(GLint, GLenum, GLsizei, const(void)*);
    alias pglTexEnvi = void function(GLenum, GLenum, GLint);
    alias pglTexEnvx = void function(GLenum, GLenum, GLfixed);
    alias pglTexEnviv = void function(GLenum, GLenum, const(GLint)*);
    alias pglTexEnvxv = void function(GLenum, GLenum, const(GLfixed)*);
    alias pglTexImage2D = void function(GLenum, GLint, GLint, GLsizei, GLsizei, GLint, GLenum, GLenum, const(void)*);
    alias pglTexParameteri = void function(GLenum, GLenum, GLint);
    alias pglTexParameterx = void function(GLenum, GLenum, GLfixed);
    alias pglTexParameteriv = void function(GLenum, GLenum, const(GLint)*);
    alias pglTexParameterxv = void function(GLenum, GLenum, const(GLfixed)*);
    alias pglTexSubImage2D = void function(GLenum, GLint, GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, const(void)*);
    alias pglTranslatex = void function(GLfixed, GLfixed, GLfixed);
    alias pglVertexPointer = void function(GLint, GLenum, GLsizei, const(void)*);
    alias pglViewport = void function(GLint, GLint, GLsizei, GLsizei);
    //glWeightPointer
    
    //V2.0
    alias pglDisable = void function( GLenum );
    alias pglBindAttribLocation = GLint function(GLuint, GLuint, const(GLchar)*);
    alias pglGetAttribLocation = GLint function(GLuint, const(GLchar)*);
    alias pglBindFramebuffer = void function( GLenum, GLuint );
    alias pglBindRenderbuffer = void function( GLenum, GLuint );
    alias pglGenFramebuffers = void function( GLsizei, GLuint* );
    alias pglGenRenderbuffers = void function( GLsizei, GLuint* );
    alias pglRenderbufferStorage = void function( GLenum, GLenum, GLsizei, GLsizei );
    alias pglFramebufferRenderbuffer = void function( GLenum, GLenum, GLenum, GLuint );
    alias pglFramebufferTexture2D = void function( GLenum, GLenum, GLenum, GLuint, GLint );
    alias pglCheckFramebufferStatus = GLenum function( GLenum );
    alias pglGetUniformLocation = GLint function( GLuint, const (GLchar)* );
    alias pglUniform1f = void function( GLint, GLfloat);
    alias pglUniform1i = void function( GLint, GLint);
    alias pglUniform2f = void function( GLint, GLfloat, GLfloat);
    alias pglUniform2i = void function( GLint, GLint, GLint);
    alias pglUniform3f = void function( GLint, GLfloat, GLfloat, GLfloat);
    alias pglUniform3i = void function( GLint, GLint, GLint, GLint);
    alias pglUniform4f = void function( GLint, GLfloat, GLfloat, GLfloat, GLfloat);
    alias pglUniform4i = void function( GLint, GLint, GLint, GLint, GLint);
    alias pglUniform1fv = void function( GLint, GLsizei, const (GLfloat)* );
    alias pglUniform2fv = void function( GLint, GLsizei, const (GLfloat)* );
    alias pglUniform3fv = void function( GLint, GLsizei, const (GLfloat)* );
    alias pglUniform4fv = void function( GLint, GLsizei, const (GLfloat)* );
    alias pglUniform1iv = void function( GLint, GLsizei, const (GLint)* );
    alias pglUniform2iv = void function( GLint, GLsizei, const (GLint)* );
    alias pglUniform3iv = void function( GLint, GLsizei, const (GLint)* );
    alias pglUniform4iv = void function( GLint, GLsizei, const (GLint)* );
    alias pglUniformMatrix2fv = void function( GLint, GLsizei, GLboolean, const (GLfloat)* );
    alias pglUniformMatrix3fv = void function( GLint, GLsizei, GLboolean, const (GLfloat)* );
    alias pglUniformMatrix4fv = void function( GLint, GLsizei, GLboolean, const (GLfloat)* );
    alias pglUseProgram = void function( GLuint );
    alias pglGetShaderiv = void function( GLuint, GLenum, GLint* );
    alias pglGetShaderInfoLog = void function( GLuint, GLsizei, GLsizei*, GLchar* );
    alias pglGetProgramiv = void function( GLuint, GLenum, GLint* );
    alias pglGetProgramInfoLog = void function( GLuint, GLsizei, GLsizei*, GLchar* );
    alias pglCreateShader = GLuint function( GLenum );
    alias pglCreateProgram = GLuint function(  );
    alias pglShaderSource = void function( GLuint, GLsizei, const( const( GLchar )* )*, const GLint* );
    alias pglCompileShader = void function( GLuint );
    alias pglDeleteShader = void function (GLuint);
    alias pglAttachShader = void function( GLuint, GLuint );
    alias pglLinkProgram = void function( GLuint );
    alias pglGenerateMipmap = void function( GLenum );
    alias pglBlendColor = void function (GLclampf, GLclampf, GLclampf, GLclampf);
    alias pglBlendEquation = void function (GLenum, GLenum);
    alias pglBlendFuncSeparate = void function (GLenum, GLenum, GLenum, GLenum);
    alias pglDeleteFramebuffers = void function (GLsizei, const (GLuint)*);
    alias pglDeleteProgram = void function (GLuint);
    alias pglDeleteRenderbuffers = void function (GLsizei, const(GLuint)*);
    alias pglDetachShader = void function(GLuint, GLuint);
    alias pglDisableVertexAttribArray = void function (GLuint);
    alias pglGetActiveAttrib = void function (GLuint, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLchar*);
    alias pglGetActiveUniform = void function (GLuint, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLchar*);
    alias pglGetAttachedShaders = void function (GLuint, GLsizei, GLsizei*, GLuint*);
    alias pglGetFramebufferAttachmentParameteriv = void function (GLenum, GLenum, GLenum, GLint*);
    alias pglGetRenderbufferParameteriv = void function (GLenum, GLenum, GLint*);
    alias pglGetShaderPrecisionFormat = void function (GLenum, GLenum, GLint*, GLint*);
    alias pglGetShaderSource = void function (GLuint, GLsizei, GLsizei*, GLchar*);
    alias pglGetUniformfv = void function (GLuint, GLint, GLfloat*);
    alias pglGetUniformiv = void function (GLuint, GLint, GLint*);
    alias pglGetVertexAttribfv = void function (GLuint, GLenum, GLfloat*);
    alias pglGetVertexAttribiv = void function (GLuint, GLenum, GLint*);
    alias pglGetVertexAttribPointerv = void function (GLuint, GLenum, void**);
    alias pglIsFramebuffer = void function (GLuint);
    alias pglIsProgram = void function (GLuint);
    alias pglIsRenderbuffer = void function (GLuint);
    alias pglIsShader = void function (GLuint);
    alias pglReleaseShaderCompiles = void function ();
    alias pglShaderBinary = void function (GLsizei, const (GLuint)*, GLenum, const (void)*, GLsizei);
    alias pglStencilFuncSeparate = void function (GLenum, GLenum, GLint, GLuint);
    alias pglStencilMaskSeparate = void function (GLenum, GLuint);
    alias pglStencilOpSeparate = void function (GLenum, GLenum, GLenum, GLenum);
    alias pglValidateProgram = void function (GLuint);
    alias pglVertexAttrib1f = void function (GLuint, GLfloat);
    alias pglVertexAttrib2f = void function (GLuint, GLfloat, GLfloat);
    alias pglVertexAttrib3f = void function (GLuint, GLfloat, GLfloat, GLfloat);
    alias pglVertexAttrib4f = void function (GLuint, GLfloat, GLfloat, GLfloat, GLfloat);
    alias pglVertexAttrib1fv = void function (GLuint, const(GLfloat)*);
    alias pglVertexAttrib2fv = void function (GLuint, const(GLfloat)*);
    alias pglVertexAttrib3fv = void function (GLuint, const(GLfloat)*);
    alias pglVertexAttrib4fv = void function (GLuint, const(GLfloat)*);


    //V3.2
    alias pglDrawBuffers = void function(GLsizei, const(GLenum)*);
    alias pglDeleteVertexArrays = void function(GLsizei, const(GLuint)*);
    alias pglGenVertexArrays = void function(GLsizei, GLuint*);
    alias pglBindVertexArray = void function(GLuint);
    alias pglEnableVertexAttribArray = void function(GLuint);
    alias pglVertexAttribPointer = void function(GLuint, GLint, GLenum, GLboolean, GLsizei, const(void)*);
}

__gshared {
  pglActiveTexture glActiveTexture;
  pglAlphaFunc glAlphaFunc;
  pglBindBuffer glBindBuffer;
  pglBindTexture glBindTexture;
  pglBlendFunc glBlendFunc;
  pglBufferData glBufferData;
  pglBufferSubData glBufferSubData;
  pglClear glClear;
  pglClearColor glClearColor;
  pglClearDepthf glClearDepthf;
  pglClearStencil glClearStencil;
  pglClientActiveTexture glClientActiveTexture;
  pglClipPlanef glClipPlanef;
  pglColor4f glColor4f;
  pglColor4ub glColor4ub;
  pglColor4x glColor4x;
  pglColorMask glColorMask;
  pglColorPointer glColorPointer;
  pglCompressedTexImage2D glCompressedTexImage2D;
  pglCompressedTexSubImage2D glCompressedTexSubImage2D;
  pglCopyTexImage2D glCopyTexImage2D;
  pglCopyTexSubImage2D glCopyTexSubImage2D;
  pglCullFace glCullFace;
  pglDeleteBuffers glDeleteBuffers;
  pglDeleteTextures glDeleteTextures;
  pglDepthFunc glDepthFunc;
  pglDepthMask glDepthMask;
  pglDepthRangef glDepthRangef;
  pglDepthRangex glDepthRangex;
  pglDrawArrays glDrawArrays;
  pglDrawElements glDrawElements;
  pglEnable glEnable;
  pglEnableClientState glEnableClientState;
  pglFinish glFinish;
  pglFlush glFlush;
  pglFogf glFogf;
  pglFogfv glFogfv;
  pglFogx glFogx;
  pglFogxv glFogxv;
  pglFrontFace glFrontFace;
  pglFrustumf glFrustumf;
  pglFrustumx glFrustumx;
  pglGenBuffers glGenBuffers;
  pglGenTextures glGenTextures;
  pglGetBufferParameteriv glGetBufferParameteriv;
  pglGetClipPlanex glGetClipPlanex;
  pglGetError glGetError;
  pglGetFixedv glGetFixedv;
  pglGetIntegerv glGetIntegerv;
  pglGetLightfv glGetLightfv;
  pglGetLightxv glGetLightxv;
  pglGetMaterialfv glGetMaterialfv;
  pglGetMaterialxv glGetMaterialxv;
  pglGetPointerv glGetPointerv;
  pglGetString glGetString;
  pglGetTexEnvfv glGetTexEnvfv;
  pglGetTexEnviv glGetTexEnviv;
  pglGetTexEnvxv glGetTexEnvxv;
  pglGetTexParameterfv glGetTexParameterfv;
  pglGetTexParameteriv glGetTexParameteriv;
  pglGetTexParameterxv glGetTexParameterxv;
  pglHint glHint;
  pglIsBuffer glIsBuffer;
  pglIsEnabled glIsEnabled;
  pglIsTexture glIsTexture;
  pglLightf glLightf;
  pglLightfv glLightfv;
  pglLightx glLightx;
  pglLightxv glLightxv;
  pglLightModelf glLightModelf;
  pglLightModelfv glLightModelfv;
  pglLightModelx glLightModelx;
  pglLightModelxv glLightModelxv;
  pglLineWidth glLineWidth;
  pglLineWidthx glLineWidthx;
  pglLoadIdentity glLoadIdentity;
  pglLoadMatrixf glLoadMatrixf;
  pglLoadMatrixx glLoadMatrixx;
  pglMaterialf glMaterialf;
  pglMaterialfv glMaterialfv;
  pglMaterialx glMaterialx;
  pglMaterialxv glMaterialxv;
  pglMatrixMode glMatrixMode;
  pglMultiTexCoord4f glMultiTexCoord4f;
  pglMultiTexCoord4x glMultiTexCoord4x;
  pglMultMatrixf glMultMatrixf;
  pglMultMatrixx glMultMatrixx;
  pglNormal3f glNormal3f;
  pglNormal3x glNormal3x;
  pglNormalPointer glNormalPointer;
  pglOrthof glOrthof;
  pglOrthox glOrthox;
  pglPixelStorei glPixelStorei;
  pglPointParameterf glPointParameterf;
  pglPointParameterfv glPointParameterfv;
  pglPointParameterx glPointParameterx;
  pglPointParameterxv glPointParameterxv;
  pglPointSize glPointSize;
  pglPointSizex glPointSizex;
  pglPolygonOffset glPolygonOffset;
  pglPolygonOffsetx glPolygonOffsetx;
  pglPushMatrix glPushMatrix;
  pglReadPixels glReadPixels;
  pglRotatef glRotatef;
  pglRotatex glRotatex;
  pglSampleCoverage glSampleCoverage;
  pglSampleCoveragex glSampleCoveragex;
  pglScalex glScalex;
  pglScissor glScissor;
  pglShadeModel glShadeModel;
  pglStencilFunc glStencilFunc;
  pglStencilMask glStencilMask;
  pglStencilOp glStencilOp;
  pglTexCoordPointer glTexCoordPointer;
  pglTexEnvi glTexEnvi;
  pglTexEnvx glTexEnvx;
  pglTexEnviv glTexEnviv;
  pglTexEnvxv glTexEnvxv;
  pglTexImage2D glTexImage2D;
  pglTexParameteri glTexParameteri;
  pglTexParameterx glTexParameterx;
  pglTexParameteriv glTexParameteriv;
  pglTexParameterxv glTexParameterxv;
  pglTexSubImage2D glTexSubImage2D;
  pglTranslatex glTranslatex;
  pglVertexPointer glVertexPointer;
  pglViewport glViewport;


  //V2.0
  pglDisable glDisable;
  pglBindAttribLocation glBindAttribLocation;
  pglGetAttribLocation glGetAttribLocation;
  pglBindFramebuffer glBindFramebuffer;
  pglBindRenderbuffer glBindRenderbuffer;
  pglGenFramebuffers glGenFramebuffers;
  pglGenRenderbuffers glGenRenderbuffers;
  pglRenderbufferStorage glRenderbufferStorage;
  pglFramebufferRenderbuffer glFramebufferRenderbuffer;
  pglFramebufferTexture2D glFramebufferTexture2D;
  pglCheckFramebufferStatus glCheckFramebufferStatus;
  pglGetUniformLocation glGetUniformLocation;
  pglUniform1f glUniform1f;
  pglUniform1i glUniform1i;
  pglUniform2f glUniform2f;
  pglUniform2i glUniform2i;
  pglUniform3f glUniform3f;
  pglUniform3i glUniform3i;
  pglUniform4f glUniform4f;
  pglUniform4i glUniform4i;
  pglUniform1fv glUniform1fv;
  pglUniform1iv glUniform1iv;
  pglUniform2fv glUniform2fv;
  pglUniform2iv glUniform2iv;
  pglUniform3fv glUniform3fv;
  pglUniform3iv glUniform3iv;
  pglUniform4fv glUniform4fv;
  pglUniform4iv glUniform4iv;
  pglUniformMatrix2fv glUniformMatrix2fv;
  pglUniformMatrix3fv glUniformMatrix3fv;
  pglUniformMatrix4fv glUniformMatrix4fv;
  pglUseProgram glUseProgram;
  pglGetShaderiv glGetShaderiv;
  pglGetShaderInfoLog glGetShaderInfoLog;
  pglGetProgramiv glGetProgramiv;
  pglGetProgramInfoLog glGetProgramInfoLog;
  pglCreateShader glCreateShader;
  pglCreateProgram glCreateProgram;
  pglShaderSource glShaderSource;
  pglCompileShader glCompileShader;
  pglDeleteShader glDeleteShader;
  pglAttachShader glAttachShader;
  pglLinkProgram glLinkProgram;
  pglGenerateMipmap glGenerateMipmap;
  pglBlendColor glBlendColor;
  pglBlendEquation glBlendEquation;
  pglBlendFuncSeparate glBlendFuncSeparate;
  pglDeleteFramebuffers glDeleteFramebuffers;
  pglDeleteProgram glDeleteProgram;
  pglDeleteRenderbuffers glDeleteRenderbuffers;
  pglDetachShader glDetachShader;
  pglDisableVertexAttribArray glDisableVertexAttribArray;
  pglGetActiveAttrib glGetActiveAttrib;
  pglGetActiveUniform glGetActiveUniform;
  pglGetAttachedShaders glGetAttachedShaders;
  pglGetFramebufferAttachmentParameteriv glGetFramebufferAttachmentParameteriv;
  pglGetRenderbufferParameteriv glGetRenderbufferParameteriv;
  pglGetShaderPrecisionFormat glGetShaderPrecisionFormat;
  pglGetShaderSource glGetShaderSource;
  pglGetUniformfv glGetUniformfv;
  pglGetUniformiv glGetUniformiv;
  pglGetVertexAttribfv glGetVertexAttribfv;
  pglGetVertexAttribiv glGetVertexAttribiv;
  pglGetVertexAttribPointerv glGetVertexAttribPointerv;
  pglIsFramebuffer glIsFramebuffer;
  pglIsProgram glIsProgram;
  pglIsRenderbuffer glIsRenderbuffer;
  pglIsShader glIsShader;
  pglReleaseShaderCompiles glReleaseShaderCompiles;
  pglShaderBinary glShaderBinary;
  pglStencilFuncSeparate glStencilFuncSeparate;
  pglStencilMaskSeparate glStencilMaskSeparate;
  pglStencilOpSeparate glStencilOpSeparate;
  pglValidateProgram glValidateProgram;
  pglVertexAttrib1f glVertexAttrib1f;
  pglVertexAttrib2f glVertexAttrib2f;
  pglVertexAttrib3f glVertexAttrib3f;
  pglVertexAttrib4f glVertexAttrib4f;
  pglVertexAttrib1fv glVertexAttrib1fv;
  pglVertexAttrib2fv glVertexAttrib2fv;
  pglVertexAttrib3fv glVertexAttrib3fv;
  pglVertexAttrib4fv glVertexAttrib4fv;
  
  //V3.2
  pglDrawBuffers glDrawBuffers;
  pglDeleteVertexArrays glDeleteVertexArrays;
  pglGenVertexArrays glGenVertexArrays;
  pglBindVertexArray glBindVertexArray;
  pglEnableVertexAttribArray glEnableVertexAttribArray;
  pglVertexAttribPointer glVertexAttribPointer;
}

bool loadGLES(SharedLib lib){
    bool hasV10Plus, hasV10Only, hasV20, hasV32;

    auto startErrorCount = errorCount();
    //V1.0 and later
    lib.bindSymbol( cast( void** )&glActiveTexture, "glActiveTexture" );
    lib.bindSymbol( cast( void** )&glBindBuffer, "glBindBuffer" );
    lib.bindSymbol( cast( void** )&glBindTexture, "glBindTexture" );
    lib.bindSymbol( cast( void** )&glBlendFunc, "glBlendFunc" );
    lib.bindSymbol( cast( void** )&glBufferData, "glBufferData" );
    lib.bindSymbol( cast( void** )&glBufferSubData, "glBufferSubData" );
    lib.bindSymbol( cast( void** )&glClear, "glClear" );
    lib.bindSymbol( cast( void** )&glClearColor, "glClearColor" );
    lib.bindSymbol( cast( void** )&glClearDepthf, "glClearDepthf" );
    lib.bindSymbol( cast( void** )&glClearStencil, "glClearStencil" );
    lib.bindSymbol( cast( void** )&glColorMask, "glColorMask" );
    lib.bindSymbol( cast( void** )&glCompressedTexImage2D, "glCompressedTexImage2D" );
    lib.bindSymbol( cast( void** )&glCompressedTexSubImage2D, "glCompressedTexSubImage2D" );
    lib.bindSymbol( cast( void** )&glCopyTexImage2D, "glCopyTexImage2D" );
    lib.bindSymbol( cast( void** )&glCopyTexSubImage2D, "glCopyTexSubImage2D" );
    lib.bindSymbol( cast( void** )&glCullFace, "glCullFace" );
    lib.bindSymbol( cast( void** )&glDeleteBuffers, "glDeleteBuffers" );
    lib.bindSymbol( cast( void** )&glDeleteTextures, "glDeleteTextures" );
    lib.bindSymbol( cast( void** )&glDepthFunc, "glDepthFunc" );
    lib.bindSymbol( cast( void** )&glDepthMask, "glDepthMask" );
    lib.bindSymbol( cast( void** )&glDepthRangef, "glDepthRangef" );
    lib.bindSymbol( cast( void** )&glDrawArrays, "glDrawArrays" );
    lib.bindSymbol( cast( void** )&glDrawElements, "glDrawElements" );
    lib.bindSymbol( cast( void** )&glEnable, "glEnable" );
    lib.bindSymbol( cast( void** )&glFinish, "glFinish" );
    lib.bindSymbol( cast( void** )&glFlush, "glFlush" );
    lib.bindSymbol( cast( void** )&glFrontFace, "glFrontFace" );
    lib.bindSymbol( cast( void** )&glGenBuffers, "glGenBuffers" );
    lib.bindSymbol( cast( void** )&glGenTextures, "glGenTextures" );
    lib.bindSymbol( cast( void** )&glGetBufferParameteriv, "glGetBufferParameteriv" );
    lib.bindSymbol( cast( void** )&glGetError, "glGetError" );
    lib.bindSymbol( cast( void** )&glGetIntegerv, "glGetIntegerv" );
    lib.bindSymbol( cast( void** )&glGetPointerv, "glGetPointerv" );
    lib.bindSymbol( cast( void** )&glGetString, "glGetString" );
    lib.bindSymbol( cast( void** )&glGetTexParameterfv, "glGetTexParameterfv" );
    lib.bindSymbol( cast( void** )&glGetTexParameteriv, "glGetTexParameteriv" );
    lib.bindSymbol( cast( void** )&glHint, "glHint" );
    lib.bindSymbol( cast( void** )&glIsBuffer, "glIsBuffer" );
    lib.bindSymbol( cast( void** )&glIsEnabled, "glIsEnabled" );
    lib.bindSymbol( cast( void** )&glIsTexture, "glIsTexture" );
    lib.bindSymbol( cast( void** )&glLineWidth, "glLineWidth" );
    lib.bindSymbol( cast( void** )&glPixelStorei, "glPixelStorei" );
    lib.bindSymbol( cast( void** )&glPolygonOffset, "glPolygonOffset" );
    lib.bindSymbol( cast( void** )&glReadPixels, "glReadPixels" );
    lib.bindSymbol( cast( void** )&glSampleCoverage, "glSampleCoverage" );
    lib.bindSymbol( cast( void** )&glScissor, "glScissor" );
    lib.bindSymbol( cast( void** )&glStencilFunc, "glStencilFunc" );
    lib.bindSymbol( cast( void** )&glStencilMask, "glStencilMask" );
    lib.bindSymbol( cast( void** )&glStencilOp, "glStencilOp" );
    lib.bindSymbol( cast( void** )&glTexImage2D, "glTexImage2D" );
    lib.bindSymbol( cast( void** )&glTexParameteri, "glTexParameteri" );
    lib.bindSymbol( cast( void** )&glTexParameteriv, "glTexParameteriv" );
    lib.bindSymbol( cast( void** )&glTexSubImage2D, "glTexSubImage2D" );
    lib.bindSymbol( cast( void** )&glViewport, "glViewport" );
    hasV10Plus = (startErrorCount == errorCount());
    startErrorCount = errorCount();
    //loadedVersion = GLESSupport.GLES10;
    
    //V1.0 only
    lib.bindSymbol( cast( void** )&glAlphaFunc, "glAlphaFunc" );
    lib.bindSymbol( cast( void** )&glClientActiveTexture, "glClientActiveTexture" );
    lib.bindSymbol( cast( void** )&glClipPlanef, "glClipPlanef" );
    lib.bindSymbol( cast( void** )&glColor4f, "glColor4f" );
    lib.bindSymbol( cast( void** )&glColor4ub, "glColor4ub" );
    lib.bindSymbol( cast( void** )&glColor4x, "glColor4x" );
    lib.bindSymbol( cast( void** )&glColorPointer, "glColorPointer" );
    lib.bindSymbol( cast( void** )&glDepthRangex, "glDepthRangex" );
    lib.bindSymbol( cast( void** )&glEnableClientState, "glEnableClientState" );
    lib.bindSymbol( cast( void** )&glFogf, "glFogf" );
    lib.bindSymbol( cast( void** )&glFogfv, "glFogfv" );
    lib.bindSymbol( cast( void** )&glFogx, "glFogx" );
    lib.bindSymbol( cast( void** )&glFogxv, "glFogxv" );
    lib.bindSymbol( cast( void** )&glFrustumf, "glFrustumf" );
    lib.bindSymbol( cast( void** )&glFrustumx, "glFrustumx" );
    lib.bindSymbol( cast( void** )&glGetClipPlanex, "glGetClipPlanex" );
    lib.bindSymbol( cast( void** )&glGetFixedv, "glGetFixedv" );
    lib.bindSymbol( cast( void** )&glGetLightfv, "glGetLightfv" );
    lib.bindSymbol( cast( void** )&glGetLightxv, "glGetLightxv" );
    lib.bindSymbol( cast( void** )&glGetMaterialfv, "glGetMaterialfv" );
    lib.bindSymbol( cast( void** )&glGetMaterialxv, "glGetMaterialxv" );
    lib.bindSymbol( cast( void** )&glGetTexEnvfv, "glGetTexEnvfv" );
    lib.bindSymbol( cast( void** )&glGetTexEnviv, "glGetTexEnviv" );
    lib.bindSymbol( cast( void** )&glGetTexEnvxv, "glGetTexEnvxv" );
    lib.bindSymbol( cast( void** )&glGetTexParameterxv, "glGetTexParameterxv" );
    lib.bindSymbol( cast( void** )&glLightf, "glLightf" );
    lib.bindSymbol( cast( void** )&glLightfv, "glLightfv" );
    lib.bindSymbol( cast( void** )&glLightx, "glLightx" );
    lib.bindSymbol( cast( void** )&glLightxv, "glLightxv" );
    lib.bindSymbol( cast( void** )&glLightModelf, "glLightModelf" );
    lib.bindSymbol( cast( void** )&glLightModelfv, "glLightModelfv" );
    lib.bindSymbol( cast( void** )&glLightModelx, "glLightModelx" );
    lib.bindSymbol( cast( void** )&glLightModelxv, "glLightModelxv" );
    lib.bindSymbol( cast( void** )&glLineWidthx, "glLineWidthx" );
    lib.bindSymbol( cast( void** )&glLoadIdentity, "glLoadIdentity" );
    lib.bindSymbol( cast( void** )&glLoadMatrixf, "glLoadMatrixf" );
    lib.bindSymbol( cast( void** )&glLoadMatrixx, "glLoadMatrixx" );
    lib.bindSymbol( cast( void** )&glMaterialf, "glMaterialf" );
    lib.bindSymbol( cast( void** )&glMaterialfv, "glMaterialfv" );
    lib.bindSymbol( cast( void** )&glMaterialx, "glMaterialx" );
    lib.bindSymbol( cast( void** )&glMaterialxv, "glMaterialxv" );
    lib.bindSymbol( cast( void** )&glMatrixMode, "glMatrixMode" );
    lib.bindSymbol( cast( void** )&glMultiTexCoord4f, "glMultiTexCoord4f" );
    lib.bindSymbol( cast( void** )&glMultiTexCoord4x, "glMultiTexCoord4x" );
    lib.bindSymbol( cast( void** )&glMultMatrixf, "glMultMatrixf" );
    lib.bindSymbol( cast( void** )&glMultMatrixx, "glMultMatrixx" );
    lib.bindSymbol( cast( void** )&glNormal3f, "glNormal3f" );
    lib.bindSymbol( cast( void** )&glNormal3x, "glNormal3x" );
    lib.bindSymbol( cast( void** )&glNormalPointer, "glNormalPointer" );
    lib.bindSymbol( cast( void** )&glOrthof, "glOrthof" );
    lib.bindSymbol( cast( void** )&glOrthox, "glOrthox" );
    lib.bindSymbol( cast( void** )&glPointParameterf, "glPointParameterf" );
    lib.bindSymbol( cast( void** )&glPointParameterfv, "glPointParameterfv" );
    lib.bindSymbol( cast( void** )&glPointParameterx, "glPointParameterx" );
    lib.bindSymbol( cast( void** )&glPointParameterxv, "glPointParameterxv" );
    lib.bindSymbol( cast( void** )&glPointSize, "glPointSize" );
    lib.bindSymbol( cast( void** )&glPointSizex, "glPointSizex" );
    lib.bindSymbol( cast( void** )&glPolygonOffsetx, "glPolygonOffsetx" );
    lib.bindSymbol( cast( void** )&glPushMatrix, "glPushMatrix" );
    lib.bindSymbol( cast( void** )&glRotatef, "glRotatef" );
    lib.bindSymbol( cast( void** )&glRotatex, "glRotatex" );
    lib.bindSymbol( cast( void** )&glSampleCoveragex, "glSampleCoveragex" );
    lib.bindSymbol( cast( void** )&glScalex, "glScalex" );
    lib.bindSymbol( cast( void** )&glShadeModel, "glShadeModel" );
    lib.bindSymbol( cast( void** )&glTexCoordPointer, "glTexCoordPointer" );
    lib.bindSymbol( cast( void** )&glTexEnvi, "glTexEnvi" );
    lib.bindSymbol( cast( void** )&glTexEnvx, "glTexEnvx" );
    lib.bindSymbol( cast( void** )&glTexEnviv, "glTexEnviv" );
    lib.bindSymbol( cast( void** )&glTexEnvxv, "glTexEnvxv" );
    lib.bindSymbol( cast( void** )&glTexParameterx, "glTexParameterx" );
    lib.bindSymbol( cast( void** )&glTexParameterxv, "glTexParameterxv" );
    lib.bindSymbol( cast( void** )&glTranslatex, "glTranslatex" );
    lib.bindSymbol( cast( void** )&glVertexPointer, "glVertexPointer" );
    hasV10Only = (startErrorCount == errorCount());
    startErrorCount = errorCount();
    
    //V2.0
    lib.bindSymbol( cast( void** )&glDisable, "glDisable" );
    lib.bindSymbol( cast( void** )&glBindAttribLocation, "glBindAttribLocation" );
    lib.bindSymbol( cast( void** )&glGetAttribLocation, "glGetAttribLocation" );
    lib.bindSymbol( cast( void** )&glBindFramebuffer, "glBindFramebuffer" );
    lib.bindSymbol( cast( void** )&glBindRenderbuffer, "glBindRenderbuffer" );
    lib.bindSymbol( cast( void** )&glGenFramebuffers, "glGenFramebuffers" );
    lib.bindSymbol( cast( void** )&glGenRenderbuffers, "glGenRenderbuffers" );
    lib.bindSymbol( cast( void** )&glRenderbufferStorage, "glRenderbufferStorage" );
    lib.bindSymbol( cast( void** )&glFramebufferRenderbuffer, "glFramebufferRenderbuffer" );
    lib.bindSymbol( cast( void** )&glFramebufferTexture2D, "glFramebufferTexture2D" );
    lib.bindSymbol( cast( void** )&glCheckFramebufferStatus, "glCheckFramebufferStatus" );
    lib.bindSymbol( cast( void** )&glGetUniformLocation, "glGetUniformLocation" );
    lib.bindSymbol( cast( void** )&glUniform1f, "glUniform1f" );
    lib.bindSymbol( cast( void** )&glUniform1i, "glUniform1i" );
    lib.bindSymbol( cast( void** )&glUniform2f, "glUniform2f" );
    lib.bindSymbol( cast( void** )&glUniform2i, "glUniform2i" );
    lib.bindSymbol( cast( void** )&glUniform3f, "glUniform3f" );
    lib.bindSymbol( cast( void** )&glUniform3i, "glUniform3i" );
    lib.bindSymbol( cast( void** )&glUniform4f, "glUniform4f" );
    lib.bindSymbol( cast( void** )&glUniform4i, "glUniform4i" );
    lib.bindSymbol( cast( void** )&glUniform1fv, "glUniform1fv" );
    lib.bindSymbol( cast( void** )&glUniform1iv, "glUniform1iv" );
    lib.bindSymbol( cast( void** )&glUniform2fv, "glUniform2fv" );
    lib.bindSymbol( cast( void** )&glUniform2iv, "glUniform2iv" );
    lib.bindSymbol( cast( void** )&glUniform3fv, "glUniform3fv" );
    lib.bindSymbol( cast( void** )&glUniform3iv, "glUniform3iv" );
    lib.bindSymbol( cast( void** )&glUniform4fv, "glUniform4fv" );
    lib.bindSymbol( cast( void** )&glUniform4iv, "glUniform4iv" );
    lib.bindSymbol( cast( void** )&glUniformMatrix2fv, "glUniformMatrix2fv" );
    lib.bindSymbol( cast( void** )&glUniformMatrix3fv, "glUniformMatrix3fv" );
    lib.bindSymbol( cast( void** )&glUniformMatrix4fv, "glUniformMatrix4fv" );
    lib.bindSymbol( cast( void** )&glUseProgram, "glUseProgram" );
    lib.bindSymbol( cast( void** )&glGetShaderiv, "glGetShaderiv" );
    lib.bindSymbol( cast( void** )&glGetShaderInfoLog, "glGetShaderInfoLog" );
    lib.bindSymbol( cast( void** )&glGetProgramiv, "glGetProgramiv" );
    lib.bindSymbol( cast( void** )&glGetProgramInfoLog, "glGetProgramInfoLog" );
    lib.bindSymbol( cast( void** )&glCreateShader, "glCreateShader" );
    lib.bindSymbol( cast( void** )&glCreateProgram, "glCreateProgram" );
    lib.bindSymbol( cast( void** )&glShaderSource, "glShaderSource" );
    lib.bindSymbol( cast( void** )&glCompileShader, "glCompileShader" );
    lib.bindSymbol( cast( void** )&glDeleteShader, "glDeleteShader" );
    lib.bindSymbol( cast( void** )&glAttachShader, "glAttachShader" );
    lib.bindSymbol( cast( void** )&glLinkProgram, "glLinkProgram" );
    lib.bindSymbol( cast( void** )&glGenerateMipmap, "glGenerateMipmap" );
    lib.bindSymbol( cast( void** )&glBlendColor, "glBlendColor" );
    lib.bindSymbol( cast( void** )&glBlendEquation, "glBlendEquation" );
    lib.bindSymbol( cast( void** )&glBlendFuncSeparate, "glBlendFuncSeparate" );
    lib.bindSymbol( cast( void** )&glDeleteFramebuffers, "glDeleteFramebuffers" );
    lib.bindSymbol( cast( void** )&glDeleteProgram, "glDeleteProgram" );
    lib.bindSymbol( cast( void** )&glDeleteRenderbuffers, "glDeleteRenderbuffers" );
    lib.bindSymbol( cast( void** )&glDetachShader, "glDetachShader" );
    lib.bindSymbol( cast( void** )&glDisableVertexAttribArray, "glDisableVertexAttribArray" );
    lib.bindSymbol( cast( void** )&glGetActiveAttrib, "glGetActiveAttrib" );
    lib.bindSymbol( cast( void** )&glGetActiveUniform, "glGetActiveUniform" );
    lib.bindSymbol( cast( void** )&glGetAttachedShaders, "glGetAttachedShaders" );
    lib.bindSymbol( cast( void** )&glGetFramebufferAttachmentParameteriv, "glGetFramebufferAttachmentParameteriv" );
    lib.bindSymbol( cast( void** )&glGetRenderbufferParameteriv, "glGetRenderbufferParameteriv" );
    lib.bindSymbol( cast( void** )&glGetShaderPrecisionFormat, "glGetShaderPrecisionFormat" );
    lib.bindSymbol( cast( void** )&glGetShaderSource, "glGetShaderSource" );
    lib.bindSymbol( cast( void** )&glGetUniformfv, "glGetUniformfv" );
    lib.bindSymbol( cast( void** )&glGetUniformiv, "glGetUniformiv" );
    lib.bindSymbol( cast( void** )&glGetVertexAttribfv, "glGetVertexAttribfv" );
    lib.bindSymbol( cast( void** )&glGetVertexAttribiv, "glGetVertexAttribiv" );
    lib.bindSymbol( cast( void** )&glGetVertexAttribPointerv, "glGetVertexAttribPointerv" );
    lib.bindSymbol( cast( void** )&glIsFramebuffer, "glIsFramebuffer" );
    lib.bindSymbol( cast( void** )&glIsProgram, "glIsProgram" );
    lib.bindSymbol( cast( void** )&glIsRenderbuffer, "glIsRenderbuffer" );
    lib.bindSymbol( cast( void** )&glIsShader, "glIsShader" );
    lib.bindSymbol( cast( void** )&glReleaseShaderCompiles, "glReleaseShaderCompiles" );
    lib.bindSymbol( cast( void** )&glShaderBinary, "glShaderBinary" );
    lib.bindSymbol( cast( void** )&glStencilFuncSeparate, "glStencilFuncSeparate" );
    lib.bindSymbol( cast( void** )&glStencilMaskSeparate, "glStencilMaskSeparate" );
    lib.bindSymbol( cast( void** )&glStencilOpSeparate, "glStencilOpSeparate" );
    lib.bindSymbol( cast( void** )&glValidateProgram, "glValidateProgram" );
    lib.bindSymbol( cast( void** )&glVertexAttrib1f, "glVertexAttrib1f" );
    lib.bindSymbol( cast( void** )&glVertexAttrib2f, "glVertexAttrib2f" );
    lib.bindSymbol( cast( void** )&glVertexAttrib3f, "glVertexAttrib3f" );
    lib.bindSymbol( cast( void** )&glVertexAttrib4f, "glVertexAttrib4f" );
    lib.bindSymbol( cast( void** )&glVertexAttrib1fv, "glVertexAttrib1fv" );
    lib.bindSymbol( cast( void** )&glVertexAttrib2fv, "glVertexAttrib2fv" );
    lib.bindSymbol( cast( void** )&glVertexAttrib3fv, "glVertexAttrib3fv" );
    lib.bindSymbol( cast( void** )&glVertexAttrib4fv, "glVertexAttrib4fv" );
    hasV20 = (startErrorCount == errorCount());
    startErrorCount = errorCount();
  
    //V3.2
    lib.bindSymbol( cast( void** )&glDrawBuffers, "glDrawBuffers" );
    lib.bindSymbol( cast( void** )&glDeleteVertexArrays, "glDeleteVertexArrays" );
    lib.bindSymbol( cast( void** )&glGenVertexArrays, "glGenVertexArrays" );
    lib.bindSymbol( cast( void** )&glBindVertexArray, "glBindVertexArray" );
    lib.bindSymbol( cast( void** )&glEnableVertexAttribArray, "glEnableVertexAttribArray" );
    lib.bindSymbol( cast( void** )&glVertexAttribPointer, "glVertexAttribPointer" );
    hasV32 = (startErrorCount == errorCount());
    
    if (hasV32)
        loadedVersion = GLESSupport.GLES32;
    else if (hasV20)
        loadedVersion = GLESSupport.GLES20;
    else if (hasV10Only)
        loadedVersion = GLESSupport.GLES10;
    
    return(hasV10Plus && (hasV10Only || hasV20));
}


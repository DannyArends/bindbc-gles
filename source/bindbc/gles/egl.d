// Copyright Danny Arends 2020.
// Distributed under the Boost Software License, Version 1.0.
// (See: http://www.boost.org/LICENSE_1_0.txt)

module bindbc.gles.egl;

import bindbc.loader;
public import bindbc.gles.config,
              bindbc.gles.egltypes;

enum EGLNativeDisplayType EGL_DEFAULT_DISPLAY = cast(EGLNativeDisplayType)0;
enum EGLContext EGL_NO_CONTEXT = null;
enum EGLDisplay EGL_NO_DISPLAY = null;
struct ANativeWindow;
struct egl_native_pixmap_t;

alias EGLNativeWindowType = ANativeWindow*;
alias EGLNativePixmapType = egl_native_pixmap_t*;
alias EGLNativeDisplayType = void*;

private {
    SharedLib lib;
    EGLSupport contextVersion = EGLSupport.noContext;
    EGLSupport loadedVersion = EGLSupport.noContext;
    EGLint major;
    EGLint minor;
}

@nogc nothrow:

void unloadEGL()
{
    if(lib != invalidHandle) {
        lib.unload();
        contextVersion = loadedVersion = EGLSupport.noContext;
    }
}

EGLSupport loadEGL()
{
    version(Windows) {
        const(char)[][1] libNames = ["libegl.dll"];
    }
    else version(Posix) {
        const(char)[][2] libNames = [
            "libEGL.so.1",
            "libEGL.so"
        ];
    }
    else static assert(0, "bindbc-gles is not yet supported on this platform");

    EGLSupport ret;
    foreach(name; libNames) {
        ret = loadEGL(name.ptr);
        if(ret != EGLSupport.noLibrary) break;
    }
    return ret;
}

EGLSupport loadEGL(const(char)* libName)
{
    // If the library isn't yet loaded, load it now.
    if(lib == invalidHandle) {
        lib = load(libName);
        if(lib == invalidHandle) {
            return EGLSupport.noLibrary;
        }
    }
    if(!lib.loadEGL()) return EGLSupport.badLibrary;
    return loadedVersion;
}

extern(System) @nogc nothrow {
    // V1.0
    alias peglGetError = void function(  );
    alias peglGetDisplay = EGLDisplay function( EGLNativeDisplayType );
    alias peglInitialize = EGLBoolean function( EGLDisplay, EGLint*, EGLint* );
    alias peglTerminate = EGLBoolean function( EGLDisplay );
    alias peglQueryString = const( char )* function( EGLDisplay, EGLint );
    alias peglGetConfigs = EGLBoolean function( EGLDisplay, EGLConfig*, EGLint, EGLint* );
    alias peglChooseConfig = EGLBoolean function( EGLDisplay, const( EGLint )*, EGLConfig*, EGLint, EGLint* );
    alias peglGetConfigAttrib = EGLBoolean function( EGLDisplay, EGLConfig, EGLint, EGLint* );
    alias peglCreateWindowSurface = EGLSurface function( EGLDisplay, EGLConfig, EGLNativeWindowType, const( EGLint )* );
    alias peglCreatePbufferSurface = EGLSurface function( EGLDisplay, EGLConfig, const( EGLint )* );
    alias peglCreatePixmapSurface = EGLSurface function( EGLDisplay, EGLConfig, EGLNativePixmapType, const( EGLint )* );
    alias peglDestroySurface = EGLBoolean function( EGLDisplay, EGLSurface );
    alias peglQuerySurface = EGLBoolean function( EGLDisplay, EGLSurface, EGLint, EGLint* );
    alias peglCreateContext = EGLContext function( EGLDisplay, EGLConfig, EGLContext, const( EGLint )* );
    alias peglDestroyContext = EGLBoolean function( EGLDisplay, EGLContext );
    alias peglMakeCurrent = EGLBoolean function( EGLDisplay, EGLSurface, EGLSurface, EGLContext );
    alias peglGetCurrentSurface = EGLSurface function( EGLint );
    alias peglGetCurrentDisplay = EGLDisplay function(  );
    alias peglQueryContext = EGLBoolean function( EGLDisplay, EGLContext, EGLint, EGLint* );
    alias peglWaitGL = EGLBoolean function(  );
    alias peglWaitNative = EGLBoolean function( EGLint );
    alias peglSwapBuffers = EGLBoolean function( EGLDisplay, EGLSurface );
    alias peglCopyBuffers = EGLBoolean function( EGLDisplay, EGLSurface, EGLNativePixmapType );
    /* This is a generic function pointer type, whose name indicates it must be cast to the proper type *and calling convention* before use. */
    alias __eglMustCastToProperFunctionPointerType = void function(  );
    /* Now, define eglGetProcAddress using the generic function ptr. type */
    alias peglGetProcAddress = __eglMustCastToProperFunctionPointerType function( const( char )* );

    //V1.1
    alias peglSurfaceAttrib = EGLBoolean function( EGLDisplay, EGLSurface, EGLint, EGLint );
    alias peglBindTexImage = EGLBoolean function( EGLDisplay, EGLSurface, EGLint );
    alias peglReleaseTexImage = EGLBoolean function( EGLDisplay, EGLSurface, EGLint );
    alias peglSwapInterval = EGLBoolean function( EGLDisplay, EGLint );

    //V1.2
    alias peglBindAPI = EGLBoolean function( EGLenum );
    alias peglQueryAPI = EGLenum function(  );
    alias peglWaitClient = EGLBoolean function(  );
    alias peglReleaseThread = EGLBoolean function(  );
    alias peglCreatePbufferFromClientBuffer = EGLSurface function( EGLDisplay, EGLenum, EGLClientBuffer, EGLConfig, const( EGLint )* );
    
    //V1.4
    alias peglGetCurrentContext = EGLContext function(  );
    
    //V1.5
    alias peglCreateSync = EGLSync function ( EGLDisplay, EGLenum, const( EGLAttrib )* );
    alias peglDestroySync = EGLBoolean function ( EGLDisplay, EGLSync );
    alias peglClientWaitSync = EGLint function ( EGLDisplay, EGLSync, EGLint, EGLTime );
    alias peglGetSyncAttrib = EGLBoolean function ( EGLDisplay, EGLSync, EGLint, EGLAttrib* );
    alias peglGetPlatformDisplay = EGLDisplay function ( EGLenum, void*, const( EGLAttrib )* );
    alias peglCreatePlatformWindowSurface = EGLSurface function ( EGLDisplay, EGLConfig, void*, const( EGLAttrib )* );
    alias peglCreatePlatformPixmapSurface = EGLSurface function ( EGLDisplay, EGLConfig, void*, const( EGLAttrib )* );
    alias peglWaitSync = EGLBoolean function ( EGLDisplay, EGLSync, EGLint );
}

__gshared {
    peglGetError eglGetError;
    peglGetDisplay eglGetDisplay;
    peglInitialize eglInitialize;
    peglTerminate eglTerminate;
    
    peglQueryString eglQueryString;
    peglGetConfigs eglGetConfigs;
    peglChooseConfig eglChooseConfig;
    peglGetConfigAttrib eglGetConfigAttrib;
    peglCreateWindowSurface eglCreateWindowSurface;
    peglCreatePbufferSurface eglCreatePbufferSurface;
    peglCreatePixmapSurface eglCreatePixmapSurface;
    peglDestroySurface eglDestroySurface;
    peglQuerySurface eglQuerySurface;
    peglCreateContext eglCreateContext;
    peglDestroyContext eglDestroyContext;
    peglMakeCurrent eglMakeCurrent;
    peglGetCurrentSurface eglGetCurrentSurface;
    peglGetCurrentDisplay eglGetCurrentDisplay;
    peglQueryContext eglQueryContext;
    peglWaitGL eglWaitGL;
    peglWaitNative eglWaitNative;
    peglSwapBuffers eglSwapBuffers;
    peglCopyBuffers eglCopyBuffers;
    peglGetProcAddress eglGetProcAddress;
    
    peglSurfaceAttrib eglSurfaceAttrib;
    peglBindTexImage eglBindTexImage;
    peglReleaseTexImage eglReleaseTexImage;
    peglSwapInterval eglSwapInterval;

    peglBindAPI eglBindAPI;
    peglQueryAPI eglQueryAPI;
    peglWaitClient eglWaitClient;
    peglReleaseThread eglReleaseThread;
    peglCreatePbufferFromClientBuffer eglCreatePbufferFromClientBuffer;

    peglGetCurrentContext eglGetCurrentContext;
    
    peglCreateSync eglCreateSync;
    peglDestroySync eglDestroySync;
    peglClientWaitSync eglClientWaitSync;
    peglGetSyncAttrib eglGetSyncAttrib;
    peglGetPlatformDisplay eglGetPlatformDisplay;
    peglCreatePlatformWindowSurface eglCreatePlatformWindowSurface;
    peglCreatePlatformPixmapSurface eglCreatePlatformPixmapSurface;
    peglWaitSync eglWaitSync;
}

package(bindbc.gles) @nogc nothrow
bool loadEGL(SharedLib lib){
    auto startErrorCount = errorCount();
    lib.bindSymbol( cast( void** )&eglGetError, "eglGetError" );
    lib.bindSymbol( cast( void** )&eglGetDisplay, "eglGetDisplay" );
    lib.bindSymbol( cast( void** )&eglInitialize, "eglInitialize" );
    lib.bindSymbol( cast( void** )&eglTerminate, "eglTerminate" );
    
    EGLDisplay disp = eglGetDisplay( EGL_DEFAULT_DISPLAY );
    if( disp == EGL_NO_DISPLAY ) {
        assert(0, "Unable to get a display for EGL");
    }

    if( eglInitialize( disp, &major, &minor ) == EGL_FALSE ) {
      //assert( "Failed to initialize the EGL display: " ~ to!string( eglGetError(  ) ) );
    }
    if( major != 1 ) {
      eglTerminate( disp );
      //assert( "The EGL version is not recognized: " ~ to!string( eglGetError(  ) ) );
    }

    if( minor >= 0 ) {
        lib.bindSymbol( cast( void** )&eglQueryString, "eglQueryString" );
        lib.bindSymbol( cast( void** )&eglGetConfigs, "eglGetConfigs" );
        lib.bindSymbol( cast( void** )&eglChooseConfig, "eglChooseConfig" );
        lib.bindSymbol( cast( void** )&eglGetConfigAttrib, "eglGetConfigAttrib" );
        lib.bindSymbol( cast( void** )&eglCreateWindowSurface, "eglCreateWindowSurface" );
        lib.bindSymbol( cast( void** )&eglCreatePbufferSurface, "eglCreatePbufferSurface" );
        lib.bindSymbol( cast( void** )&eglCreatePixmapSurface, "eglCreatePixmapSurface" );
        lib.bindSymbol( cast( void** )&eglDestroySurface, "eglDestroySurface" );
        lib.bindSymbol( cast( void** )&eglQuerySurface, "eglQuerySurface" );
        lib.bindSymbol( cast( void** )&eglCreateContext, "eglCreateContext" );
        lib.bindSymbol( cast( void** )&eglDestroyContext, "eglDestroyContext" );
        lib.bindSymbol( cast( void** )&eglMakeCurrent, "eglMakeCurrent" );
        lib.bindSymbol( cast( void** )&eglGetCurrentSurface, "eglGetCurrentSurface" );
        lib.bindSymbol( cast( void** )&eglGetCurrentDisplay, "eglGetCurrentDisplay" );
        lib.bindSymbol( cast( void** )&eglQueryContext, "eglQueryContext" );
        lib.bindSymbol( cast( void** )&eglWaitGL, "eglWaitGL" );
        lib.bindSymbol( cast( void** )&eglWaitNative, "eglWaitNative" );
        lib.bindSymbol( cast( void** )&eglSwapBuffers, "eglSwapBuffers" );
        lib.bindSymbol( cast( void** )&eglCopyBuffers, "eglCopyBuffers" );
        lib.bindSymbol( cast( void** )&eglGetProcAddress, "eglGetProcAddress" );
        loadedVersion = EGLSupport.EGL10;
    }
    if( minor >= 1 ) {
        lib.bindSymbol( cast( void** )&eglSurfaceAttrib, "eglSurfaceAttrib" );
        lib.bindSymbol( cast( void** )&eglBindTexImage, "eglBindTexImage" );
        lib.bindSymbol( cast( void** )&eglReleaseTexImage, "eglReleaseTexImage" );
        lib.bindSymbol( cast( void** )&eglSwapInterval, "eglSwapInterval" );
        loadedVersion = EGLSupport.EGL11;
    }
    if( minor >= 2 ) {
        lib.bindSymbol( cast( void** )&eglBindAPI, "eglBindAPI" );
        lib.bindSymbol( cast( void** )&eglQueryAPI, "eglQueryAPI" );
        lib.bindSymbol( cast( void** )&eglWaitClient, "eglWaitClient" );
        lib.bindSymbol( cast( void** )&eglReleaseThread, "eglReleaseThread" );
        lib.bindSymbol( cast( void** )&eglCreatePbufferFromClientBuffer, "eglCreatePbufferFromClientBuffer" );
        loadedVersion = EGLSupport.EGL12;
    }
    if( minor >= 3 ) {
        loadedVersion = EGLSupport.EGL13;
    }
    if( minor >= 4 ) {
        lib.bindSymbol( cast( void** )&eglGetCurrentContext, "eglGetCurrentContext" );
        loadedVersion = EGLSupport.EGL14;
    }
    if( minor >= 5 ) {
        lib.bindSymbol( cast( void** )&eglCreateSync, "eglCreateSync" );
        lib.bindSymbol( cast( void** )&eglDestroySync, "eglDestroySync" );
        lib.bindSymbol( cast( void** )&eglClientWaitSync, "eglClientWaitSync" );
        lib.bindSymbol( cast( void** )&eglGetSyncAttrib, "eglGetSyncAttrib" );
        lib.bindSymbol( cast( void** )&eglGetPlatformDisplay, "eglGetPlatformDisplay" );
        lib.bindSymbol( cast( void** )&eglCreatePlatformWindowSurface, "eglCreatePlatformWindowSurface" );
        lib.bindSymbol( cast( void** )&eglCreatePlatformPixmapSurface, "eglCreatePlatformPixmapSurface" );
        lib.bindSymbol( cast( void** )&eglWaitSync, "eglWaitSync" );
        loadedVersion = EGLSupport.EGL14;
    }
    return(errorCount() == startErrorCount);
}
EGLint EGLversionMajor() { return major; }
EGLint EGLversionMinor() { return minor; }

package:
    SharedLib libGLES() { return lib; }

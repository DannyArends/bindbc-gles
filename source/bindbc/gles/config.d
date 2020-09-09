module bindbc.gles.config;

enum EGLSupport  {
    noLibrary,
    badLibrary,
    noContext,
    EGL10,
    EGL11,
    EGL12,
    EGL13,
    EGL14,
    EGL15
}

enum GLESSupport  {
    noLibrary,
    badLibrary,
    noContext,
    GLES10,
    GLES11,
    GLES20,
    GLES30,
    GLES31,
    GLES32
}
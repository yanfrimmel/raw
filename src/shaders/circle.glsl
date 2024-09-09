/* circle vertex shader */
@vs vs
uniform vs_params {
    float aspectRatio;
};

in vec4 position;
in vec4 color0;

out vec4 color;

void main() {
    gl_Position = position;
    gl_Position.x *= aspectRatio;
    color = color0;
}
@end

/* circle fragment shader */
@fs fs
uniform fs_params {
  vec3 offset;
};

in vec4 color;
out vec4 frag_color;

void main() {
    frag_color = color;
}
@end

/* circle shader program */
@program circle vs fs

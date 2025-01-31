precision highp float;

varying vec3 vWorldPosition;

void main() { gl_FragColor = vec4(vWorldPosition, 1.0); }
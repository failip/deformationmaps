precision highp float;

uniform sampler2D tDiffuse;
varying vec2 vUv;

varying vec4 vDisplacement;

void main() {
  vec4 color = texture2D(tDiffuse, vUv);
  gl_FragColor = color + vDisplacement * 10.0;
}
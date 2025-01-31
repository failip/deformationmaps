precision highp float;
uniform sampler2D tDiffuse1;
uniform sampler2D tDiffuse2;
varying vec2 vUv;

void main() {
  vec4 color1 = texture2D(tDiffuse1, vUv);
  vec4 color2 = texture2D(tDiffuse2, vUv);
  gl_FragColor = vec4((color2.rgb - color1.rgb), 1.0);
}
precision highp float;
varying vec2 vUv;

void main() {
  vUv = uv;
  gl_Position =
      vec4((1.0 - uv.x) * 2.0 - 1.0, (1.0 - uv.y) * 2.0 - 1.0, 0.0, 1.0);
  // gl_Position =
  // vec4((uv.x) * 2.0 - 1.0, (1.0 - uv.y) * 2.0 - 1.0, 0.0, 1.0);
}
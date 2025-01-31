precision highp float;

uniform sampler2D tDisplacement;
uniform float uDisplacementScale;
varying vec4 vDisplacement;
varying vec2 vUv;

attribute vec2 uv1;

void main() {
  vec4 displacement = texture2D(tDisplacement, uv1);
  vDisplacement = displacement;
  vUv = uv;

  displacement =
      vec4(displacement.x * -1.0, displacement.y, displacement.z, 1.0);

  displacement *= uDisplacementScale;
  vec4 newPosition = vec4(position.xyz + displacement.xyz, 1.0);
  gl_Position = projectionMatrix * (modelViewMatrix * newPosition);
  ;
}
uniform mat4 viewProjection;
uniform vec3 lightWorldPos;
uniform mat4 world;
uniform mat4 viewInverse;
uniform mat4 worldInverseTranspose;
attribute vec4 position;
attribute vec3 normal;
attribute vec2 texCoord;
attribute vec3 tangent;  // #normalMap
attribute vec3 binormal;  // #normalMap
varying vec4 v_position;
varying vec2 v_texCoord;
varying vec3 v_tangent;  // #normalMap
varying vec3 v_binormal;  // #normalMap
varying vec3 v_normal;
varying vec3 v_surfaceToLight;
varying vec3 v_surfaceToView;
void main() {
  v_texCoord = texCoord;
  v_position = (viewProjection * world * position);
  v_normal = (worldInverseTranspose * vec4(normal, 0)).xyz;
  v_surfaceToLight = lightWorldPos - (world * position).xyz;
  v_surfaceToView = (viewInverse[3] - (world * position)).xyz;
  v_binormal = (worldInverseTranspose * vec4(binormal, 0)).xyz;  // #normalMap
  v_tangent = (worldInverseTranspose * vec4(tangent, 0)).xyz;  // #normalMap
  gl_Position = v_position;
}
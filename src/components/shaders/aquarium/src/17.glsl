#ifdef GL_FRAGMENT_PRECISION_HIGH
  precision highp float;
#else
  precision mediump float;
#endif

uniform vec4 lightColor;
varying vec4 v_position;
varying vec2 v_texCoord;
varying vec3 v_normal;
varying vec3 v_surfaceToLight;
varying vec3 v_surfaceToView;

uniform vec4 ambient;
uniform sampler2D diffuse;
uniform vec4 specular;
uniform float shininess;
uniform float specularFactor;
// #fogUniforms

vec4 lit(float l ,float h, float m) {
  return vec4(1.0,
              max(l, 0.0),
              (l > 0.0) ? pow(max(0.0, h), m) : 0.0,
              1.0);
}
void main() {
  vec4 diffuseColor = texture2D(diffuse, v_texCoord);
  vec3 normal = normalize(v_normal);
  vec3 surfaceToLight = normalize(v_surfaceToLight);
  vec3 surfaceToView = normalize(v_surfaceToView);
  vec3 halfVector = normalize(surfaceToLight + surfaceToView);
  vec4 litR = lit(dot(normal, surfaceToLight),
                    dot(normal, halfVector), shininess);
  vec4 outColor = vec4((
  lightColor * (diffuseColor * litR.y + diffuseColor * ambient +
                specular * litR.z * specularFactor)).rgb,
      diffuseColor.a);
  // #fogCode
  gl_FragColor = outColor;
}
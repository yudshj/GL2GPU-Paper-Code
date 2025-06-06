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

uniform sampler2D diffuse;
uniform vec4 specular;

uniform sampler2D reflectionMap;
uniform samplerCube skybox;
uniform float shininess;
uniform float specularFactor;
uniform float refractionFudge;
uniform float eta;
uniform float tankColorFudge;
uniform float fogPower;
uniform float fogMult;
uniform float fogOffset;
uniform vec4 fogColor;


vec4 lit(float l ,float h, float m) {
  return vec4(1.0,
              max(l, 0.0),
              (l > 0.0) ? pow(max(0.0, h), m) : 0.0,
              1.0);
}
void main() {
  vec4 diffuseColor = texture2D(diffuse, v_texCoord) +
      vec4(tankColorFudge, tankColorFudge, tankColorFudge, 1);




  vec4 normalSpec = vec4(0,0,0,0);  // #noNormalMap
  vec4 refraction = texture2D(reflectionMap, v_texCoord.xy);




  vec3 normal = normalize(v_normal);   // #noNormalMap

  vec3 surfaceToLight = normalize(v_surfaceToLight);
  vec3 surfaceToView = normalize(v_surfaceToView);

  vec3 refractionVec = refract(surfaceToView, normal, eta);

  vec4 skyColor = textureCube(skybox, refractionVec);

//  vec4 bumpSkyColor = textureCube(skybox, refractionVec);
//  vec4 nonBumpSkyColor = textureCube(
//      skybox,
//      refract(surfaceToView, normalize(v_normal), eta));
//  vec4 skyColor = mix(nonBumpSkyColor, bumpSkyColor, normalSpec.a);
  vec4 outColor = vec4(
      mix(skyColor * diffuseColor, diffuseColor, refraction.r).rgb,
      diffuseColor.a);
  outColor = mix(outColor, vec4(fogColor.rgb, diffuseColor.a),
   clamp(pow((v_position.z / v_position.w), fogPower) * fogMult - fogOffset,0.0,1.0));

  gl_FragColor = outColor;
}
# version 400 core
uniform sampler2D texture;

uniform vec3 cameraPos;

uniform vec3 lightColour;
uniform vec3 lightPos;
uniform float lightRadius;

uniform sampler2D mainTex; // old texture , on Tex Unit 0
uniform sampler2D secondTex; // new texture , on Tex Unit 1

uniform float time; // From the previous tutorial !

in Vertex {
	vec3 worldPos; // worldspace position ...
	vec4 colour;
	vec2 texCoord;
	vec3 normal; // transformed worldspace normal !
} IN;

out vec4 fragColor;

void main(void) {
	vec3 incident = normalize(lightPos - IN.worldPos);
	vec3 viewDir = normalize(cameraPos - IN.worldPos);
	vec3 halfDir = normalize(incident + viewDir);

	float dist = length(lightPos - IN.worldPos);
	float atten = 1.0 - clamp(dist / lightRadius, 0.0, 1.0);
	float lambert = max(0.0 , dot(incident, IN.normal));

	float rFactor = max(0.0, dot(halfDir, normalize(IN.normal)));
	float sFactor = pow(rFactor, 50.0);
	float texBlend = (0.5f * sin(time)) + 0.5f;

	vec4 texCol = mix(
		texture(mainTex, IN.texCoord),
		texture(secondTex, IN.texCoord),
		texBlend
	);

	vec3 ambient = texCol.rgb * lightColour * 0.1;
	vec3 diffuse = texCol.rgb * lightColour * lambert * atten;
	vec3 specular = lightColour * sFactor * atten;
	fragColor = vec4(ambient + diffuse + specular, texCol.a);
}
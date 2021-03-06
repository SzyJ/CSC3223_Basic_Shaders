# version 400 core

uniform mat4 modelMatrix = mat4(1.0f);
uniform mat4 viewMatrix = mat4(1.0f);
uniform mat4 projMatrix = mat4(1.0f);

uniform float time = 0.1f;

layout(location = 0) in vec3 position;
layout(location = 1) in vec4 colour;
layout(location = 2) in vec2 texCoord;
layout(location = 3) in vec3 normal;

out Vertex {
	vec3 worldPos; // worldspace position ...
	vec4 colour;
	vec2 texCoord;
	vec3 normal; // transformed worldspace normal !
} OUT;

void applyLighting() {
    vec4 worldPos = modelMatrix * vec4(position, 1.0);
	
	gl_Position = (projMatrix * viewMatrix) * worldPos;
	
	OUT.texCoord = texCoord;
	OUT.worldPos = worldPos.xyz;
	
	mat3 normalMatrix = transpose(inverse(mat3(modelMatrix)));
	
	OUT.normal = normalize(normalMatrix * normalize(normal));
}

void main(void) {
    applyLighting();

	float T = time * 0.18;
	float acc = 7.0f;
	float scale = 1 - pow(T, acc);

	if (scale <= 0) {
		scale = 0;
	}

	mat4 mvp = (projMatrix * viewMatrix * modelMatrix);
	gl_Position = mvp * vec4(position * vec3(scale, scale, scale), 1.0);
    
	OUT.texCoord = texCoord;
	OUT.colour = colour;
}
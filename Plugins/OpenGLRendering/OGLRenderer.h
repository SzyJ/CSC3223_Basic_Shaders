#pragma once
#include "../../Common/RendererBase.h"

#ifdef _WIN32
#include "windows.h"
#endif

#include <string>
#include <vector>

namespace NCL {
	class MeshGeometry;
	namespace Rendering {
		class ShaderBase;
		class TextureBase;

		class OGLMesh;
		class OGLShader;

		class SimpleFont;

		class OGLRenderer : public RendererBase
		{
		public:
			friend class OGLRenderer;
			OGLRenderer(Window& w);
			~OGLRenderer();

			void OnWindowResize(int w, int h)	override;

			void DrawString(const std::string& text, const Vector2&pos);

		protected:			
			void BeginFrame()	override;
			void RenderFrame()	override;
			void EndFrame()		override;

			void DrawDebugData();

			void BindShader(ShaderBase*s);
			void BindTextureToShader(const TextureBase*t, const std::string& uniform, int texUnit) const;
			void BindMesh(MeshGeometry*m);
			void DrawBoundMesh(int subLayer = 0, int numInstances = 1);
#ifdef _WIN32
			void InitWithWin32(Window& w);
			void DestroyWithWin32();
			HDC		deviceContext;		//...Device context?
			HGLRC	renderContext;		//Permanent Rendering Context
#endif
		private:
			struct DebugString {
				Maths::Vector2	ndcPos;
				float			size;
				std::string		text;
			};
			OGLMesh*	boundMesh;
			OGLShader*	boundShader;

			OGLShader*  debugShader;
			SimpleFont* font;
			std::vector<DebugString> debugStrings;
		};
	}
}
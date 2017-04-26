#ifndef __VERTEX_BLEND_CGINC__
#define __VERTEX_BLEND_CGINC__

#include "UnityCG.cginc"

#ifdef SHADER_API_D3D11
StructuredBuffer<float3> _VertexPositions;
#endif

static const float4x4 IDENTITY_MATRIX = { 
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
};

#define VERTEX_BLEND_FUNC(v, b, x) saturate(v * (x + b - 1.0) + b)

float LinearVariationalBlend(float variation, float blendRatio, float x) {
    return VERTEX_BLEND_FUNC(variation, blendRatio, x);
}
float3 GetTargetWorldPosition(uint vertexIndex) {
    #ifdef SHADER_API_D3D11
    return _VertexPositions[vertexIndex];
    #else
    return 0;
    #endif
}
float3 BlendPosition(uint vertexIndex, float3 srcPos, float blendRatio, float4x4 dstIntoSrcSpace) {
    #ifdef SHADER_API_D3D11
    float3 dstPos = GetTargetWorldPosition(vertexIndex);
    dstPos = mul(dstIntoSrcSpace, float4(dstPos, 1));
    srcPos = lerp(srcPos, dstPos, blendRatio);
    #endif
    return srcPos;
}
float3 BlendLocalPosition(uint vertexIndex, float3 srcPos, float blendRatio) {           
    return BlendPosition(vertexIndex, srcPos, blendRatio, unity_WorldToObject);
}
float3 BlendWorldPosition(uint vertexIndex, float3 srcPos, float blendRatio) {			
    return BlendPosition(vertexIndex, srcPos, blendRatio, IDENTITY_MATRIX);
}


#endif
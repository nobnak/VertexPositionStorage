﻿Shader "VertexBlend/Unlit" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)

        [Header(Vertex Position Blend)]
        _VertexPositionBlend_Blend ("Position Blend", Range(0,1)) = 0
        _VertexPositionBlend_Variation ("Blend Variation", Range(0,10)) = 0
        _VertexPositionBlend_UVBobbin ("UV Bobbin", Vector) = (1, 1, 1, 1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
        Cull Off

		Pass {
			CGPROGRAM
            #pragma target 5.0
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
            #include_with_pragmas "VertexBlend.cginc"

			struct appdata {
                uint vid : SV_VertexID;
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
            float4 _Color;
			
			v2f vert (appdata v) {
				float3 world_pos0 = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)).xyz;
				float3 world_pos1 = GetTargetWorldPosition(v.vid);
				float b = UVVariationalBlend(v.uv);
				float3 world_pos = lerp(world_pos0, world_pos1, b);
				v.vertex.xyz = mul(unity_WorldToObject, float4(world_pos, 1)).xyz;

				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target {
				fixed4 col = tex2D(_MainTex, i.uv) * _Color;
				return col;
			}
			ENDCG
		}
	}
}

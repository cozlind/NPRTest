// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/NPR2" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Bump("Bump",2D) = "white"{}
		_Ramp("Ramp",2D) = "white"{}
		_Tooniness("Tooniness",Range(0.1,20))=4
		_Outline("Outline",Range(0,1)) = 0.5
	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			Pass{
				Tags{"LightMode" = "ForwardBase"}

				Cull Front
				Lighting Off
				ZWrite On

				CGPROGRAM
				#pragma vertex vert  
				#pragma fragment frag 
				#pragma multi_compile_fwdbase  
				#include "UnityCG.cginc" 


				float _Outline;

				struct a2v 
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};
				struct v2f
				{
					float4 pos : POSITION;
				};
				v2f vert(a2v v)
				{	
					v2f o;

					float4 pos = mul(UNITY_MATRIX_MV, v.vertex);
					float3 normal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
					normal.z = -0.5;
					pos = pos + float4(normalize(normal), 0)*_Outline;
					o.pos = mul(UNITY_MATRIX_P,pos);
					return o;
				}
				float4 frag(v2f i) : COLOR
				{
					return float4(0,0,0,1);
				}

					ENDCG
		}

			Pass{
				Tags{"LightMode" = "ForwardBase"}

				Cull Back
				Lighting On

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fwdbase
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "AutoLight.cginc"
				#include "UnityShaderVariables.cginc"

				sampler2D _MainTex;
				sampler2D _Ramp;
				sampler2D _Bump;

				float4 _MainTex_ST;
				float4 _Bump_ST;
				float _Tooniness;

				struct a2v {
					float4 vertex:POSITION;
					float3 normal:NORMAL;
					float4 texcoord:TEXCOORD0;
					float4 tangent :TANGENT;
				};
				struct v2f {
					float4 pos:POSITION;
					float2 uv:TEXCOORD0;
					float2 uv2:TEXCOORD1;
					float3 lightDirection:TEXCOORD2;
					LIGHTING_COORDS(3,4)
				};
				v2f vert(a2v v)
				{
					v2f o;
					TANGENT_SPACE_ROTATION;
					o.lightDirection = mul(rotation, ObjSpaceLightDir(v.vertex));
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.uv2 = TRANSFORM_TEX(v.texcoord, _Bump);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					return o;
				}
				float4 frag(v2f i):SV_TARGET
				{
					float4 c = tex2D(_MainTex,i.uv);
					c.rgb = (floor(c.rgb*_Tooniness) / _Tooniness);
					float3 n = UnpackNormal(tex2D(_Bump, i.uv2));
					float3 lightColor = float3(0,0,0);
					float atten = LIGHT_ATTENUATION(i);
					float diff = saturate(dot(n, normalize(i.lightDirection)));
					diff = tex2D(_Ramp, float2(diff, 0.5));
					lightColor += _LightColor0.rgb*(diff*atten);
					c.rgb = lightColor*c.rgb * 2;
					return c;
				}
				ENDCG
		}
				Pass{
				Tags{"LightMode" = "ForwardBase"}

				Cull Back
				Lighting On

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fwdbase
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "AutoLight.cginc"
				#include "UnityShaderVariables.cginc"

				sampler2D _MainTex;
				sampler2D _Ramp;
				sampler2D _Bump;

				float4 _MainTex_ST;
				float4 _Bump_ST;
				float _Tooniness;

				struct a2v {
					float4 vertex:POSITION;
					float3 normal:NORMAL;
					float4 texcoord:TEXCOORD0;
					float4 tangent :TANGENT;
				};
				struct v2f {
					float4 pos:POSITION;
					float2 uv:TEXCOORD0;
					float2 uv2:TEXCOORD1;
					float3 lightDirection:TEXCOORD2;
					LIGHTING_COORDS(3,4)
				};
				v2f vert(a2v v)
				{
					v2f o;
					TANGENT_SPACE_ROTATION;
					o.lightDirection = mul(rotation, ObjSpaceLightDir(v.vertex));
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.uv2 = TRANSFORM_TEX(v.texcoord, _Bump);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					return o;
				}
				float4 frag(v2f i):SV_TARGET
				{
					float4 c = tex2D(_MainTex,i.uv);
					c.rgb = (floor(c.rgb*_Tooniness) / _Tooniness);
					float3 n = UnpackNormal(tex2D(_Bump, i.uv2));
					float3 lightColor = float3(0,0,0);
					float atten = LIGHT_ATTENUATION(i);
					float diff = saturate(dot(n, normalize(i.lightDirection)));
					diff = tex2D(_Ramp, float2(diff, 0.5));
					lightColor += _LightColor0.rgb*(diff*atten);
					c.rgb = lightColor*c.rgb * 2;
					return c;
				}
				ENDCG
		}
					Pass{
				Tags{"LightMode" = "ForwardBase"}

				Cull Back
				Lighting On

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fwdbase
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "AutoLight.cginc"
				#include "UnityShaderVariables.cginc"

				sampler2D _MainTex;
				sampler2D _Ramp;
				sampler2D _Bump;

				float4 _MainTex_ST;
				float4 _Bump_ST;
				float _Tooniness;

				struct a2v {
					float4 vertex:POSITION;
					float3 normal:NORMAL;
					float4 texcoord:TEXCOORD0;
					float4 tangent :TANGENT;
				};
				struct v2f {
					float4 pos:POSITION;
					float2 uv:TEXCOORD0;
					float2 uv2:TEXCOORD1;
					float3 lightDirection:TEXCOORD2;
					LIGHTING_COORDS(3,4)
				};
				v2f vert(a2v v)
				{
					v2f o;
					TANGENT_SPACE_ROTATION;
					o.lightDirection = mul(rotation, ObjSpaceLightDir(v.vertex));
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.uv2 = TRANSFORM_TEX(v.texcoord, _Bump);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					return o;
				}
				float4 frag(v2f i):SV_TARGET
				{
					float4 c = tex2D(_MainTex,i.uv);
					c.rgb = (floor(c.rgb*_Tooniness) / _Tooniness);
					float3 n = UnpackNormal(tex2D(_Bump, i.uv2));
					float3 lightColor = float3(0,0,0);
					float atten = LIGHT_ATTENUATION(i);
					float diff = saturate(dot(n, normalize(i.lightDirection)));
					diff = tex2D(_Ramp, float2(diff, 0.5));
					lightColor += _LightColor0.rgb*(diff*atten);
					c.rgb = lightColor*c.rgb * 2;
					return c;
				}
				ENDCG
		}
						Pass{
				Tags{"LightMode" = "ForwardBase"}

				Cull Back
				Lighting On

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fwdbase
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "AutoLight.cginc"
				#include "UnityShaderVariables.cginc"

				sampler2D _MainTex;
				sampler2D _Ramp;
				sampler2D _Bump;

				float4 _MainTex_ST;
				float4 _Bump_ST;
				float _Tooniness;

				struct a2v {
					float4 vertex:POSITION;
					float3 normal:NORMAL;
					float4 texcoord:TEXCOORD0;
					float4 tangent :TANGENT;
				};
				struct v2f {
					float4 pos:POSITION;
					float2 uv:TEXCOORD0;
					float2 uv2:TEXCOORD1;
					float3 lightDirection:TEXCOORD2;
					LIGHTING_COORDS(3,4)
				};
				v2f vert(a2v v)
				{
					v2f o;
					TANGENT_SPACE_ROTATION;
					o.lightDirection = mul(rotation, ObjSpaceLightDir(v.vertex));
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.uv2 = TRANSFORM_TEX(v.texcoord, _Bump);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					return o;
				}
				float4 frag(v2f i):SV_TARGET
				{
					float4 c = tex2D(_MainTex,i.uv);
					c.rgb = (floor(c.rgb*_Tooniness) / _Tooniness);
					float3 n = UnpackNormal(tex2D(_Bump, i.uv2));
					float3 lightColor = float3(0,0,0);
					float atten = LIGHT_ATTENUATION(i);
					float diff = saturate(dot(n, normalize(i.lightDirection)));
					diff = tex2D(_Ramp, float2(diff, 0.5));
					lightColor += _LightColor0.rgb*(diff*atten);
					c.rgb = lightColor*c.rgb * 2;
					return c;
				}
				ENDCG
		}
							Pass{
					Tags{ "LightMode" = "ForwardAdd" }

					Cull Back
					Lighting On
					Blend One One

					CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma multi_compile_fwdadd
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"
#include "UnityShaderVariables.cginc"

					sampler2D _MainTex;
				sampler2D _Ramp;
				sampler2D _Bump;

				float4 _MainTex_ST;
				float4 _Bump_ST;
				float _Tooniness;

				struct a2v {
					float4 vertex:POSITION;
					float3 normal:NORMAL;
					float4 texcoord:TEXCOORD0;
					float4 tangent :TANGENT;
				};
				struct v2f {
					float4 pos:POSITION;
					float2 uv:TEXCOORD0;
					float2 uv2:TEXCOORD1;
					float3 lightDirection:TEXCOORD2;
					LIGHTING_COORDS(3,4)
				};
				v2f vert(a2v v)
				{
					v2f o;
					TANGENT_SPACE_ROTATION;
					o.lightDirection = mul(rotation, ObjSpaceLightDir(v.vertex));
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.uv2 = TRANSFORM_TEX(v.texcoord, _Bump);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					return o;
				}
				float4 frag(v2f i) :SV_TARGET
				{
					float4 c = tex2D(_MainTex,i.uv);
					c.rgb = (floor(c.rgb*_Tooniness) / _Tooniness);
					float3 n = UnpackNormal(tex2D(_Bump, i.uv2));
					float3 lightColor = float3(0,0,0);
					float atten = LIGHT_ATTENUATION(i);
					float diff = saturate(dot(n, normalize(i.lightDirection)));
					diff = tex2D(_Ramp, float2(diff, 0.5));
					lightColor += _LightColor0.rgb * (diff * atten);
					c.rgb = lightColor*c.rgb * 2;
					return c;
				}
					ENDCG
				}
	}
	FallBack "Diffuse"
}

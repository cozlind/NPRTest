Shader "Custom/NPR1" {
	Properties {
		_MainTex("Texture",2D) = "white"{}
		_BumpMap("Bumpmap",2D) = "bump"{}
		_Tooniness("Tooiness",Range(0.1,20))=4
		_Ramp("Ramp Texture",2D) = "white"{}
		_Outline("Outline",Range(0,1))=0.4
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Toon
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _Ramp;
		float _Tooniness;
		float _Outline;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			half edge = saturate(dot(o.Normal, normalize(IN.viewDir)));
			edge = edge < _Outline ? edge/4  : 1;
			o.Albedo = (floor(c.rgb * _Tooniness) / _Tooniness)*edge;
			o.Alpha = c.a;
		}
		
		half4 LightingToon(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float difLight = dot(s.Normal, lightDir);
			float dif_hLambert = difLight;// *0.5 + 0.5;

			float rimLight = dot(s.Normal, viewDir);
			float rim_hLambert = rimLight;// *0.5 + 0.5;

			float3 ramp = tex2D(_Ramp, float2(rim_hLambert, dif_hLambert)).rgb;
			half4 c;
			c.rgb = s.Albedo*_LightColor0.rgb*ramp*atten*2;
			c.a = s.Alpha;
			return c;
		}

		ENDCG
	}
	FallBack "Diffuse"
}

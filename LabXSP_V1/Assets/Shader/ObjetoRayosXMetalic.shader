Shader "labxsp/ObjetoRayosXMetalic"
{
   Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
		_MetallicTex ("Metallic tex",2D) = "white"{}
		_Metallic("Metallic",Range(0,1))=0
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		[Toggle] _Emission("Emission",float) = 0
		_EmissionTex ("Emission Tex", 2D) = "black"{}
		[HDR]_EmissionColor("Emission Color", Color) = (1,1,1,1)
		_RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Normal ("Normal", 2D) = "bump" {}
		_SRef ("Stencil Ref", float) = 1
		[Enum (UnityEngine.Rendering.CompareFunction)]	_SComp("Stencil Comp", float) = 8
		[Enum (UnityEngine.Rendering.StencilOp)]		_SOp ("Stencil Op", float) = 2
    }
    SubShader
    {
        Stencil
		{
			Ref[_SRef]
			Comp[_SComp]
			Pass[_SOp]
		}

        CGPROGRAM
        #pragma surface surf Standard  Unlit
		float _Metallic,_Emission,_Glossiness,_RimPower;
        sampler2D  _MainTex, _Normal,_MetallicTex,_EmissionTex;
        fixed4 _Color,_EmissionColor;

        struct Input
        {
            float2  uv_MainTex;
			float2 uv_Normal;
			float2 uv_MetallicTex;
			float2 uv_Emission;
			float3 viewDir;

        };


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c =			tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 cMetallic =	tex2D(_MetallicTex,IN.uv_MetallicTex);
            o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
			o.Alpha = 1;
			o.Metallic = cMetallic.rgb * _Metallic;
			o.Smoothness = _Glossiness;
			if (_Emission == 1)
			{			
				fixed4 cEmission =	tex2D(_EmissionTex,IN.uv_Emission)* _EmissionColor;
				half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
				o.Emission = cEmission * pow(rim,_RimPower);
			}

        }
				half4 LightingUnlit(SurfaceOutput s, half3 lightDir, half atten)
		{
			fixed4 c = fixed4(0,0,0,0);
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;		
		}

        ENDCG
    
    }
    FallBack "Diffuse"
}

Shader "labxsp/ObjetoRayosXLambert"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
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
        #pragma surface surf Lambert

        sampler2D  _MainTex, _Normal;
        fixed4 _Color;

        struct Input
        {
            float2  uv_MainTex;
			float2 uv_Normal;
        };

		half4 LightingUnlit(SurfaceOutput s, half3 lightDir, half atten)
		{
			fixed4 c = fixed4(0,0,0,0);
			//c.rgb = s.Albedo;
			//c.a = s.Alpha;
			return c;		
		}
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
			o.Alpha = 0;
        }

        ENDCG
    
    }
    FallBack "Diffuse"
}

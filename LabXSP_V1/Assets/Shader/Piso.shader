Shader "labxsp/Piso"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_tamanoCuadricula ("Tamaño de cuadricula", float) = 4
		_GrosorLinea ("Grosor de Linea", Range (0.0,1.0)) = .1
		_ColorLinea ("Color de Linea", Color) = (1,0,0,1)
		_ColorPiso ("Color del piso", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf Unlit alpha

        
        sampler2D _MainTex;
		float _tamanoCuadricula, _GrosorLinea;
		float4 _ColorLinea, _ColorPiso;
        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			float4 c = _ColorPiso;
			float2 uv = IN.uv_MainTex;
			float2 cuadricula = frac(uv * _tamanoCuadricula);
			if (cuadricula.x > _GrosorLinea || cuadricula.y > _GrosorLinea)
			{
				//o.Emission = _ColorLinea * cos(_Time.y)*.5+.5;
				o.Emission = _ColorLinea* sin(_Time.y /3); 	

			}  
			o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
				half4 LightingUnlit(SurfaceOutput s, half3 lightDir, half atten)
		{
			fixed4 c;
			c.rgb = s.Albedo.rgb;
			c.a = s.Alpha;
			return c;		
		}
        ENDCG
    }
    FallBack "Diffuse"
}

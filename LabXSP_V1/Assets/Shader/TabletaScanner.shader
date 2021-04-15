Shader "labxsp/TabletaScanner"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_tamano ("tamaño de linea",Range(.001,.1)) = .2
		_ColorLinea("color linea",Color) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" ="Transparent"}
        CGPROGRAM
        #pragma surface surf Unlit alpha:fade

        
        sampler2D _MainTex;
		float _tamano;
		float4 _ColorLinea;
        struct Input
        {
            float2 uv_MainTex;
        };

		half4 LightingUnlit(SurfaceOutput s, half3 lightDir, half atten)
		{
			fixed4 u;
			u.rgb = s.Albedo.rgb;
			u.a = s.Alpha;
			return u;		
		}
		float linea(float uv, float tamano)
		{
			float c = 0;
			c = smoothstep(.5+tamano, .5, uv.x) * smoothstep(.5-tamano, .5, uv);

			return c;
		}
        void surf (Input IN, inout SurfaceOutput o)
        {
			float4 c = float4(0,0,0,1);
			float2 uv = IN.uv_MainTex;
			uv.x +=  sin(_Time.y)*.6;
			uv.y +=  cos(_Time.y)*.6;
			c.ra =  linea(uv.x,_tamano)+ linea(uv.y,_tamano);
			//c = _ColorLinea;
			o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}

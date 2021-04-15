Shader "labxsp/ContornoMaletero"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_FuerzaBorde("Fuerza En el borde", Range(0.5,10))= 3.0
		_GrosorLineas("Grosor de lineas", Range(.01,.99)) = .2
		_NumeroLineas("Numero de lineas", float) =10
    }
    SubShader
    {
         Tags { "Queue" ="Transparent"}

        CGPROGRAM
        #pragma surface surf Unlit alpha:fade

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        float4 _Color;
		float _FuerzaBorde, _GrosorLineas, _NumeroLineas;

       

        void surf (Input IN, inout SurfaceOutput o)
        {
            float4 c =  float4 (0,0,0,1);
			c.rgb = _Color;
			float2 uv = IN.uv_MainTex;
			uv.x += sin(_Time.y * .1)*2;
			float cuadricula =  frac (uv.x * _NumeroLineas);
			float contornoY = step (1- _GrosorLineas,uv.y);
			c.a = step(1 -_GrosorLineas,cuadricula) + contornoY ;
			//c.a = contornoY;

			o.Albedo =c.rgb;
			o.Alpha = c.a;

        }
		half4 LightingUnlit(SurfaceOutput s, half3 lightDir, half atten)
		{
			fixed4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;		
		}
        ENDCG
    }
    FallBack "Diffuse"
}

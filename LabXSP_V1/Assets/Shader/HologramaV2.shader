Shader "labxsp/HologramaV2"
{
    Properties
    {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		_ColorBorde("color de borde", Color) = (0,0.5,0.5,0)
		_FuerzaBorde("Fuerza En el borde", Range(0.5,8))= 3.
		_GrosorLineas("Grosor de lineas horizontales", Range(0,1)) = .2
		_Test("test",Range(0,10)) =1
		[Toggle] _LineasVerticales ("Lineas Verticales", float) = 0 
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
		Pass { ZWrite on ColorMask 0}
		Blend SrcAlpha OneMinusSrcAlpha
        CGPROGRAM
        #pragma surface surf Unlit alpha:fade


        struct Input
        {
            float3 viewDir;
			float3 worldPos;
        };

		float4 _ColorBorde;
		float _FuerzaBorde,_GrosorLineas, _LineasVerticales, _Test;

        void surf (Input IN, inout SurfaceOutput o)
        {
			float4 c = float4 (0,0,0,1);
			
			half rim = 1- saturate(dot (normalize(IN.viewDir), o.Normal));
			//rim *=  sin(_Time.y) * .2 +.8;
			float linea = frac((IN.worldPos.y + sin(_Time.y*.5)) * 2) ;
			linea = step(1-_GrosorLineas, linea);
			if (_LineasVerticales != 0)
			{
				float lineaVertical =frac((IN.worldPos.x + cos(_Time.y*.2)) * 3)* _LineasVerticales;
				linea += step(1- _GrosorLineas,lineaVertical);
			}
			
			float _emission = pow(rim,_FuerzaBorde) *10;
			_emission = lerp (_emission, linea, linea);
			o.Emission = _ColorBorde.rgb * _emission  ;
			//o.Emission = linea * _ColorBorde.rgb;
			o.Alpha =pow (rim,_FuerzaBorde) +linea;
			
			
			//o.Emission = _ColorBorde.rgb * pow(rim,_FuerzaBorde) *10 ;
			//o.Alpha = pow (rim,_FuerzaBorde);
			// (frac((IN.worldPos.y+IN.worldPos.z*0.1) * 5) - 0.5);
			//o.Albedo = c.rgb;
            //o.Alpha = c.a;
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

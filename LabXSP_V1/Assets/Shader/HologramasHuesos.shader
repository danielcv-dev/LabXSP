Shader "labxsp/HologramasHuesos"
{
    Properties
    {
		_ColorBorde("color de borde", Color) = (0,0.5,0.5,0)
		_FuerzaBorde("Fuerza En el borde", Range(0.5,8))= 3.0
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
        };

		float4 _ColorBorde;
		float _FuerzaBorde;

        void surf (Input IN, inout SurfaceOutput o)
        {
			float4 c = float4 (0,0,0,1);
			
			half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
			rim *=  sin(_Time.y) * .2 +.8;
			o.Emission = _ColorBorde.rgb * pow(rim,_FuerzaBorde) *10 ;
            o.Alpha = pow (rim,_FuerzaBorde);
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

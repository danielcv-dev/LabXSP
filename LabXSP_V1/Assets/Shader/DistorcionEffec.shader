Shader "labxsp/DistorcionEffec"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
		_ColorDistorcion ("color Distorcion", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_TamanoDistorcion("Tamaño de distorcion",Range(20,250)) = 100
		_FuerzaDistorcion("Fuerza de distorcion", Range(.0, .05)) = .005
		_velocidad ("velocidad", float) = 1

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" ="Transparent"  }
        LOD 200

        CGPROGRAM
        #pragma surface surf   Unlit alpha:fade

        float _TamanoDistorcion, _FuerzaDistorcion, _velocidad;
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color , _ColorDistorcion;
		float Random(float2 uv)
		{
			return frac(sin (dot (uv.xy, float2(12.9898, 78.233)))* 43758.5453123);
		}
		float AnimacionDistorcionTime(float2 uv)
		{
			Random(floor(_Time.y *500));
			return 0.0;
		}
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = fixed4(0,0,0,1); //tex2D (_MainTex, IN.uv_MainTex) * _Color;
			float2 uv = IN.uv_MainTex;
			//uv.y += sin(_Time.y)*.02;
			fixed4 imagen = tex2D (_MainTex, uv)*_Color;
			float2 distorcionR = floor(uv * float2(1, _TamanoDistorcion));
			float animacionDistorcion = Random(distorcionR);//* sin((_Time.y * _velocidad) + distorcionR.y );// <= .6 ? 0.0 :1.0;

			c = tex2D (_MainTex, float2(uv.x +( animacionDistorcion * _FuerzaDistorcion ), uv.y)) * _ColorDistorcion;
			c.rgb = imagen.rgb;
			
			if (imagen.a>0)
			{
				if (c.a<1)
				{
					c.rgb = _ColorDistorcion.rgb;
				}
				
			}

			c.a = (c.a + imagen.a)> 0  ? max(c.a,imagen.a): 0;

			//c.rgb = AnimacionDistorcionTime(uv);
            o.Albedo = c.rgb;
           
            o.Alpha =  c.a> 1 ? 1: c.a  ;
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

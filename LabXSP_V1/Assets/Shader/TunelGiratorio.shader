Shader "labxsp/TunelGiratorio"
{
    Properties
    {
        _Color1 ("Color1", Color) = (1,1,1,1)
		_Color2 ("Color2", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cuadricula("Tamaño de cuadricula", Range(1,20)) = 2
		_ColorCierculos ("Color de  circulos", Color) =  (1,1,1,1)
		_Oscurecer("Oscurecer todo", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf  Unlit

		#define PI 3.14159265359
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color1,_Color2,_ColorCierculos;
		float _Cuadricula, _Oscurecer;

		float2 rotar2d(float _angulo,float2 uv)
		{
			return mul(uv, float2x2 (cos(_angulo), -sin(_angulo), sin(_angulo), cos(_angulo)));
		}
		float Circulo(float2 uv, float size)
		{
			float2 cuadricula = frac(uv* _Cuadricula);
			cuadricula = cuadricula *2 -1;
			float c = 1-step(size, length(cuadricula));
			return c;
		}
		float linea(float2 uv, float diviciones)
		{
			uv.x = frac(uv*diviciones);
			float c  = smoothstep(0,.5,uv.x);
			c *= smoothstep(1,.5,uv.x);
			return c;
		}
       
        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = 0;
			float2 uv = IN.uv_MainTex;
			
			uv = uv *2 -1;
			float2 uvRotar = uv; 
			uvRotar =   rotar2d(PI *0.285,uvRotar);

			

			float circulos1 = Circulo(uv+float2(-.46,-.24),.3);
			float ciruclos2 = Circulo(uv+float2(.46,.24),.3);
			float ciruclos3 = Circulo(uv+float2(.166,.057),.3);
			circulos1 = lerp(circulos1,ciruclos2,ciruclos2);
			circulos1 = lerp(circulos1,ciruclos3,ciruclos3);
			c.rgb = lerp(_Color1,_Color2,linea(uvRotar,4)); 
			c.rgb = lerp (c.rgb,circulos1 * _ColorCierculos, circulos1 );
			c.rgb = lerp ( c.rgb,float3(0,0,0),_Oscurecer);
			



            o.Albedo = c.rgb;
            
            o.Alpha = 1;
        }
		        half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) {
           half4 c;
           c.rgb = s.Albedo;
           c.a = s.Alpha;
           return c;
         }
        ENDCG
    }
    FallBack "Diffuse"
}

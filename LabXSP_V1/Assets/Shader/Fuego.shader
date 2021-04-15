Shader "labxsp/Fuego"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _CantidadBolas("Cantidad de bolas de fuego en Y", Range(1,10)) = 2
        _Fuerza ("Fuerza del fuego", Range(1,10)) = 1
		_test ("test",float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Transparent" }

        CGPROGRAM
        #pragma surface surf Unlit alpha:fade
        #define mod(x,y) x-y*floor(x/y)
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        
        fixed4 _Color;
        float _CantidadBolas, _Fuerza;
		float _test;
        float2 hash(float2 p)
        {
            p = float2(dot(p,float2(127.1,311.7)),dot(p,float2(269.5,183.3)));
            return -1.0 +2.0 *frac(sin(p)* 43758.5453123);
        }

        float noise (float2 p)
        {
            const float k1 = 0.366025404; // (sqrt(3)-1)/2;
            const float k2 = 0.211324865; //(3-sqrt(3))/6;
            float2 i = floor(p + (p.x + p.y) * k1);

            float2 a = p - i + (i.x + i.y)*k2;
            float2 o = (a.x>a.y)? float2(1.0,0.0) : float2(0.0,1.0);
            float2 b = a - o +k2;
            float2 c = a-1.0 + 2.0 *k2;

            float3 h = max (0.5 - float3 (dot(a,a), dot(b,b), dot(c,c)),0.0);
            float3 n = h*h*h*h* float3 (dot(a, hash(i)),dot(b,hash(i+o)),dot(c,hash(i+1.0))); 
            return dot(n, 70);
        }

        float fbm(float2 uv)
        {
            float f;
            float2x2 m = float2x2(1.6,1.2,-1.2,1.6);
            f  = 0.5 * noise (uv); uv = mul(m,uv);
            f += 0.25 * noise(uv); uv = mul(m,uv);
            f += 0.1250 * noise(uv); uv = mul(m,uv);
            f += 0.0625 * noise(uv); uv = mul(m,uv);
            f = 0.5 +0.5*f;
            return f;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = fixed4(0,0,0,1);
            float2 uv = IN.uv_MainTex;
            float2 q = uv;
            q.y *= _CantidadBolas;
            float T3 = max(3.,1.25* _Fuerza) * _Time.y;
            q.x = mod(q.x,1)-0.5;
            q.y -= 0.25;
            float n = fbm(_Fuerza *q -float2(0,T3));
            // crear la figura de la llama
            float d = 1.0 -16. * pow( max(0.0, length(q * float2(1.8 + q.y * 1.5,.75)) - n * max(0.0, q.y + .25)),1.2);

            float d1 = n * d * (1.5-pow(1.*uv.y,4));
            d1 = clamp (d1,0.0,1.0);


            c.rgb = float3 (1.5 * d1, 1.5*d1*d1*d1,d1*d1*d1*d1*d1*d1);

            float a  = d* (1.-pow(uv.y,3));
            c.a = a<0 ? 0 :a;


            o.Albedo = c.rgb;
			o.Emission = c.rgb * _test;
            o.Alpha = c.a;
        }
        half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) {
           half4 c;
           c.rgb = s.Emission; // modificado cambiar al albedo
           c.a = s.Alpha;
           return c;
         }
        ENDCG
    }
    FallBack "Diffuse"
}

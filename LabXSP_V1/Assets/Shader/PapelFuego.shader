Shader "labxsp/PapelFuego"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_UnionTex ("union de papel (RGB)", 2D) = "white" {}
		_Amount ("fuerza de inflado", Range(-1,1))=0
		[Toggle]_CapaInterior ("Capara interior Globo", float) =0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Transparent" }
		 //Cull off
		//Blend SrcAlpha OneMinusSrcAlpha
		LOD 200
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
		#define mod(x,y) x-y*floor(x/y)

        sampler2D _MainTex, _UnionTex;
		float _CapaInterior;
        struct Input
        {
            float2 uv_MainTex;
			float2 uv_UnionTex;
			float3 viewDir;
        };

        fixed4 _Color;


        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 textura =tex2D (_MainTex, IN.uv_MainTex);
			fixed4 unionTextura =tex2D (_UnionTex, IN.uv_UnionTex);
            fixed4 c =  _Color  * textura;
			float2 q =IN.uv_MainTex - float2(.5,0);

			float animacionLuz =sin(_Time.y*6)*sin(_Time.y)* sin(_Time.y*2) *.6+1;
			float d = (1-smoothstep(.1,animacionLuz*.6, q.y));
			c.rgb = (.5 + d) * _Color.rgb;

			c.a = lerp(c.a, .95, unionTextura.a);
			c.rgb = lerp (c.rgb, c.rgb-.08,unionTextura.a );
			c.rgb *=textura.rgb; 
            o.Albedo = c.rgb;
			o.Emission = (c.rgb)*.5;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

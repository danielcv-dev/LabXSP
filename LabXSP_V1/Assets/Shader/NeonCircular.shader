Shader "Unlit/NeonCircular"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" ="Transparent"  }
        LOD 100
				Blend SrcAlpha OneMinusSrcAlpha 

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag



			#define PI 3.1415926

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
			
			float pat(float2 uv,float p,float q,float s,float glow)
			{
				float z = cos(q * PI * uv.x) * cos(p * PI * uv.y) + cos(q * PI * uv.y) * cos(p * PI * uv.x);

				z += sin(_Time.y*4.0 + uv.x+uv.y * s)*0.035;	// +wobble
				float dist=abs(z)*(1.0/glow);
				return dist;
			}

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = 1;
				float2 uv = i.uv *2;
				float d =  pat(uv,5.0,2.0,35.0,.35);
				col.rgba = float4(0.25, 0.45,1.25,.8) * .5 /d;
                return col;
            }
            ENDCG
        }
    }
}

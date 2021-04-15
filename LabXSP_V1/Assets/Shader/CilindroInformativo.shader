Shader "labxsp/CilindroInformativo"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color1 ("Color1", Color) = (1,1,1,1)
		_Color2 ("Color2", Color) = (1,1,1,1)
		_NumeroLineas("Numero de lineas", Range(2,10)) = 3
		_TamanoLineaInferior("Tamaño de linea Inferior", Range(0,1)) = .05
    }
    SubShader
    {
        Tags { "Queue" ="Transparent"}
		 Cull off   
		 			ZWrite [_ZWrite]

		Blend SrcAlpha OneMinusSrcAlpha 
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work

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
			float4 _Color1, _Color2;
			float _NumeroLineas,  _TamanoLineaInferior;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col =  fixed4(0,0,0,1);
				float2 uv = i.uv;
				uv.x += _Time.y *.01;
				col.rgb = lerp (_Color1.rgb, _Color2.rgb,uv.y+.1);
				float cuatroPartes = frac(uv.x *4);
				float idCuatroPartes = floor (uv.x *4);

				if (idCuatroPartes %2 == 0 )
				{
				
					float lineasVerticales = frac(cuatroPartes *_NumeroLineas);
					float idLineasVerticales = floor (cuatroPartes *_NumeroLineas);
					float llamas =  .7 + (sin(_Time.y + idLineasVerticales) * .2)  - length(float2(lineasVerticales, uv.y + .4)-.5);
					if (llamas < 0)
					{
						col.a = 0;
					}
					else
					{
						col.a = llamas ;
					}
				}
				else
				{
					col.a = 0;
				}
				col.a = lerp(col.a,1,step(uv.y, _TamanoLineaInferior));
				//col.rgb = lineasVerticales.x;
                // sample the texture
				
				//tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}

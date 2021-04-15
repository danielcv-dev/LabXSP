Shader "labxsp/CirculoInformativo"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_ColorCirculos("Color de circulos exteriores", Color) = (0,0,0,1)
		_TamanoCirculoInterior("Tamaño de circulo interior", Range(0,1)) = .5 
		_colorCirculoInterior("Color del circulo interior", Color) = (0,0,0,1)
		_colorResplandor ("color de resplandor", Color) = (0,0,0,1)
    }
    SubShader
    {

		Tags { "Queue" ="Transparent"}	
		Blend SrcAlpha OneMinusSrcAlpha 

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"

			#define PI 3.14159265359


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
			float4 _ColorCirculos,_colorCirculoInterior, _colorResplandor;
			float _TamanoCirculoInterior;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
			float circulo (float2 uv, float2 posicion, float tamano)
			{
				fixed circulo = 0;
				circulo = 1 - step(tamano-.02,length(uv + posicion));
				circulo += (1- smoothstep(tamano, .2 ,length(uv + posicion)))*.5;
				return circulo;
			}
			float2 rotar2d(float _angulo,float2 uv)
			{
				return mul(uv, float2x2 (cos(_angulo), -sin(_angulo), sin(_angulo), cos(_angulo)));
			}

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = fixed4(0,0,0,1);
				float2 uv = i.uv *2 -1;
				uv = rotar2d (-_Time.y *.01*PI, uv);
				float circulos = circulo(uv, float2(.8,0),.1);
				circulos += circulo(uv, float2(-.8,0),.1);
				circulos += circulo(uv, float2(0,.8),.1);
				circulos += circulo(uv, float2(0,-.8),.1);
				circulos += circulo(uv, float2(0.5656855,0.5656855),.1);
				circulos += circulo(uv, float2(-0.5656855,0.5656855),.1);
				circulos += circulo(uv, float2(0.5656855,-0.5656855),.1);
				circulos += circulo(uv, float2(-0.5656855,-0.5656855),.1);

				float circulointerior = step(_TamanoCirculoInterior, length(uv));
				float reflejoCirculoInterior = 1- step(_TamanoCirculoInterior, length(uv)) * 1- step(_TamanoCirculoInterior-.01, length(uv -.01)) ; 
				reflejoCirculoInterior = (1-circulointerior * 1-reflejoCirculoInterior)* 1-circulointerior ;
				float3 colRCI = reflejoCirculoInterior * _colorResplandor;
				//col.rgb = 1-circulointerior;
				col.rgb = 1-circulointerior >0 ? _colorCirculoInterior.rgb : col.rgb ;
				col.rgb = circulos > 0.15 ? _ColorCirculos.rgb :col.rgb; 
				//col.rgb = lerp (_ColorCirculos.rgb * circulos, _colorCirculoInterior.rgb *1- circulointerior,1- circulointerior);
				col.rgb = reflejoCirculoInterior >0 ? colRCI :col.rgb; 
				
				col.a =	circulos + 1-circulointerior >1 ? 1:circulos + 1-circulointerior;

                return col;
            }
            ENDCG
        }
    }
}

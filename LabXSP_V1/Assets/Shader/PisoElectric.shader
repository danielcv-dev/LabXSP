Shader "labxsp/PisoElectric"
{
	Properties
	{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Color("Color", Color) = (0,0,0,1)
		[Toggle] _MostrarCirculo("Mostrar fade del circulo", float)= 0
		_fadeCirculo("fadeout del circulo", Range(0,1)) = .5
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			CGPROGRAM
			#pragma surface surf Unlit

			float _MostrarCirculo, _fadeCirculo ;
		sampler2D _MainTex;
		float4 _Color;

			struct Input
			{
				float2 uv_MainTex;
			};
			#define time _Time.y * 0.15
			#define tau 6.2831853
			#define mod(x,y) x-y*floor(x/y)

			float2x2 makem2(float theta){float c = cos(theta);float s = sin(theta);return float2x2(c,-s,s,c);}

			float noise(  float2 x ){return tex2D(_MainTex, x*.01).x;}
			float fbm( float2 p)
			{	
				float z=2.;
				float rz = 0.;
				float2 bp = p;
				for (float i= 1.;i < 6.;i++)
				{
					rz+= abs((noise(p)-0.5)*2.)/z;
					z = z*2.;
					p = p*2.;
				}
				return rz;
			}

			float dualfbm(float2 p)
			{
				//get two rotated fbm calls and displace the domain
				float2 p2 = p*.7;
				float2 basis = float2(fbm(p2-time*1.6),fbm(p2+time*1.7));
				basis = (basis-.5)*.2;
				p += basis;
	
				//coloring
				return fbm(mul(makem2(time*0.2),p));
			}

			float circ(float2 p) 
			{
				float r = length(p);
				r = log(sqrt(r));
				return abs(mod(r*4.,tau)-3.14)*3.+.2;

			}

			void surf(Input IN, inout SurfaceOutput o)
			{
					float4 c = 0;
					float2 uv = IN.uv_MainTex - .5;
					uv*=4;
					float2 uv_circulo = uv;
					float rz = dualfbm(uv);

					//rings
					uv /= exp(mod(time*10.,3.14159));
					if (_MostrarCirculo ==1)
					{
						
						rz *= pow(abs((0.1-circ(uv))),.9);
					}
					else
					{
						//rz *= 4.15 ;
						rz *= lerp(pow(abs((0.1-circ(uv))),.9), 4.55,length(uv_circulo)*_fadeCirculo );
						//c.r = 1- length(uv_circulo)*_fadeCirculo;
					}


						//final color
					c.rgb = _Color.rgb/rz;
					c=pow(abs(c),(.99));

					o.Albedo = c.rgb;
					o.Alpha = c.a;
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

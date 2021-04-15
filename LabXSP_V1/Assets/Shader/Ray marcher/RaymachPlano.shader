Shader "Unlit/RaymachPlano"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Tex2 ("Texture 2", 2D) = "white"{}
		_PosLuz ("posicion de la luz", vector)= (0,1,0,0)
		_colorTest("colorTest", Color) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

			#define MAX_STEPS 100
			#define MAX_DIST 100
			#define SURF_DIST 1e-3
			static float4 Esfera1 = float4(0.0,0,4,1);

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float3 ro : TEXCOORD1;
				float3 hitPos : TEXCOORD2;
            };

            sampler2D _MainTex, _Tex2;
            float4 _MainTex_ST, _Tex2_ST;
			float4 _PosLuz;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.ro = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos,1));
				o.hitPos = v.vertex;

				return o;
            }
			float3 fancyCube(sampler2D sam, float3 rd, float s, float b)
			{
				float3 colx = tex2D(sam, 0.5 + s*rd.yz/rd.x).xyz;
				float3 coly = tex2D(sam, 0.5 + s*rd.zx/rd.y).xyz;
				float3 colz = tex2D(sam, 0.5 + s*rd.xy/rd.z).xyz;

				float3 n = rd*rd;
				return (colx* n.x + coly * n.y + colz*n.z)/(n.x+n.y+n.z);
			}
			float2 hash( float2 p ) { p=float2(dot(p,float2(127.1,311.7)),dot(p,float2(269.5,183.3))); return frac(sin(p)*43758.5453); }

			float2 voronoi(float2 x)
			{
				float2 n = floor(x);
				float2 f = frac(x);
				float3 m = 8.0;
				for( int j=-1; j<=1; j++ )
					for( int i=-1; i<=1; i++ )
					{
						float2  g = float2( float(i), float(j) );
						float2  o = hash( n + g );
						float2  r = g - f + o;
						float d = dot( r, r );
						if( d<m.x )	m = float3( d, o.x,o.y );
					}
				return float2 (sqrt(m.x),m.y + m.z);
			}
			float3 Fondo(float3 rd)
			{
				float3 c = 0;
				c += 0.5 * pow (fancyCube(_MainTex, rd, 0.05, 5).zyx,2);
				c += 0.2 * pow (fancyCube(_MainTex, rd, 0.10, 3).zyx,1.5);
				c += 0.8 * float3(0.8, 0.5, 0.6) * pow (fancyCube(_MainTex, rd, 0.1,0).xxx, 6); 
				float estrellas = smoothstep(0.3,0.7, fancyCube(_MainTex, rd,0.91,0).x);
				float3 n = abs(rd);
				n = n*n*n;
				float2 vxy = voronoi(50.0 *rd.xy);
				float2 vyz = voronoi(50.0 *rd.yz);
				float2 vzx = voronoi(50.0 *rd.zx);
				float2 r =(vyz*n.x + vzx*n.y + vxy*n.z) / (n.x+n.y+n.z);
				c += 0.9 * estrellas * clamp(1.0-(3.0+r.y*5.0)*r.x,0.0,1.0);

				c += 1.5 * c -0.2;
				c += float3(-0.05,0.1,0);
				float s = clamp(dot(rd, _WorldSpaceLightPos0),0.0,1.0);
				c += 0.4 * pow(s,5.0)* float3(1.0,0.7,0.6)*2.0;
				c += 0.4*pow(s,64.0)*float3(1.0,0.9,0.8)*2.0;
				return c;
			
			}
			
			/*float GetDist(float3 p)
			{
				float4 s = float4 (0,0,2,1);
				s.xz += sin(_Time.y)*3;
				float esferaDistancia = length(p-s.xyz)-s.w;
				float d = length(p)-.5;

				d = length(float2(length(p.xz) - .5, p.y))- .1; // crear la dona
				d = min (esferaDistancia,d);
				return d;
			}
			float Raymarch(float3 ro, float3 rd)
			{
				float dO = 0;
				float dS;
				for(int i = 0; i <MAX_STEPS;i++)
				{
					float3 p =  ro + dO * rd;
					dS = GetDist(p);
					dO += dS;
					if (dS < SURF_DIST || dO > MAX_DIST) break;
				}
				return dO;
			}
			float3 GetNormal(float3 p)
			{
				float2 e = float2(1e-2,0);
				float3 n = GetDist(p)- float3 (GetDist(p-e.xyy),GetDist(p-e.yxy),GetDist(p-e.yyx));
				return normalize(n);
			}
			float GetLight(float3 p)
			{
				float3 lightPos = _WorldSpaceLightPos0; //_PosLuz.xyz;;
				//lightPos.xz += float2(sin(_Time.y),sin(_Time.y));
				float3 l = normalize(lightPos-p);
				float3 n = GetNormal(p);
				float dif = dot (n,l);
				return dif;
			}*/
			float shpIntersect(float3 ro, float3 rd, float4 sph)
			{
				float3 oc = ro - sph.xyz;
				float b = dot( rd, oc );
				float c = dot( oc, oc ) - sph.w*sph.w;
				float h = b*b - c;
				if( h>0.0 ) h = -b - sqrt( h );
				return h;
			}
			
			float sphSoftShadow( float3 ro, float3 rd, float4 sph, float k )
			{
				float oc = sph.xyz - ro;
				float b = dot( oc, rd );
				float c = dot( oc, oc ) - sph.w*sph.w;
				float h = b*b - c;
				return (b<0.0) ? 1.0 : 1.0 - smoothstep( 0.0, 1.0, k*h/b );
			}    
			float3 sphNormal( float3 pos, float4 sph )
			{
				return (pos - sph.xyz)/sph.w;    
			}
			float rayTrace(float3 ro, float3 rd)
			{
				return shpIntersect(ro,rd,Esfera1);
			}
			float map (float3 pos)
			{
				float r = pos.xz - Esfera1.xz;
				float h = 1.0-2.0/(1.0 + 0.3*dot(r,r));
				return pos.y - h;
			}
			float rayMarch(float3 ro, float3 rd, float tmax)
			{
				float t = 0;
				// delimitar plano
				float h = (1.0-ro.y)/rd.y;
				if( h>0.0 ) t=h;

				// ray mach
				for( int i=0; i<20; i++ )    
				{        
					float3 pos = ro + t*rd;
					float h = map( pos );
					if( h<0.001 || t>tmax ) break;
					t += h;
				}
				return t;  
			}
			float3 render(float3 ro, float3 rd)
			{
				float3 col = 0;
				col.rgb = Fondo(rd);
				float  t = rayTrace(ro,rd);
				if (t>0.0) // planeta
				{
					float3 mat = .18;
					float3 pos = ro+ t*rd;
					float3 nor = sphNormal(pos, Esfera1);

					float am = 0.1 * _Time.y;
					float2 pr = float2 (cos (am), sin(am));
					float3 tnor = nor;
					tnor.xz = mul (float2x2(pr.x,-pr.y,pr.y,pr.x), tnor.xz);

					float am2 = 0.08 * _Time.y -1*(1 - nor.y * nor.y);
					pr =float2 (cos(am2),sin(am2));
					float3 tnor2 = nor;
					tnor2.xz = mul(float2x2(pr.x,-pr.y,pr.y,pr.x), tnor2.xz);

					float3 ref = reflect(rd, nor);
					//col = ref;
					float fre = clamp(1 + dot (nor, rd),0,1);
					float l = fancyCube(_Tex2, tnor, 0.03,0).x;
					l+= -0.1 + 0.3 * fancyCube(_Tex2,tnor, 8.0,0.0).x;

					float3 sea = lerp (float3 (0.0,0.07,0.2),float3(0.0,0.01,0.3), fre); // mar
					sea *= 0.15;

					float3 land = float3 (0.02,0.04,0.0); // tierra
					land = lerp (land, float3(0.05,0.1,0.0), smoothstep(0.4,1.0,fancyCube(_Tex2,tnor,0.1,0).x));
					land *= fancyCube(_Tex2,tnor,0.3,0).xyz;
					land *= 0.5;

					float los = smoothstep(0.45,0.46,l);
					mat = lerp (sea,land,los);
					float3 wrap = -1.0 + 2.0 * fancyCube(_MainTex,tnor2.xzy,0.025,0).xyz;
					
					float cc1 = fancyCube(_MainTex, tnor2 + 0.2 * wrap, 0.05,0).y;
					float clouds =smoothstep(0.3, 0.6, cc1);

					mat = lerp(mat, 0.93*0.15, clouds);

					float dif = clamp(dot(nor, _WorldSpaceLightPos0),0.0,1.0);
					mat *= 0.8;
					float3 lin = float3 (3.0,2.5,2.0) * dif;
					lin += 0.01;
					col = mat* lin;
					col = pow (col, 0.4545);
					col += 0.6 * fre * fre * float3(0.9,0.9,1)* (.3 +.7*dif);

					
					float spe = clamp( dot(ref,_WorldSpaceLightPos0), 0.0, 1.0 );
					float tspe = pow( spe, 3.0 ) + 0.5*pow( spe, 16.0 );
					col += (1.0-0.5*los)*clamp(1.0-2.0*clouds,0.0,1.0)*0.3*float3(0.5,0.4,0.3)*tspe*dif;
				}
				/*
				float tmax = 2.0;
				if( t>0.0 ){ tmax = t;} 
				t = rayMarch( ro, rd, tmax );

				if( t<tmax )
				{
					col.r = t;

					float3 pos = ro + t * rd;
					//col.r = t;
					float2 scp = sin(2.0*6.2831*pos.xz);
            
					float3 wir = float3(0,0, 0.0 );
					wir += 1.0*exp(-12.0*abs(scp.x));
					//col+= wir;
					wir += 1.0*exp(-12.0*abs(scp.y));
					wir += 0.5*exp( -4.0*abs(scp.x));
					wir += 0.5*exp( -4.0*abs(scp.y));
					wir *= 0.2 + 1.0*sphSoftShadow( pos, _WorldSpaceLightPos0, Esfera1, 4.0 );
					//col+= wir;
					//col += wir*0.5*exp( -0.05*t*t );
				}*/
				return col;
			}
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = 0;
				//float2 uv = i.uv -.5;
				float3 ro = i.ro;
				float3 rd = normalize(i.hitPos-ro);
				/*float d = Raymarch(ro,rd);
				if (d<MAX_DIST)
				{
					float3 p = ro +rd *d;
					
					//float3 n = GetNormal(p);
					float dif = GetLight(p);
					//col.rgb = dif;

				}
				else
				{
					//col.rgb = Fondo(rd);
				}*/

				col.rgb = render(ro,rd);
                return col;
            }
            ENDCG
        }
    }
}

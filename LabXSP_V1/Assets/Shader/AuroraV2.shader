Shader "Custom/AuroraV2"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RotacionX ("RotacionXCamara", Range(0,1.5)) = 0
		_RotacionY ("RotacionYCamara", Range(-1,1)) = 0
		_tamanoEstrellas ("Tamaño de estrellas", Range(.00001,.009)) = 0.2
		_fadeLineaVertical("fade Linea Vertical", float) =0 
		_fadeLineaHorizontal("fade de linea horizontal", float) = .4
		_ColorX ("Color X", Range(0,5)) = 0
		_ColorY ("Color Y", Range(0,5)) = 0
		_ColorZ ("Color Z", Range(0,5)) = 0
		_test("test", float)=0

    }
    SubShader
    {
		Tags { "RenderType"="Opaque" "Queue" ="Transparent"}
        CGPROGRAM
        #pragma surface surf Unlit alpha:fade
		float _RotacionX,_RotacionY,_tamanoEstrellas,_fadeLineaVertical,_fadeLineaHorizontal,  _test;
		float _ColorX, _ColorY, _ColorZ;
        sampler2D _MainTex;
		float4 _Color;
		#define PI 3.14159265359
        struct Input
        {
            float2 uv_MainTex;
        };
		#define time _Time.y//_test //_Time.y

		float2x2 mm2(in float a){float c = cos(a), s = sin(a);return float2x2(c,s,-s,c);}
		float2x2 m2 = float2x2(0.95534, 0.29552, -0.29552, 0.95534);
		float tri(in float x){return clamp(abs(frac(x)-.5),0.01,0.49);}
		float2 tri2(in float2 p){return float2(tri(p.x)+tri(p.y),tri(p.y+tri(p.x)));}

		float triNoise2d(in float2 p, float spd)
		{
			float z=1.8;
			float z2=2.5;
			float rz = 0.;
			p = mul(p, mm2(p.x*0.06));
			float2 bp = p;
			for (float i=0.; i<5.; i++ )
			{
				float2 dg = tri2(bp*1.85)*.75;
				dg = mul(dg, mm2(time*spd));
				p -= dg/z2;

				bp *= 1.3;
				z2 *= .45;
				z *= .42;
				p *= 1.21 + (rz-1.0)*.02;
        
				rz += tri(p.x+tri(p.y))*z;
				p= mul (p,-m2);
			}
			return clamp(1./pow(rz*29., 1.3),0.,.55);
		}

		float hash21(float2 n){ return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453); }
		float4 aurora(float3 ro, float3 rd,float2 uv)
		{
			float4 col = 0;
			float4 avgCol = 0;
    
			for(float i=0.;i<50.;i++)
			{
				float of = 0.006*hash21(uv.xy)*smoothstep(0.,15., i);
				float pt = ((.8+pow(i,1.4)*.002)-ro.y)/(rd.y*2.+0.4);
				pt -= of;
    			float3 bpos = ro + pt*rd;
				float2 p = bpos.zx;
				float rzt = triNoise2d(p, 1.06);
				float4 col2 = float4(0,0,0, rzt);
				col2.rgb = (sin(1.-float3(_ColorX,_ColorY, _ColorZ)+i*0.043)*0.5+0.5)*rzt;
				//col2.rgb = (sin(1.-float3(2.15,-.5, 1.2)+i*0.043)*0.5+0.5)*rzt;

				avgCol =  lerp(avgCol, col2, .5);
				col += avgCol*exp2(-i*0.065 - 2.5)*smoothstep(0.,5., i);
        
			}
    
			col *= (clamp(rd.y*15.+.4,0.,1.));
    

			return col*1.8;

		}
		///_________
		float random(float2 uv, float variante)
		{
			return frac(sin (dot (uv.xy, float2(12.9898, 78.233 + variante)))* 43758.5453123);
		}
		float estrellas(float2 uv, float tamanoEstrella, float _random) // tamaño de estrella tiene que ser mayor a .2
		{
			uv = uv *2 -1;
			float2 cuadricula = frac(uv*20);
			float2 id = floor(uv*20);
			float randomEstrella = step(random(id, _random),.002); // no llenar la cuadricula de estrellas, solo una parte
			float estrella = step(length(cuadricula-.5), .011) ;
			return estrella * randomEstrella;
		}
		float linea(float uv, float tamano)
		{
			float c = 0;
			c = smoothstep(.5+tamano, .5, uv.x) * smoothstep(.5-tamano, .5, uv);

			return c;
		}
			//______________
        void surf (Input IN, inout SurfaceOutput o)
        {

			float2 q = IN.uv_MainTex;
			float2 p = q - 0.5;
			//p.x*=iResolution.x/iResolution.y;
    
			float3 ro = float3(0,0,-6.7);
			float3 rd = normalize(float3(p,1.3));
			float2 rd_uv = rd.xy;
			float2 mo = float2(_RotacionX * PI,-_RotacionY * PI); //iMouse.xy / iResolution.xy-.5;
			//mo = (mo == float2(-.5, -.5)) ? mo = float2(-0.1,0.1) : mo;
			//mo.x *= iResolution.x/iResolution.y;
			rd.yz = mul(rd.yz,mm2(mo.y));
			rd.xz = mul(rd.xz, mm2(mo.x + sin(time*0.05)*0.2));
    
			float3 col = 0;
			float3 brd = rd;
			float fade = smoothstep(0.,0.01,abs(brd.y))*0.1+0.9;
    
    
			if (rd.y > 0.){
				float4 aur = smoothstep(0.,1.5,aurora(ro,rd, IN.uv_MainTex))*fade;
				col = col*(1.-aur.a) + aur.rgb;
				//
				float capaEstrellas1 = estrellas(rd,_tamanoEstrellas		,3);
				float capaEstrellas2 = estrellas(rd+float2(.002,.009),_tamanoEstrellas + 0.02	,1);
				float capaEstrellas3 = estrellas(rd-float2(.005,.019),_tamanoEstrellas + 0.04	,5);
				float capaEstrellas4 = estrellas(rd,_tamanoEstrellas		,4);
				col.rgb = col.rgb + float3(capaEstrellas1,capaEstrellas1,capaEstrellas1);
				col.rgb = col.rgb + float3(capaEstrellas2,capaEstrellas2,capaEstrellas2);
				col.rgb = col.rgb + float3(capaEstrellas3,capaEstrellas3,capaEstrellas3);
				col.rgb = col.rgb + float3(capaEstrellas4,capaEstrellas4,capaEstrellas4);

				//
			}
			else //Reflections
			{
				rd.y = abs(rd.y);
				float4 aur = smoothstep(0.0,2.5,aurora(ro,rd, IN.uv_MainTex));
				col = col*(1.-aur.a) + aur.rgb;
				float3 pos = ro + ((0.5-ro.y)/rd.y)*rd;
				float nz2 = triNoise2d(pos.xz*float2(.5,.7), 0.);
				col += lerp(float3(0.2,0.25,0.5)*0.08,float3(0.3,0.3,0.5)*0.7, nz2*0.4);
		//col.r = step(.2, length(rd.xy));

			}

    
			float4 c = float4(col, 1.0);

			c.a = 1- linea(rd.y-_fadeLineaHorizontal,.2); //fade de parte superior e inferior de la esfera
			//c.a *= 1- linea(rd_uv.x+_fadeLineaVertical,.08);


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

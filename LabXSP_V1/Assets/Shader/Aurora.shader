Shader "labxsp/Aurora"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RotacionX ("RotacionXCamara", Range(0,1)) = 0
		_RotacionY ("RotacionYCamara", Range(0,1)) = 0
		_Test ("test", Range(0,5)) =0
		_TestRO ("test ro",Range(0,1)) =0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" ="Transparent" }
        CGPROGRAM
        #pragma surface surf Unlit alpha:fade
		#define PI 3.14159265359
        
        sampler2D _MainTex;
		float _RotacionX, _RotacionY,_Test, _TestRO;
		float2x2 mm2(float a){float c = cos(a), s = sin(a);return float2x2(c,-s,s,c);}
		float2x2 m2 = float2x2(0.95534, 0.29552, -0.29552, 0.95534);
		float tri(float x){return clamp(abs(frac(x)-.5),0.01,0.49);}
		float2 tri2(float2 p){return float2(tri(p.x)+tri(p.y),tri(p.y+tri(p.x)));}
        struct Input
        {
            float2 uv_MainTex;
			float3 worldPos;
        };

		float hash21(float2 n,float c){ return frac(sin(dot(n, float2(12.9898, 4.1414))) * (43758.5453+ c) ); }
		float triNoise2d(float2 p, float spd)
		{
			float z=1.8;
			float z2=2.5;
			float rz = 0.;
			p = mul(p,mm2(p.x*0.06));
			float2 bp = p;
			for (float i=0.; i<5.; i++ )
			{
				float2 dg = tri2(bp*1.85)*.75;
				dg = mul(dg,mm2(_Time.y*spd));
				p -= dg/z2;

				bp *= 1.3;
				z2 *= .45;
				z *= .42;
				p *= 1.21 + (rz-1.0)*.02;
        
				rz += tri(p.x+tri(p.y))*z;
				p= mul(p,-m2);
			}
			return clamp(1./pow(rz*29., 1.3),0.,.55);
		}

		float4 aurora (float3 ro, float3 rd, float varianteRandom)
		{
			float4 col = float4(0,0,0,0);
			float4 avgCol = float4(0,0,0,0);
			for(float i = 0.0; i < 50.0; i++)
			{
				float of = 0.006 * hash21(rd.xy,varianteRandom)* smoothstep(0.0, 15, i);
				float pt = ((.8+pow(i,1.4)*.002)- ro.y)/(rd.y*2.+0.4);
				pt -= of;
				float3 bpos = ro + pt *rd;
				float2 p = bpos.zx;
				float rzt =triNoise2d(p, .23);										// cambiar 1.26 a 0.26
				float4 col2 = float4(0,0,0,rzt);
				col2.rgb = (sin(1.0-float3(2.15,-.5,1.2)+i *0.043)*0.5+0.5)*rzt;
				avgCol = lerp(avgCol, col2, .6);
				col += avgCol * exp2(-i * 0.065 - 2.5)* smoothstep(0.0,5.0,i);
			}
			col *= (clamp(rd.y*15.0 + 0.4,0.0,1.0));
			return col * 1.8;
		}
        void surf (Input IN, inout SurfaceOutput o)
        {			
			float4 c = float4 (0,0,0,1);
			float2 uv = IN.uv_MainTex;
			float2 p = uv ;
			float3 ro = float3(0,0,-6.3);
			float3 rd = float3(0,0,0);
			float2 mo = float2(-_RotacionX,-_RotacionY);
			// move space from the center to the vec3(0.0)
			rd -= float3 (_TestRO, _TestRO,_TestRO);
			// rotate the space
			rd = normalize (float3(p.x,p.y,_Test));
			rd.yz = mul (rd.yz, mm2(mo.y * PI));
			rd.xz = mul (rd.xz, mm2(mo.x * PI));
			// move it back to the original place						
			rd += float3 (_TestRO, _TestRO,_TestRO);


			float3 brd = float3(rd);
			float fade = smoothstep(0,0.01,abs(brd.y)) * 0.1 +0.9;
			

			if (rd.y > 0.)
			{
				c.r = step(.1, length(rd.xy));
				float4 aur = smoothstep(0.0,1.5, aurora(ro, rd, (IN.worldPos.y + IN.worldPos.x + IN.worldPos.z))) * fade;
				c.rgb = c.rgb * (1.0 - aur.a) + aur.rgb;
				c.a = lerp(c.a, aur.a,.2);

			}
			else
			{
				rd.y = abs(rd.y);
				float4 aur = smoothstep(0.0,2.5,aurora(ro, rd, (IN.worldPos.y + IN.worldPos.x + IN.worldPos.z)));
				c.rgb = c.rgb * (1 - aur.a) + aur.rgb; 
			}
			//c.a *= 1- smoothstep(.07,.01,IN.uv_MainTex.x);
			//c.a *= 1- smoothstep(.91,.97,IN.uv_MainTex.x);
			//c.a *= 1- smoothstep(.01,.99,IN.uv_MainTex.y);
			//c.a *= 1-smoothstep(.65,1.,IN.uv_MainTex.x);
			//c.a *= 1-smoothstep(.65,.0,IN.uv_MainTex.x);
			//c.a = lerp(c.a,1-smoothstep(.55,1.,IN.uv_MainTex.x),.95);
			//c.a *= lerp(c.a,1-smoothstep(.45,.0,IN.uv_MainTex.x),.95);
			//c.a *= lerp(c.a,1-smoothstep(.91,.97,IN.uv_MainTex.y),.3);
			//c.a *= lerp(c.a,1-smoothstep(.07,.01,IN.uv_MainTex.y),.5);
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

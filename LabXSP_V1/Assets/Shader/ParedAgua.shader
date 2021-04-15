Shader "labxsp/ParedAgua"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ColorAgua ("Color del agua", Color) = (1,1,1,1)
		_IntensidadMovimientoOnda("Intensidad de movimiento de onda", Range(0.00,0.01)) = 0.001
		_IntensidadLuzExterna ("Intensidad de refleccion de luz externa", Range(0,1)) = 1
    }
    SubShader
    {
		GrabPass {"_GrabTexture"}
        Tags { "RenderType"="Opaque" "Queue" ="Transparent" }
		LOD 100
        CGPROGRAM
        #pragma surface surf Unlit alpha:fade
		#define PI 3.1415926535897932

		//speed
		#define speed 0.2
		#define speed_x 0.3
		#define speed_y 0.3

        // refraction
		#define emboss 0.50
		#define intensity 2.4
		#define steps 8
		#define frequency  6.0
		#define angle  7

		#define delta 60

        sampler2D _MainTex,_GrabTexture;
		float _IntensidadMovimientoOnda, _IntensidadLuzExterna;
		float4 _ColorAgua;
        struct Input
        {
            float2 uv_MainTex;
			float4 screenPos;
        };
		
		float col(float2 coord,float time) // genera las ondas 
		{
			float delta_theta = 2.0 * PI / float(angle);
			float col = 0.0;
			float theta = 0.0;
			for (int i = 0; i < steps; i++)
			{
				float2 adjc = coord;
				theta = delta_theta*float(i);
				adjc.x += cos(theta)*time*speed + time * speed_x;
				//adjc.y -= sin(theta)*time*speed - time * speed_y;
				col = col + cos( (adjc.x*cos(theta) - adjc.y*sin(theta))*frequency)*intensity;
			}

			return cos(col);
		}


        void surf (Input IN, inout SurfaceOutput o)
        {
			//float4 grabUv = UNITY_PROJ_COORD(ComputeGrabScreenPos(IN.screenPos)); 
			float4 grabUv = UNITY_PROJ_COORD(IN.screenPos); 
			float time = _Time.y; 
			float4 c = float4 (0,0,0,1);
			float2 uv = IN.uv_MainTex, c1 = uv, c2 = uv; 
			float cc1 = col(c1,time);



			float2 projUV2 = grabUv.xy / grabUv.w;
			float2 offs =  float2(projUV2.x + (cc1 *_IntensidadMovimientoOnda) ,projUV2.y + (cc1 * _IntensidadMovimientoOnda) ) ;

			c.rgb = tex2D(_GrabTexture, offs).rgb; //c = tex2Dproj(_GrabTexture, grabUv);
			c.rgb = lerp (c.rgb, _ColorAgua.rgb, _ColorAgua.a);

			//c.r = cc1;
			o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
		
		
		half4 LightingUnlit(SurfaceOutput s, half3 lightDir, half atten)
		{
			fixed4 c;
			c.rgb = s.Albedo.rgb * .1;
			c.a = s.Alpha * _IntensidadLuzExterna ;
			return c;		
		}
        ENDCG
    }
    FallBack "Diffuse"
}

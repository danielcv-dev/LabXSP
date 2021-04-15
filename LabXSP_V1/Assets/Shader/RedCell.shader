Shader "labxsp/RedCell"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Camara("camara rotacion", vector) = (0,0,0,0)

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf Unlit

        
        sampler2D _MainTex;
		struct Input
        {
            float2 uv_MainTex;
        };

		#define mod x-y*floor(x/y)
		float4 _Camara;

static float kFarClip=1000.0;
static float kZRepeat = 5.0;

float2 GetWindowCoord(  in float2 vUV );
float3 GetCameraRayDir(  in float2 vWindow,  in float3 vCameraPos,  in float3 vCameraTarget );
float3 GetSceneColour( in float3 vRayOrigin,  in float3 vRayDir );
float3 ApplyPostFX(  in float2 vUV,  in float3 vInput );



static float fPulse = 0.0;
static float fDPulse = 0.0;

static  float kExposure = 1.5;

static  float3 vLightColour = float3(1.0, 0.01, 0.005);

static float3 vRimLightColour = vLightColour * 0.5;
static float3 vAmbientLight = vLightColour * 0.05;
static float3 vEmissiveLight = vLightColour * 1.0;
	
static float kFogDensity = 0.0075;
static float3 vFogColour = float3(1.0, 0.05, 0.005) * 0.25 * 10.0;

float GetGlobalTime()
{
	float fStartTime = 90.0;
    return fStartTime + _Time.y;
}

float GetPulseTime()
{
    float fGlobalTime = GetGlobalTime();
    
	float s= sin(fGlobalTime * 2.0);
	fPulse = s * s;
	fDPulse = cos(fGlobalTime * 2.0);
	return fGlobalTime + fPulse * 0.2;
}

float GetCameraZ()
{
    return GetPulseTime() * 20.0;
}

float3x3 SetRot( in float3 r )
{
    float a = sin(r.x); float b = cos(r.x); 
    float c = sin(r.y); float d = cos(r.y); 
    float e = sin(r.z); float f = cos(r.z); 

    float ac = a*c;
    float bc = b*c;

    return float3x3( d*f,      d*e,       -c,
                 ac*f-b*e, ac*e+b*f, a*d,
                 bc*f+a*e, bc*e-a*f, b*d );
}

float3 TunnelOffset( float z )
{
	float r = 20.0;
	float3 vResult = float3( sin(z * 0.0234)* r, sin(z * 0.034)* r, 0.0 );
	return vResult;
}

        void surf (Input IN, inout SurfaceOutput o)
        {

			float2 vUV = IN.uv_MainTex;// fragCoord.xy / iResolution.xy;

			float2 vMouse = .5;// iMouse.xy / iResolution.xy;

			float fCameraZ = GetCameraZ();

			float3 vCameraPos = float3(0.0, 0.0, 0.0);
			vCameraPos.z += fCameraZ;
			vCameraPos += TunnelOffset(fCameraZ);
	
			float3 vCameraTarget = (0.0);

			float fAngle = 0.0;

			//if(iMouse.z > 0.0)
			//{
			//	fAngle = vMouse.x * 3.1415 * 2.0;
			//}
	
			float fTargetLookahead = 40.0;
	
			float fCameraTargetZ = fCameraZ + fTargetLookahead * cos(fAngle); 
	
			vCameraTarget.z += fCameraTargetZ;
			vCameraTarget += TunnelOffset(fCameraTargetZ);
	
			vCameraTarget.x += sin(fAngle) * fTargetLookahead;

			// camera shake
			float3 vShake = tex2D(_MainTex,IN.uv_MainTex).rgb;// (textureLod(iChannel0, float2(GetPulseTime() * 0.05, 0.0), 0.0).rgb * 2.0 - 1.0);
			vCameraTarget += vShake * fDPulse * 0.02 * length(vCameraTarget - vCameraPos);
	
			float fFOV = 0.5;
	
			float3 vRayOrigin = vCameraPos;	
			float3 vRayDir = GetCameraRayDir( GetWindowCoord(vUV) * fFOV, vCameraPos, vCameraTarget );
		
			float3 vResult = GetSceneColour(vRayOrigin, vRayDir);
	
			float3 vFinal = ApplyPostFX( vUV, vResult );
	
			float4  c= float4(0,0,0,1);
			c.rgb = vResult;
			//c = float4(vFinal, 1.0);
		
			o.Albedo = c.rgb;
            o.Alpha = c.a;

		}

// CAMERA

float2 GetWindowCoord( in float2 vUV )
{
	float2 vWindow = vUV * 2.0 - 1.0;
	//vWindow.x *= iResolution.x / iResolution.y;

	return vWindow;	
}

float3 GetCameraRayDir(  in float2 vWindow,  in float3 vCameraPos,  in float3 vCameraTarget )
{
	float3 vForward = normalize(vCameraTarget - vCameraPos);
	float3 vRight = normalize(cross(float3(0.0, 1.0, 0.0), vForward));
	float3 vUp = normalize(cross(vForward, vRight));
							  
	float3 vDir = normalize(vWindow.x * vRight + vWindow.y * vUp + vForward * 2.0);

	return vDir;
}

// POSTFX

float3 ApplyVignetting(  in float2 vUV,  in float3 vInput )
{
	float2 vOffset = (vUV - 0.5) * sqrt(2.0);
	
	float fDist = dot(vOffset, vOffset);
	
	float kStrength = 1.0;
	
	float fShade = lerp( 1.0, 1.0 - kStrength, fDist );	

	return vInput * fShade;
}

float3 ApplyTonemap(  in float3 vLinear )
{	
	return (1.0 - exp2(vLinear * -kExposure));	
}

float3 ApplyGamma(  in float3 vLinear )
{
	 float kGamma = 2.2;

	return pow(vLinear, (1.0/kGamma));	
}

float3 ApplyPostFX(  in float2 vUV,  in float3 vInput )
{
	float3 vTemp = vInput;
	
	vTemp = ApplyVignetting( vUV, vTemp );	
	
	vTemp = ApplyTonemap(vTemp);
	
	vTemp = ApplyGamma(vTemp);

	return vTemp;
}
	
// RAYTRACE

struct C_Intersection
{
	float3 vPos;
	float fDist;	
	float3 vNormal;
	float3 vUVW;
	float fObjectId;
};

float GetCellShapeDistance(  in float3 vPos  )
{	
	 float3 vParam = float3(1.0, 0.4, 0.4);

	float r = length(vPos.xz);
	float2 vClosest = float2(clamp(r - vParam.x, 0.0, vParam.x), vPos.y);
	float unitr = clamp(r / vParam.x, 0.0, 1.0);
	float stepr = 3.0 * unitr * unitr - 2.0 * unitr * unitr * unitr;
  	return length(vClosest)-(vParam.y) - stepr * vParam.y * 0.5;

}

float3 WarpCellDomain(  in float3 vPos )
{
	float3 vResult = vPos;
	vResult.y += (vPos.x * vPos.x - vPos.z * vPos.z) * 0.05;
	return vResult;
}

float GetCellDistance(  in float3 vPos,  in float fSeed )
{
	float3 vCellPos = vPos;
	
	float3 vRotSpeed = float3(0.0, 1.0, 2.0) + float3(1.0, 2.0, 3.0) * fSeed;
	
	float3x3 mCell = SetRot(vRotSpeed * GetGlobalTime());
	
	vCellPos = mul( vCellPos, mCell);
	
	vCellPos = WarpCellDomain(vCellPos);
	
	float fCellDist = GetCellShapeDistance(vCellPos);
	
	return fCellDist;	
}

float GetCellProxyDistance(  in float3 vPos,  in float fSeed )
{
	return length(vPos) - 1.4;
}

float GetSegment(  in float fPos,  in float fRepeat )
{
	float fTilePos = (fPos / fRepeat) + 0.5;
	return floor(fTilePos);
}

float3 WarpTunnelDomain(  in float3 vPos )
{
	return vPos - TunnelOffset(vPos.z);
}

float GetTileSeed(  float fTile )
{
	//return frac(sin(fTile * 123.4567) * 1234.56);	

    // https://www.shadertoy.com/view/4djSRW
    // Hash without Sine - Dave_Hoskins
	#define MOD3 float3(.1031,.11369,.13787)
    
    float p = fTile;
    
	float3 p3  = frac((p) * MOD3);
    p3 += dot(p3, p3.yzx + 19.19);
    return frac((p3.x + p3.y) * p3.z);
}

float3 GetCellPos(  float fTile,  float fSeed )
{
	float fTileZ = fTile * kZRepeat;
	float fOffsetRadius = 2.0 + fSeed * 1.5;
	
	return float3( fOffsetRadius * sin(fSeed * 3.14 * 2.0), fOffsetRadius * cos(fSeed * 3.14 * 2.0), fTileZ);
}


float GetSceneDistanceMain( out float4 vOutUVW_Id,  in float3 vPos )
{
	vOutUVW_Id = float4(0.0, 0.0, 0.0, 0.0);
	float fOutDist = kFarClip;
	
	float3 vCellDomain = vPos;
			
	vCellDomain.z -= GetPulseTime() * 30.0 + fPulse * 0.5;
		
	float fCurrTile = GetSegment(vCellDomain.z, kZRepeat);

	// approximate position of adjacent cell
	{
		float fTileMid = (fCurrTile) * kZRepeat;
		float fTile = fCurrTile;
		if(vCellDomain.z > fTileMid)
		{
			fTile++;
		}
		else
		{
			fTile--;
		}
		float fSeed = GetTileSeed(fTile);

		float3 vCellPos = GetCellPos(fTile, fSeed);
		float3 vCurrCellDomain = vCellDomain - vCellPos;

		float4 vCellUVW_Id = float4(vCurrCellDomain.xzy, 2.0);
			
		float fCellDist = GetCellProxyDistance( vCurrCellDomain, fSeed );
		
	
		if( fCellDist < fOutDist )
		{
			fOutDist = fCellDist;
			vOutUVW_Id = vCellUVW_Id;
		}
	}
	{
		float fTile = fCurrTile;				
		float fSeed = GetTileSeed(fTile);

		float3 vCellPos = GetCellPos(fTile, fSeed);
		float3 vCurrCellDomain = vCellDomain - vCellPos;
			
		float4 vCellUVW_Id = float4(vCurrCellDomain.xzy, 2.0);
		
		float fCellDist = GetCellDistance( vCurrCellDomain, fSeed );
		
	
		if( fCellDist < fOutDist )
		{
			fOutDist = fCellDist;
			vOutUVW_Id = vCellUVW_Id;
		}
	}
	
	float fNoiseMag = 0.01;
		
	float s =sin(vPos.z * 0.5) * 0.5 + 0.5;
	float s2 = s * s;
	float fWallDist = 6.0 - length(vPos.xy) + (2.0 - s2 * 2.0);
		
	if( fWallDist < fOutDist )
	{
		fOutDist = fWallDist;
		vOutUVW_Id = float4(atan2(vPos.x, vPos.y) * (2.0 / radians(360.0)), vPos.z * 0.05, 0.0, 1.0);
		
		fNoiseMag = 0.1;
	}
		
	// noise
	float fSample = 0.0;// textureLod(iChannel0, vOutUVW_Id.xy, 0.0).r;
	fOutDist -= fSample * fNoiseMag;
	
	return fOutDist;	
}

float GetSceneDistance( out float4 vOutUVW_Id,  in float3 vPosIn )
{
	float3 vPos = vPosIn;

	vPos = WarpTunnelDomain(vPos);

	return GetSceneDistanceMain(vOutUVW_Id, vPos);
}

float3 GetSceneNormal( in float3 vPos)
{
     float fDelta = 0.01;

    float3 vDir1 = float3( 1.0, -1.0, -1.0);
    float3 vDir2 = float3(-1.0, -1.0,  1.0);
    float3 vDir3 = float3(-1.0,  1.0, -1.0);
    float3 vDir4 = float3( 1.0,  1.0,  1.0);
	
    float3 vOffset1 = vDir1 * fDelta;
    float3 vOffset2 = vDir2 * fDelta;
    float3 vOffset3 = vDir3 * fDelta;
    float3 vOffset4 = vDir4 * fDelta;

	float4 vUnused;
    float f1 = GetSceneDistance( vUnused, vPos + vOffset1 );
    float f2 = GetSceneDistance( vUnused, vPos + vOffset2 );
    float f3 = GetSceneDistance( vUnused, vPos + vOffset3 );
    float f4 = GetSceneDistance( vUnused, vPos + vOffset4 );
	
    float3 vNormal = vDir1 * f1 + vDir2 * f2 + vDir3 * f3 + vDir4 * f4;	
		
    return normalize( vNormal );
}

void TraceScene( out C_Intersection outIntersection,  in float3 vOrigin,  in float3 vDir )
{	
	float4 vUVW_Id = (0.0);		
	float3 vPos = (0.0);
	
	float t = 0.01;
	 int kRaymarchMaxIter = 96;
	for(int i=0; i<kRaymarchMaxIter; i++)
	{
		vPos = vOrigin + vDir * t;
		float fDist = GetSceneDistance(vUVW_Id, vPos);		
		t += fDist;
		if(abs(fDist) < 0.001)
		{
			break;
		}		
		if(t > 200.0)
		{
			t = kFarClip;
			vPos = vOrigin + vDir * t;
			vUVW_Id = (0.0);
			break;
		}
	}
	
	outIntersection.fDist = t;
	outIntersection.vPos = vPos;
	outIntersection.vNormal = GetSceneNormal(vPos);
	outIntersection.vUVW = vUVW_Id.xyz;
	outIntersection.fObjectId = vUVW_Id.w;
}

// SCENE MATERIALS

float3 SampleTunnel( float2 vUV )
{
    // Sample texture twice to remove seam when UV co-ords wrap back to 0
    
	// sample a lower mip for more of a 'subsurface scattering' effect
    float mipBias = 4.0;

    // Sample the texture with UV modulo seam at the bottom
    float3 vSampleA =0.0;// texture(iChannel0, vUV, mipBias).rgb;
    
    float2 vUVb = vUV;
    vUVb.x = frac(vUVb.x + 0.5) - 0.5; // move UV modulo seam
    
    // Sample the texture with UV modulo seam on the left
    float3 vSampleB =0.0;// texture(iChannel0, vUVb, mipBias).rgb;
    
    // Blend out seam around zero
    float fBlend = abs( frac( vUVb.x ) * 2.0 - 1.0 );
    
    return lerp(vSampleA, vSampleB, fBlend);
}

void GetSurfaceInfo(out float3 vOutAlbedo, out float3 vEmissive,  in C_Intersection intersection )
{
	vEmissive = (0.0);
		
	if(intersection.fObjectId == 1.0)
	{
		vOutAlbedo = float3(1.0, 0.01, 0.005) * 0.5;
		
		float3 vSample = SampleTunnel( intersection.vUVW.xy );
		
		vSample = vSample * vSample;
		
		vEmissive =  vSample.r * vEmissiveLight;
	}
	else if(intersection.fObjectId == 2.0)
	{
		vOutAlbedo = float3(1.0, 0.01, 0.005);
	}
}

float GetFogFactor( in float fDist)
{
	return exp(fDist * -kFogDensity);	
}

float3 GetFogColour( in float3 vDir)
{
	return vFogColour;	
}

void ApplyAtmosphere(inout float3 vColour,  in float fDist,  in float3 vRayOrigin,  in float3 vRayDir)
{		
	float fFogFactor = GetFogFactor(fDist);
	float3 vFogColour = GetFogColour(vRayDir);			
	vColour = lerp(vFogColour, vColour, fFogFactor);	
}

// TRACING LOOP

	
float3 GetSceneColour( in float3 vRayOrigin,  in float3 vRayDir )
{
	float3 vColour = (0.0);
	
	{	
		C_Intersection intersection;				
		TraceScene( intersection, vRayOrigin, vRayDir );

		{		
			float3 vAlbedo;
			float3 vBumpNormal;
			float3 vEmissive;
			
			GetSurfaceInfo( vAlbedo, vEmissive, intersection );			
					
			float3 vDiffuseLight = vAmbientLight;
			
			// rim light
			vDiffuseLight += clamp(dot(vRayDir, intersection.vNormal) + 0.5, 0.0, 1.0) * vRimLightColour;
			
			vColour = vAlbedo * vDiffuseLight + vEmissive;			
			
			ApplyAtmosphere(vColour, intersection.fDist, vRayOrigin, vRayDir);		
			
		}			

	}
	
	return vColour;
}
		/* para vr no funciono
		void surf (Input IN, inout SurfaceOutput o)
        {
			float3 fragRayOri =_testRayoOrigen.xyz;
			float3 fragRayDir = _testRayoDireccion.xyz;
			fragRayOri.z *= -1.0;
			fragRayDir.z *= -1.0;
         
			float fCameraZ = GetCameraZ();

   			fragRayOri.z += fCameraZ;
			fragRayOri += TunnelOffset(fCameraZ);
	 
			float3 vResult = GetSceneColour(fragRayOri, fragRayDir);
	
			float3 vFinal = ApplyPostFX( (0.5), vResult );
    
			float4 c = float4( vFinal, 1.0 );
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}*/

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

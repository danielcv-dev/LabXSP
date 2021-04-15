Shader "Custom/Medusas2"
{
    Properties
    {
        _RotacionEntornoX("Rotacion Entorno X",float)=0
        _RotacionEntornoY("Rotacion Entorno Y",Range(-1,1))=0
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _accentColor1 ("accentColor1", Color) = (1,.1,.5,1)
        _secondColor1 ("secondColor1", Color) =  (.1,.5,1,1)
        _accentColor2 ("accentColor2", Color) = (1., .5, .1,1)
        _secondColor2 ("secondColor2", Color) = (.1, .5, .6,1)
		_Escala("Escala del uv", float) =1 
		[Toggle] _mostrarMedusas("mostrar medusas",float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Unlit 

        float _RotacionEntornoX,_RotacionEntornoY,_mostrarMedusas, _Escala;
        sampler2D _MainTex;
        float4 _accentColor1, _accentColor2;
        float4 _secondColor1, _secondColor2;
        struct Input
        {
            float2 uv_MainTex;
        };

        static float3 lf=float3(1., 0., 0.);
        static float3 up=float3(0., 1., 0.);
        static float3 fw=float3(0., 0., 1.);

        static float halfpi = 1.570796326794896619;
        static float pi = 3.141592653589793238;
        static float twopi = 6.283185307179586;



        
        fixed4 _Color;
        float3 bg;
        float3 accent;
        static float3 accentColor1 = _accentColor1.rgb; 
        static float3 secondColor1 = _secondColor1.rgb;
        static float3 accentColor2 = _accentColor2;
        static float3 secondColor2 = _secondColor2;

        float N1( float x ) { return frac(sin(x)*5346.1764); }
        float N2(float x, float y) { return N1(x + y*23414.324); }

        float N3(float3 p) {
            p  = frac( p*0.3183099+.1 );
            p *= 17.0;
            return frac( p.x*p.y*p.z*(p.x+p.y+p.z) );
        }

        #define INVERTMOUSE -1.
        #define MAX_STEPS 100.
        #define VOLUME_STEPS 8.

        #define MIN_DISTANCE 0.1
        #define MAX_DISTANCE 100.
        #define HIT_DISTANCE .01

        #define S(x,y,z) smoothstep(x,y,z)
        #define B(x,y,z,w) S(x-z, x+z, w)*S(y+z, y-z, w)
        #define sat(x) clamp(x,0.,1.)
        #define SIN(x) sin(x)*.5+.5
        #define mod(x,y) x-y*floor(x/y)

        #define time _Time.y
struct _ray {
    float3 o;
    float3 d;
};

struct camera {
    float3 p;         // the position of the camera
    float3 forward;   // the camera forward vector
    float3 left;      // the camera left vector
    float3 up;        // the camera up vector
    
    float3 center;    // the center of the screen, in world coords
    float3 i;         // where the current ray intersects the screen, in world coords
    _ray ray;        // the current ray: from cam pos, through current uv projected on screen
    float3 lookAt;    // the lookat point
    float zoom;     // the zoom factor
};
struct de {
    // data type used to pass the various bits of information used to shade a de object
    float d;    // final distance to field
    float m;    // material
    float3 uv;
    float pump;
    
    float3 id;
    float3 pos;       // the world-space coordinate of the fragment
};
struct rc {
    // data type used to handle a repeated coordinate
    float3 id;    // holds the floor'ed coordinate of each cell. Used to identify the cell.
    float3 h;     // half of the size of the cell
    float3 p;     // the repeated coordinate
    //float3 c;       // the center of the cell, world coordinates
};
rc Repeat(float3 pos, float3 size) {
    rc o;
    o.h = size*.5;                  
    o.id = floor(pos/size);         // used to give a unique id to each cell
    o.p = mod(pos, size)-o.h;
    //o.c = o.id*size+o.h;
    
    return o;
}



camera cam;
void CameraSetup(float2 uv, float3 position, float3 lookAt, float zoom) {
    
    cam.p = position;
    cam.lookAt = lookAt;
    cam.forward = normalize(cam.lookAt-cam.p);
    cam.left = cross(up, cam.forward);
    cam.up = cross(cam.forward, cam.left);
    cam.zoom = zoom;
    
    cam.center = cam.p+cam.forward*cam.zoom;
    cam.i = cam.center+cam.left*uv.x+cam.up*uv.y;
    
    cam.ray.o = cam.p;                      // ray origin = camera position
    cam.ray.d = normalize(cam.i-cam.p); // ray direction is the vector from the cam pos through the point on the imaginary screen
}

//  3 out, 1 in... DAVE HOSKINS
float3 N31(float p) {
   float3 p3 = frac((p) * float3(.1031,.11369,.13787));
   p3 += dot(p3, p3.yzx + 19.19);
   return frac(float3((p3.x + p3.y)*p3.z, (p3.x+p3.z)*p3.y, (p3.y+p3.z)*p3.x));
}
float smin( float a, float b, float k )
{
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return lerp( b, a, h ) - k*h*(1.0-h);
}
float smax( float a, float b, float k )
{
    float h = clamp( 0.5 + 0.5*(b-a)/k, 0.0, 1.0 );
    return lerp( a, b, h ) + k*h*(1.0-h);
}
float sdSphere( float3 p, float3 pos, float s ) { return (length(p-pos)-s); }

float2 pModPolar(inout float2 p, float repetitions, float fix) {
    float angle = twopi/repetitions;
    float a = atan2(p.y, p.x) + angle/2.;
    float r = length(p);
    float c = floor(a/angle);
    a = mod(a,angle) - (angle/2.)*fix;
    p = float2(cos(a), sin(a))*r;

    return p;
}
float Dist( float2 P,  float2 P0, float2 P1 ) {
    //2d point-line distance
    
    float2 v = P1 - P0;
    float2 w = P - P0;

    float c1 = dot(w, v);
    float c2 = dot(v, v);
    
    if (c1 <= 0. )  // before P0
        return length(P-P0);
    
    float b = c1 / c2;
    float2 Pb = P0 + b*v;
    return length(P-Pb);
}
float remap(float a, float b, float c, float d, float t) {
    return ((t-a)/(b-a))*(d-c)+c;
}
de map( float3 p, float3 id ) {

    float t = time*2.;
    
    float N = N3(id);
    
    de o;
    o.m = 0.;
    
    float x = (p.y+N*twopi)*1.+t;
    float r = 1.;
    
    float pump = cos(x+cos(x))+sin(2.*x)*.2+sin(4.*x)*.02;
    
    x = t + N*twopi;
    p.y -= (cos(x+cos(x))+sin(2.*x)*.2)*.6;
    p.xz *= 1. + pump*.2;
    
    float d1 = sdSphere(p, float3(0., 0., 0.), r);
    float d2 = sdSphere(p, float3(0., -.5, 0.), r);
    
    o.d = smax(d1, -d2, .1);
    o.m = 1.;
    
    if(p.y<.5) {
        float sway = sin(t+p.y+N*twopi)*S(.5, -3., p.y)*N*.3;
        p.x += sway*N;  // add some sway to the tentacles
        p.z += sway*(1.-N);
        
        float3 mp = p;
        mp.xz = pModPolar(mp.xz, 6., 0.);
        
        float d3 = length(mp.xz-float2(.2, .1))-remap(.5, -3.5, .1, .01, mp.y);
        if(d3<o.d) o.m=2.;
        d3 += (sin(mp.y*10.)+sin(mp.y*23.))*.03;
        
        float d32 = length(mp.xz-float2(.2, .1))-remap(.5, -3.5, .1, .04, mp.y)*.5;
        d3 = min(d3, d32);
        o.d = smin(o.d, d3, .5);
        
        if( p.y<.2) {
             float3 op = p;
            op.xz = pModPolar(op.xz, 13., 1.);
            
            float d4 = length(op.xz-float2(.85, .0))-remap(.5, -3., .04, .0, op.y);
            if(d4<o.d) o.m=3.;
            o.d = smin(o.d, d4, .15);
        }
    }    
    o.pump = pump;
    o.uv = p;
    
    o.d *= .8;
    return o;
}
float3 calcNormal( de o ) {
    float3 eps = float3( 0.01, 0.0, 0.0 );
    float3 nor = float3(
        map(o.pos+eps.xyy, o.id).d - map(o.pos-eps.xyy, o.id).d,
        map(o.pos+eps.yxy, o.id).d - map(o.pos-eps.yxy, o.id).d,
        map(o.pos+eps.yyx, o.id).d - map(o.pos-eps.yyx, o.id).d );
    return normalize(nor);
}
de CastRay(_ray r) {
    float d = 0.;
    float dS = MAX_DISTANCE;
    
    float3 pos = float3(0., 0., 0.);
    float3 n = (0.);
    de o, s;
    
    float dC = MAX_DISTANCE;
    float3 p;
    rc q;
    float t = time;
    float3 grid = float3(6., 30., 6.);
        
    for(float i=0.; i<MAX_STEPS; i++) {
        p = r.o + r.d*d;
        
        
        p.y -= t;  // make the move up
        p.x += t;  // make cam fly forward
            
        q = Repeat(p, grid);
        
        float3 rC = ((2.*step(0., r.d)-1.)*q.h-q.p)/r.d;  // ray to cell boundary
        dC = min(min(rC.x, rC.y), rC.z)+.01;        // distance to cell just past boundary
        
        float N = N3(q.id);
        q.p += (N31(N)-.5)*grid*float3(.5, .7, .5);
        
        if(Dist(q.p.xz, r.d.xz, (0.))<1.1)
        //if(DistRaySegment(q.p, r.d, float3(0., -6., 0.), float3(0., -3.3, 0)) <1.1) 
            s = map(q.p, q.id);
        else
            s.d = dC;
        
        
        
           
        if(s.d<HIT_DISTANCE || d>MAX_DISTANCE) break;
        d+=min(s.d, dC);    // move to distance to next cell or surface, whichever is closest
    }
    
    if(s.d<HIT_DISTANCE) {
        o.m = s.m;
        o.d = d;
        o.id = q.id;
        o.uv = s.uv;
        o.pump = s.pump;
        
        
        o.pos = q.p;
    }
    
    return o;
}
float VolTex(float3 uv, float3 p, float scale, float pump) {
    // uv = the surface pos
    // p = the volume shell pos
    
    p.y *= scale;
    
    float s2 = 5.*p.x/twopi;
    float id = floor(s2);
    s2 = frac(s2);
    float2 ep = float2(s2-.5, p.y-.6);
    float ed = length(ep);
    float e = B(.35, .45, .05, ed);
    
    float s = SIN(s2*twopi*15. );
    s = s*s; s = s*s;
    s *= S(1.4, -.3, uv.y-cos(s2*twopi)*.2+.3)*S(-.6, -.3, uv.y);
    
    float t = time*5.;
    float mask = SIN(p.x*twopi*2. + t);
    s *= mask*mask*2.;
    
    return s+e*pump*2.;
}

float4 JellyTex(float3 p) { 
    float3 s = float3(atan2(p.x, p.z), length(p.xz), p.y);
    
    float b = .75+sin(s.x*6.)*.25;
    b = lerp(1., b, s.y*s.y);
    
    p.x += sin(s.z*10.)*.1;
    float b2 = cos(s.x*26.) - s.z-.7;
   
    b2 = S(.1, .6, b2);
    return (b+b2);
}
float2 sph(float3 ro, float3 rd, float3 pos, float radius) {
    // does a ray sphere intersection
    // returns a float2 with distance to both intersections
    // if both a and b are MAX_DISTANCE then there is no intersection
    
    float3 oc = pos - ro;
    float l = dot(rd, oc);
    float det = l*l - dot(oc, oc) + radius*radius;
    if (det < 0.0) return (MAX_DISTANCE);
    
    float d = sqrt(det);
    float a = l - d;
    float b = l + d;
    
    return float2(a, b);
}
float3 background(float3 r) {
    
    float x = atan2(r.x, r.z);       // from -pi to pi   
    float y = pi*0.5-acos(r.y);         // from -1/2pi to 1/2pi     
    
    float3 col = bg*(1.+y);
    
    float t = time;                // add god rays
    
    float a = sin(r.x);
    
    float beam = sat(sin(10.*x+a*y*5.+t));
    beam *= sat(sin(7.*x+a*y*3.5-t));
    
    float beam2 = sat(sin(42.*x+a*y*21.-t));
    beam2 *= sat(sin(34.*x+a*y*17.+t));
    
    beam += beam2;
    col *= 1.+beam*.05;

    return col;
}



float3 render( float2 uv, _ray camRay, float depth ) {
    // outputs a color
    
    bg = background(cam.ray.d);

    float3 col = bg;	
	if (_mostrarMedusas !=0)
	{
		de o = CastRay(camRay);
    
		float t = time;
		float3 L = up;
    

		if(o.m>0.) {
			float3 n = calcNormal(o);
			float lambert = sat(dot(n, L));
			float3 R = reflect(camRay.d, n);
			float fresnel = sat(1.+dot(camRay.d, n));
			float trans = (1.-fresnel)*.5;
			float3 ref = background(R);
			float fade = 0.;
        
			if(o.m==1.) {   // hood color
				float density = 0.;
				for(float i=0.; i<VOLUME_STEPS; i++) {
					float sd = sph(o.uv, camRay.d, (0.), .8+i*.015).x;
					if(sd!=MAX_DISTANCE) {
						float2 intersect = o.uv.xz+camRay.d.xz*sd;

						float3 uv = float3(atan2(intersect.x, intersect.y), length(intersect.xy), o.uv.z);
						density += VolTex(o.uv, uv, 1.4+i*.03, o.pump);
					}
				}
				float4 volTex = float4(accent, density/VOLUME_STEPS); 
            
            
				float3 dif = JellyTex(o.uv).rgb;
				dif *= max(.2, lambert);

				col = lerp(col, volTex.rgb, volTex.a);
				col = lerp(col, float3(dif), .25);

				col += fresnel*ref*sat(dot(up, n));

				//fade
				fade = max(fade, S(.0, 1., fresnel));
			} else if(o.m==2.) {                        // inside tentacles
				float3 dif = accent;
				col = lerp(bg, dif, fresnel);
            
				col *= lerp(.6, 1., S(0., -1.5, o.uv.y));
            
				float prop = o.pump+.25;
				prop *= prop*prop;
				col += pow(1.-fresnel, 20.)*dif*prop;
            
            
				fade = fresnel;
			} else if(o.m==3.) {                        // outside tentacles
				float3 dif = accent;
				float d = S(100., 13., o.d);
				col = lerp(bg, dif, pow(1.-fresnel, 5.)*d);
			}
        
			fade = max(fade, S(0., 100., o.d));
			col = lerp(col, bg, fade);
        
			if(o.m==4.)
				col = float3(1., 0., 0.);
		} 
		 else
		 {	 
			col = bg;
	 
		 }
	 }
    
    return col;
}
        void surf (Input IN, inout SurfaceOutput o)
        {
                        float4 cc = float4(0,0,0,1);

            float t = time*.04;
    
            float2 uv = IN.uv_MainTex;
			uv.x = frac(IN.uv_MainTex * _Escala);
			//uv.x += floor(IN.uv_MainTex * _Escala);
            uv -= .5;
    
            float2 m = float2(-_RotacionEntornoX,-_RotacionEntornoY);


            accent = lerp(accentColor1, accentColor2, SIN(t*15.456));
            bg = lerp(secondColor1, secondColor2, SIN(t*7.345231));
         //float turn = (.1-m.x) *twopi;
	//float turn =  m.x *twopi;
			float turn =  m.x* floor(IN.uv_MainTex * _Escala).x  *twopi;
            float s = sin(turn);
            float c = cos(turn);

			 //cc.r = s;


            float3x3 rotX = float3x3(c,  0., s, 0., 1., 0., s,  0., -c);
		//float camDist = -10.0;

            float camDist = 0.10;
            
            float3 lookAt = float3(0., 1, 0.);
    
        //float3 camPos = mul(float3(0., INVERTMOUSE*camDist*cos((m.y)*pi), camDist),rotX);
			float3 camPos = mul(float3(0.,0, camDist), rotX);
			//camPos.y = m.y;
			//float3 camPos = mul(float3(0., INVERTMOUSE*camDist*m.y*pi, camDist),rotX);
        //CameraSetup(uv, camPos+lookAt, lookAt, 1.);
            //lookAt.y += m.y;
            uv.y += _RotacionEntornoY;
			//uv.x += _Escala;

            CameraSetup(uv, camPos+lookAt,  lookAt, 1.);
            float3 col = render(uv, cam.ray, 0.);

            cc.rgb = col;

            o.Albedo = cc.rgb;

            o.Alpha = cc.a;
        }
        half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) {
           half4 c;
           c.rgb = s.Albedo;
           c.a = s.Alpha;
           return c;
         }
        ENDCG
    }
    FallBack "Diffuse"
}

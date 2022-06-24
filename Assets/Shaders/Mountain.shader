Shader "PGATR/DisplacementMap" 
{
    Properties
    {
       _MainTex("Main Texture", 2D) = "white" {}
       _DisplacementTex("Displacement Texture", 2D) = "white" {}
       _MaxDisplacement("Max Displacement", Float) = 1.0
    }

    SubShader
    {
        Pass 
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            uniform sampler2D _MainTex;
            uniform sampler2D _DisplacementTex;
            uniform float _MaxDisplacement;

            struct vertexInput 
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct vertexOutput 
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD0;
            };

            vertexOutput vert(vertexInput i) 
            {
                 vertexOutput o;

                 float4 dispTex = tex2Dlod(_DisplacementTex, float4(i.texcoord.xy, 0.0, 0.0));
                 float disp = dispTex.rgb * _MaxDisplacement;
                 float4 newPos = i.vertex + float4(i.normal * disp, 0.0);

                 o.position = UnityObjectToClipPos(newPos);
                 o.texcoord = i.texcoord;

                 return o;
            }

            float4 frag(vertexOutput i) : COLOR
            {
                return tex2D(_MainTex, i.texcoord.xy);
            }

            ENDCG
        }
    }
}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class LocalAnimationControl : NetworkBehaviour
{

    public Animator anim;
    public GameObject[] animationBodyParts;
    public Material invisible;

    [SyncVar(hook = "OnAnimationsStateChange")]
    public string animState = "idle";

    void OnAnimationsStateChange(string aString )
    {
        if (isLocalPlayer) return;
        UpdateAnimation(aString);
    }

    void UpdateAnimation (string aString)
    {
        if (animState == aString) return;
        animState = aString;

        if (animState == "idle")
        {
            anim.SetTrigger("isIdle");
        }
        if (animState == "run")
        {
            anim.SetTrigger("isRunning");
        }
    }

    [Command]
    public void CmdUpdateAnim(string aString)
    {
        UpdateAnimation(aString);
    }

    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponentInChildren<Animator>();
        
        if (isLocalPlayer)
        {
            foreach( GameObject g in animationBodyParts)
            {
                SkinnedMeshRenderer[] m = g.GetComponentsInChildren<SkinnedMeshRenderer>();
                Renderer[] r = g.GetComponentsInChildren<Renderer>();
                foreach (SkinnedMeshRenderer matRend in m)
                {
                    matRend.material = invisible;
                }

                foreach (Renderer rend in r)
                {
                    rend.material = invisible;
                }
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

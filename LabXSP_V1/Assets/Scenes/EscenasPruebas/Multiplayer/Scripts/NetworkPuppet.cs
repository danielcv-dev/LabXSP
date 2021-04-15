using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class NetworkPuppet : NetworkBehaviour
{

    private System.Action _followingAction;

    public Transform puppet;
    public Transform puppetBody;
    public Transform puppetHead;
    public Transform puppetLeftHand;
    public Transform puppetRightHand;

    //targets to track
    public Transform bodyTarget;
    public Transform headTarget;
    public Transform leftHandTarget;
    public Transform rightHandTarget;

    private void Awake()
    {
        _followingAction = FollowingInactive;
    }

    private void FollowingInactive()
    {
        return;
    }

    

    public override void OnStartLocalPlayer()
    {
        bodyTarget = GameObject.Find("robot").transform;
        headTarget = GameObject.Find("CenterEyeAnchor").transform;
        leftHandTarget = GameObject.Find("LeftHandAnchor").transform;
        rightHandTarget = GameObject.Find("RightHandAnchor").transform;

        this._followingAction = FollowingActive;
        
    }

    private void FollowingActive()
    {
        puppet.position = bodyTarget.position;
        puppetBody.position = bodyTarget.position;
        puppetHead.position = headTarget.position;
        puppetHead.rotation = headTarget.rotation;
        puppetLeftHand.position = leftHandTarget.position;
        puppetLeftHand.rotation = leftHandTarget.rotation;
        puppetRightHand.position = rightHandTarget.position;
        puppetRightHand.rotation = rightHandTarget.rotation;

    }


    // Update is called once per frame
    void Update()
    {
        _followingAction.Invoke();
    }
}

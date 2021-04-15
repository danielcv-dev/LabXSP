using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using InputTracking = UnityEngine.XR.InputTracking;
using Node = UnityEngine.XR.XRNode;

public class LocalPlayerControl : NetworkBehaviour
{

    public GameObject ovrCamRig;
    public Transform leftHand;
    public Transform rightHand;
    public Camera leftEye;
    public Camera rightEye;
    Vector3 pos;
    public float speed = 3.0f;
    //public Animator anim;

    // Start is called before the first frame update
    void Start()
    {
        pos = transform.position;
        //anim = GetComponentInChildren<Animator>();
    }

    // Update is called once per frame
    void Update()
    {

        if (!isLocalPlayer)
        {
            Destroy(ovrCamRig);
        }
        else
        {
            //se encarga de la cámara cuando otro jugador entra
            if (leftEye.tag != "MainCamera")
            {
                leftEye.tag = "MainCamera";
                leftEye.enabled = true;
            }
            if (rightEye.tag != "MainCamera")
            {
                rightEye.tag = "MainCamera";
                rightEye.enabled = true;
            }

            //controla las 
            /*
            if (OVRInput.Get(OVRInput.Axis2D.PrimaryThumbstick).x != 0 || OVRInput.Get(OVRInput.Axis2D.PrimaryThumbstick).y != 0)
            {

                //set animation to Running over the server
                anim.SetTrigger("isRunning");
                GetComponent<LocalAnimationControl>().CmdUpdateAnim("run");


            }
            else
            {
                //Set animations to idle over the server
                anim.SetTrigger("isIdle");
                GetComponent<LocalAnimationControl>().CmdUpdateAnim("idle");

            }
            */

            //tracking de las manos
            leftHand.localRotation = InputTracking.GetLocalRotation(Node.LeftHand);
            rightHand.localRotation = InputTracking.GetLocalRotation(Node.RightHand);
            leftHand.localPosition = InputTracking.GetLocalPosition(Node.LeftHand) + new Vector3(0,0,0);
            rightHand.localPosition = InputTracking.GetLocalPosition(Node.RightHand) + new Vector3(0,0,0);

            //tracking del player
            
            Vector2 primaryAxis = OVRInput.Get(OVRInput.Axis2D.PrimaryThumbstick);

            /*
            if (primaryAxis.y > 0.0f)
            {
                pos += (primaryAxis.y * transform.forward * Time.deltaTime);
            }
            if (primaryAxis.y < 0.0f)
            {
                pos += (Mathf.Abs(primaryAxis.y) * -transform.forward * Time.deltaTime);
            }*/
            if (primaryAxis.x > 0.0f)
            {
                pos += (primaryAxis.x * transform.right * Time.deltaTime);
            }
            if (primaryAxis.x < 0.0f)
            {
                pos += (Mathf.Abs(primaryAxis.x) * -transform.right * Time.deltaTime);
            }

            transform.position = pos;
            
            /*
            Vector3 euler = transform.rotation.eulerAngles;
            Vector2 secondaryAxis = OVRInput.Get(OVRInput.Axis2D.SecondaryThumbstick);
            euler.y += secondaryAxis.x;
            transform.rotation = (Quaternion.Euler(euler));
            //fijar también rotación local?
            transform.localRotation = Quaternion.Euler(euler);
            */

        }

    }
}

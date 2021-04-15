using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControlLaserRBehavior : MonoBehaviour
{

    public bool inputB;
    public LineRenderer laserR;
    Vector3 linefrom;
    Vector3 lineto;
    //[SerializeField]
    //LayerMask mask;


    //public GameObject rayCastObject;


    // Update is called once per frame
    void Update()
    {
        inputB = OVRInput.Get(OVRInput.RawButton.B);

        if (inputB)
        {
            laserR.enabled = true;
        }
        else
        {
            laserR.enabled = false;
        }
       
        
    }

    private void FixedUpdate()
    {
        RayCastFunctionLazerR();
    }

    public void RayCastFunctionLazerR()
    {


        
       // LayerMask mask = ~(1 << LayerMask.NameToLayer("Huesos"));

        RaycastHit hit;

        if (Physics.Raycast(transform.position, transform.forward, out hit))
        {
            Vector3 hitLaser = hit.point;



            laserR.SetPosition(0, transform.position);
            laserR.SetPosition(1, hit.point);
            print(hit.collider.name);
            print(hit.collider.tag);
            
        }


        Debug.DrawRay(transform.position, transform.forward, Color.yellow);

    }


    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(linefrom, lineto);
    }
}

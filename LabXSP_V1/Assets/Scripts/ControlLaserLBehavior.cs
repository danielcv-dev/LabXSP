using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControlLaserLBehavior : MonoBehaviour
{

    public bool inputY;
    public LineRenderer laserL;
    Vector3 linefrom;
    Vector3 lineto;
    //[SerializeField]
    //LayerMask mask;


    //public GameObject rayCastObject;


    // Update is called once per frame
    void Update()
    {
        inputY = OVRInput.Get(OVRInput.RawButton.Y);

       
        if (inputY)
        {
            laserL.enabled = true;
        }
        else
        {
            laserL.enabled = false;
        }
        
    }

    private void FixedUpdate()
    {
        RayCastFunctionLazerL();
    }


    public void RayCastFunctionLazerL()
    {



        // LayerMask mask = ~(1 << LayerMask.NameToLayer("Huesos"));

        RaycastHit hit;

        if (Physics.Raycast(transform.position, transform.forward, out hit))
        {
            Vector3 hitLaser = hit.point;



            laserL.SetPosition(0, transform.position);
            laserL.SetPosition(1, hit.point);
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

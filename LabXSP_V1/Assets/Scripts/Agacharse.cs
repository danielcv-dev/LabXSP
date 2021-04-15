using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Agacharse : MonoBehaviour
{

    public GameObject eyeCenterAnchor;
    

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        if (eyeCenterAnchor.transform.localPosition.y < 0.9f)
        {
            //Debug.Log("Hola");
            GetComponent<CharacterController>().height = 1;
        }
        else
        {
            //GetComponent<CharacterController>().center = new Vector3 (0,10,0);
            GetComponent<CharacterController>().height = 1.5f;
        }
    }
}

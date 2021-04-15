using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MueveMuro : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
        this.transform.Translate(-Vector3.forward * Time.deltaTime);
        if (this.transform.position.z <= -20.0f)
        {
            Destroy(this.gameObject);
        }
        
    }
}

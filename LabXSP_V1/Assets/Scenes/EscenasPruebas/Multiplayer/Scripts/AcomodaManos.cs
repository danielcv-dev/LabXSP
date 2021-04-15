using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AcomodaManos : MonoBehaviour
{

    public GameObject handsPositioner;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        this.transform.position = handsPositioner.transform.position;
        this.transform.rotation = handsPositioner.transform.rotation;
    }
}

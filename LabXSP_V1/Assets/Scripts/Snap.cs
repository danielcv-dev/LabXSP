using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class Snap : MonoBehaviour
{

    public string type;
    public AudioSource Colocar;
    
    private void OnTriggerStay(Collider other)
    {

        if (other.gameObject.tag == type)
        {
            other.gameObject.transform.position = transform.position;
            other.gameObject.transform.rotation = transform.rotation;
            other.gameObject.GetComponent<Rigidbody>().isKinematic = true;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == type)
        {
            Colocar.Play();
        }
    }

}

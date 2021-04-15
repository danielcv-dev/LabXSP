using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConeBehavior : MonoBehaviour
{
    // Start is called before the first frame update

    public GameObject Inspeccion;

    private void OnTriggerEnter(Collider col)
    {
        if (col.CompareTag("Player"))
        {
            Inspeccion.SetActive(false);
        }
    }

    private void OnTriggerExit(Collider col)
    {
        if (col.CompareTag("Player"))
        {
            Inspeccion.SetActive(true);
        }   
    }

}

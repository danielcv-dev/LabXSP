using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControladorCilindroGiratorio : MonoBehaviour
{
    [SerializeField] float velocidad;
    void Update()
    {
        transform.Rotate( Vector3.up * Time.deltaTime* velocidad);
    }
}

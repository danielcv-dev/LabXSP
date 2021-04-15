using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MecanicaMedusas : MonoBehaviour
{
    [Header("materiales de medusas")]
    [SerializeField] List <Material> materialesPared = new List<Material>();
    [SerializeField] float  rotacionY;
    [SerializeField] float variacion;
    private void Start()
    {
        // inicializar posicion
        rotacionY = 0;
        ModificarRotacionY(0);

    }
    private void Update()
    {        
        if (Input.GetKey(KeyCode.S) || OVRInput.Get(OVRInput.Axis2D.PrimaryThumbstick).y < 0)
        {
            if (rotacionY > -1)
            {
                rotacionY = rotacionY - variacion;
                ModificarRotacionY(rotacionY);
            }
        }
        if (Input.GetKey(KeyCode.W) || OVRInput.Get(OVRInput.Axis2D.PrimaryThumbstick).y > 0)
        {
            if (rotacionY < 1)
            {
                rotacionY = rotacionY + variacion;
                ModificarRotacionY(rotacionY);
            }
        }
    }
    void ModificarRotacionY(float _valor)
    {
        for (int i = 0; i < materialesPared.Count; i++)
        {
            materialesPared[i].SetFloat("_RotacionEntornoY", _valor);
        }
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RestablecerPosicionEsferas : MonoBehaviour
{
    [SerializeField] List<GameObject> esferas = new List<GameObject>();
    [SerializeField] List<Vector3> esferaInicioPosition = new List<Vector3>();
    [SerializeField] List<Vector3> esferaInicioRotacion = new List<Vector3>();
    // Start is called before the first frame update
    void Start()
    {
        GuardarPosicionYRotacion();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.P)|| OVRInput.GetDown(OVRInput.Button.Three))
        {
            ReposicionarESferas();
        }
    }
    void GuardarPosicionYRotacion()
    {
        for (int i = 0; i < esferas.Count; i++)
        {
            esferaInicioPosition.Add(esferas[i].transform.position);
            esferaInicioRotacion.Add(esferas[i].transform.eulerAngles);
        }
    }
    void ReposicionarESferas()
    {

        for (int i = 0; i < esferas.Count; i++)
        {
            esferas[i].GetComponent<Rigidbody>().isKinematic = true;
            esferas[i].transform.position = esferaInicioPosition[i];
            esferas[i].transform.rotation = Quaternion.Euler(esferaInicioRotacion[i]);
            esferas[i].GetComponent<Rigidbody>().isKinematic = false;

        }
    }
}

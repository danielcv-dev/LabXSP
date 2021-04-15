using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MostrarInformacion : MonoBehaviour
{
    [SerializeField] GameObject hologramaAEncender;
    [SerializeField] GameObject iconoInformacion;
    [SerializeField] AudioSource audioInfo;

    private void OnTriggerEnter(Collider other)
    {
        // colocar el
        if (other.gameObject.layer == 8)
        {
            hologramaAEncender.SetActive(true);
            iconoInformacion.SetActive(false);
            audioInfo.Play();
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            hologramaAEncender.SetActive(false);
            iconoInformacion.SetActive(true);
            audioInfo.Stop();
        }
    }

}

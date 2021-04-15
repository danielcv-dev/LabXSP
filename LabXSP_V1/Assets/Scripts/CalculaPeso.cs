using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CalculaPeso : MonoBehaviour
{

    private int pesoTotal = 0;
    public GameObject textoPesoTotal;

    private void OnTriggerEnter(Collider other)
    {
        pesoTotal += other.GetComponent<PesoMaleta>().peso;
        textoPesoTotal.GetComponent<TextMesh>().text = "TOTAL: " + pesoTotal + "KG";
    }

    private void OnTriggerExit(Collider other)
    {
        pesoTotal -= other.GetComponent<PesoMaleta>().peso;
        textoPesoTotal.GetComponent<TextMesh>().text = "TOTAL: " + pesoTotal + "KG";
    }

}

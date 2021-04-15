using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PesoMaleta : MonoBehaviour
{

    public TextMesh textoPeso;

    [SerializeField]
    public int peso = 0;

    private void Awake()
    {
        peso = Random.Range(5, 80);
    }

    private void Update()
    {
        textoPeso.text = peso + "kg";
    }
}

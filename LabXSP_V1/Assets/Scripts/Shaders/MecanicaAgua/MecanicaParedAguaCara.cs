using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class MecanicaParedAguaCara : MonoBehaviour
{
    [SerializeField] Material materialParedAgua;
    [SerializeField] Material clonParedAgua;
    [SerializeField] RawImage efectoAgua;
    [SerializeField] [Range(0, 5)] float duracion;
    private void Start()
    {
        clonParedAgua = Instantiate(materialParedAgua);
        efectoAgua.material = clonParedAgua;
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "ParedAgua")
        {
            efectoAgua.gameObject.SetActive(true);
            StartCoroutine(IniciarAnimacionFadeOutAgua());
        }
    }
    IEnumerator IniciarAnimacionFadeOutAgua()
    {
        float tiempo = 0;
        while (tiempo < duracion)
        {
            clonParedAgua.SetFloat("_IntensidadLuzExterna", Mathf.Lerp(1, 0, (tiempo / duracion)));
            tiempo += Time.deltaTime;
            yield return null;
        }
        clonParedAgua.SetFloat("_IntensidadLuzExterna", 0);
        efectoAgua.gameObject.SetActive(false);
    }
}

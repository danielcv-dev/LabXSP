using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CambioColorAuroras : MonoBehaviour
{
    [SerializeField] GameObject arriba1;
    [SerializeField] GameObject arriba1Espejo;
    [SerializeField] GameObject arriba2;
    [SerializeField] GameObject arriba2Espejo;
    [SerializeField] GameObject medio1;
    [SerializeField] GameObject medio1Espejo;
    [SerializeField] GameObject medio2;
    [SerializeField] GameObject medio2Espejo;
    [SerializeField] GameObject abajo1;
    [SerializeField] GameObject abajo1Espejo;
    [SerializeField] GameObject abajo2;
    [SerializeField] GameObject abajo2Espejo;
    [SerializeField] GameObject tapaAuroras;

    [SerializeField] Material materialArriba1;
    [SerializeField] Material materialArriba2;
    [SerializeField] Material materialMedio1;
    [SerializeField] Material materialMedio2;
    [SerializeField] Material materialAbajo1;
    [SerializeField] Material materialAbajo2;
    [SerializeField] Material materialTapaAuroras;
    [SerializeField] [Range(0, 5)] float duracion;

    [Header("Menu de materiales")]
    [SerializeField] Material menuMaterial;

    [SerializeField] bool animacionEjecucion;

    // Start is called before the first frame update
    void Start()
    {
        ClonarYAcomodoMateriales();
        
    }
    private void OnTriggerEnter(Collider other)
    {
        if(other.name == "MenuEsfera")
        {
            if (!animacionEjecucion)
            {
                if (menuMaterial != other.GetComponent<Renderer>().material || menuMaterial == null)
                {
                    animacionEjecucion = true;
                    menuMaterial = other.GetComponent<Renderer>().material;
                    StartCoroutine(CambiarColor());
                }
            }
        }
    }


    void ClonarYAcomodoMateriales()
    {
        //CLONAR LOS MATERIALES
        materialArriba1 = Instantiate(arriba1.GetComponent<Renderer>().material);
        arriba1.GetComponent<Renderer>().material = materialArriba1;
        arriba1Espejo.GetComponent<Renderer>().material = materialArriba1;

        materialArriba2 = Instantiate(arriba2.GetComponent<Renderer>().material);
        arriba2.GetComponent<Renderer>().material = materialArriba2;
        arriba2Espejo.GetComponent<Renderer>().material = materialArriba2;

        materialMedio1 = Instantiate(medio1.GetComponent<Renderer>().material);
        medio1.GetComponent<Renderer>().material = materialMedio1;
        medio1Espejo.GetComponent<Renderer>().material = materialMedio1;

        materialMedio2 = Instantiate(medio2.GetComponent<Renderer>().material);
        medio2.GetComponent<Renderer>().material = materialMedio2;
        medio2Espejo.GetComponent<Renderer>().material = materialMedio2;

        materialAbajo1 = Instantiate(abajo1.GetComponent<Renderer>().material);
        abajo1.GetComponent<Renderer>().material = materialAbajo1;
        abajo1Espejo.GetComponent<Renderer>().material = materialAbajo1;

        materialAbajo2 = Instantiate(abajo2.GetComponent<Renderer>().material);
        abajo2.GetComponent<Renderer>().material = materialAbajo2;
        abajo2Espejo.GetComponent<Renderer>().material = materialAbajo2;

        materialTapaAuroras = Instantiate(tapaAuroras.GetComponent<Renderer>().material);
        tapaAuroras.GetComponent<Renderer>().material = materialTapaAuroras;
    }

    IEnumerator CambiarColor()
    {
        Vector3 colorInicio = new Vector3(0, 0, 0);
        colorInicio.x = materialArriba1.GetFloat("_ColorX");
        colorInicio.y = materialArriba1.GetFloat("_ColorY");
        colorInicio.z = materialArriba1.GetFloat("_ColorZ");
        Vector3 colorFinal = new Vector3(0, 0, 0);
        colorFinal.x = menuMaterial.GetFloat("_ColorX");
        colorFinal.y = menuMaterial.GetFloat("_ColorY");
        colorFinal.z = menuMaterial.GetFloat("_ColorZ");
        float tiempo = 0;
        float tiempoTranscurrido=0;
        while (tiempo< duracion)
        {
            tiempoTranscurrido = (tiempo / duracion);
            materialArriba1.SetFloat("_ColorX", Mathf.Lerp(colorInicio.x, colorFinal.x,tiempoTranscurrido ));
            materialArriba1.SetFloat("_ColorY", Mathf.Lerp(colorInicio.y, colorFinal.y, tiempoTranscurrido));
            materialArriba1.SetFloat("_ColorZ", Mathf.Lerp(colorInicio.z, colorFinal.z, tiempoTranscurrido));

            materialArriba2.SetFloat("_ColorX", Mathf.Lerp(colorInicio.x, colorFinal.x, tiempoTranscurrido));
            materialArriba2.SetFloat("_ColorY", Mathf.Lerp(colorInicio.y, colorFinal.y, tiempoTranscurrido));
            materialArriba2.SetFloat("_ColorZ", Mathf.Lerp(colorInicio.z, colorFinal.z, tiempoTranscurrido));

            materialMedio1.SetFloat("_ColorX", Mathf.Lerp(colorInicio.x, colorFinal.x, tiempoTranscurrido));
            materialMedio1.SetFloat("_ColorY", Mathf.Lerp(colorInicio.y, colorFinal.y, tiempoTranscurrido));
            materialMedio1.SetFloat("_ColorZ", Mathf.Lerp(colorInicio.z, colorFinal.z, tiempoTranscurrido));

            materialMedio2.SetFloat("_ColorX", Mathf.Lerp(colorInicio.x, colorFinal.x, tiempoTranscurrido));
            materialMedio2.SetFloat("_ColorY", Mathf.Lerp(colorInicio.y, colorFinal.y, tiempoTranscurrido));
            materialMedio2.SetFloat("_ColorZ", Mathf.Lerp(colorInicio.z, colorFinal.z, tiempoTranscurrido));

            materialAbajo1.SetFloat("_ColorX", Mathf.Lerp(colorInicio.x, colorFinal.x, tiempoTranscurrido));
            materialAbajo1.SetFloat("_ColorY", Mathf.Lerp(colorInicio.y, colorFinal.y, tiempoTranscurrido));
            materialAbajo1.SetFloat("_ColorZ", Mathf.Lerp(colorInicio.z, colorFinal.z, tiempoTranscurrido));
            materialAbajo2.SetFloat("_ColorX", Mathf.Lerp(colorInicio.x, colorFinal.x, tiempoTranscurrido));
            materialAbajo2.SetFloat("_ColorY", Mathf.Lerp(colorInicio.y, colorFinal.y, tiempoTranscurrido));
            materialAbajo2.SetFloat("_ColorZ", Mathf.Lerp(colorInicio.z, colorFinal.z, tiempoTranscurrido));

            materialTapaAuroras.SetFloat("_ColorX", Mathf.Lerp(colorInicio.x, colorFinal.x, tiempoTranscurrido));
            materialTapaAuroras.SetFloat("_ColorY", Mathf.Lerp(colorInicio.y, colorFinal.y, tiempoTranscurrido));
            materialTapaAuroras.SetFloat("_ColorZ", Mathf.Lerp(colorInicio.z, colorFinal.z, tiempoTranscurrido));
            tiempo += Time.deltaTime;
            yield return null;
        }
        animacionEjecucion = false;
        yield return null;
    }
}

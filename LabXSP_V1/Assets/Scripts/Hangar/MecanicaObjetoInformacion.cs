using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MecanicaObjetoInformacion : MonoBehaviour
{
    [Tooltip("Inicio de la animacion LocalPosicion")] [SerializeField] Vector3 inicio;
    [Tooltip("Fin de la animacion LocalPosicion")] [SerializeField] Vector3 Fin;
    [Tooltip("duracion de la animacion")] [Range(0, 5)] [SerializeField] float duracion;
    [Header("Texto 3D")]
    [Tooltip("GO padre del texto")] [SerializeField] Transform goTextoPadre;
    [SerializeField] Vector3 escalaFinalGOTextoPadre = new Vector3(1,1,1);

    void Update()
    {
        transform.Rotate(Vector3.up * Time.deltaTime, 2);
    }
    private void OnEnable()
    {
        //escalaFinalGOTextoPadre = goTextoPadre.localScale;
        StartCoroutine(InicioAnimacion());
    }

    IEnumerator InicioAnimacion()
    {
        float tiempo = 0;
        while (tiempo < duracion)
        {
            transform.localPosition = Vector3.Lerp(inicio, Fin, (tiempo / duracion));
            //goTextoPadre.localScale = Vector3.Lerp(new Vector3(0,0,0), escalaFinalGOTextoPadre, (tiempo / duracion));
            tiempo += Time.deltaTime;
            yield return null;
        }
        // nos aseguramos que llegue a la posicion final
        transform.localPosition = Fin;
        yield return null;
    }
}

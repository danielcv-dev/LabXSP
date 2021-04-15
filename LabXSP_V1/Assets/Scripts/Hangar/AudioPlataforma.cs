using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class AudioPlataforma : MonoBehaviour
{
    public AudioSource audioElevador;
    public AudioClip elevator;
    public AudioClip puertas;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    public void Reproducir()
    {
        audioElevador.PlayOneShot(elevator);
    }

    public void Reproducir2()
    {
        audioElevador.PlayOneShot(puertas);
    }

}

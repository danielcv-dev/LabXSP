using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class InterruptorPlataforma : MonoBehaviour
{
    public MecanicaPlataforma mecanicaPlataforma;
    public AudioSource audioBoton;
    public AudioClip boton;

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == 20) {
            mecanicaPlataforma.Subir();
            ReproducirBoton();
        }
    }

    public void ReproducirBoton()
    {
        audioBoton.PlayOneShot(boton);
    }
}

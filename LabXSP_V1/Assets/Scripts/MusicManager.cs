using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class MusicManager : MonoBehaviour
{

    public AudioSource ambientAudio;
    public AudioClip lobbyAudio;
    public AudioClip ludicoAudio;


    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            ambientAudio.clip = ludicoAudio;
            ambientAudio.Play();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            ambientAudio.clip = lobbyAudio;
            ambientAudio.Play();
        }
    }
}

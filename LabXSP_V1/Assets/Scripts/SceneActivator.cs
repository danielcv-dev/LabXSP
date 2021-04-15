using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Audio;

public class SceneActivator : MonoBehaviour
{

    public AudioSource teleport;

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "BorealSphere")
        {
            teleport.Play();
            LobbyPos.EntraAuroras();
            SceneManager.LoadScene("Auroras");
            
        }

        if (other.gameObject.tag == "AcuaticSphere")
        {
            teleport.Play();
            LobbyPos.EntraMedusas();
            SceneManager.LoadScene("Medusas");
            
        }

        if (other.gameObject.tag == "LobbySphere")
        {
            teleport.Play();
            SceneManager.LoadScene("Anatomía");
        }
        
        if (other.gameObject.tag == "SpaceSphere")
        {
            teleport.Play();
            LobbyPos.EntraEspacio();
            SceneManager.LoadScene("Espacio");
        }


    }
}

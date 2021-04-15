using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class AeropuertoAnuncio : MonoBehaviour
{

    public AudioSource ambiente;
    public AudioClip sonido1;
    public AudioClip sonido2;
    public bool entreAviso = true;

    // Start is called before the first frame update
    void Start()
    {

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            Aviso1();
            
        }
    }
    private void OnTriggerExit(Collider other)
    {
        ambiente.gameObject.GetComponent<BoxCollider>().enabled = false;
    }

    public void Aviso1()
    {
        StartCoroutine(Espera());
        ambiente.PlayOneShot(sonido1);
    }

    public void Aviso2()
    {
        ambiente.PlayOneShot(sonido2);
    }

    IEnumerator Espera()
    {
        if (entreAviso == true)
        {
            yield return new WaitForSeconds(40);
            Aviso2();
            entreAviso = false;
            
        }
    }
}

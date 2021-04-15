using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class DoorAnim : MonoBehaviour
{

    public AudioSource openDoor;
    public bool puerta = true;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player" && puerta)
        {
            openDoor.Play();
            GetComponent<Animator>().SetTrigger("Open");
            puerta = false;
        }
    }

}

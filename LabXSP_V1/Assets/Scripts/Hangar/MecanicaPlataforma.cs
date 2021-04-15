using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class MecanicaPlataforma : MonoBehaviour
{
    public Animator plataforma;
    

    // Start is called before the first frame update
    void Start()
    {
        
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
           Bajar();
            Debug.Log("<<<<<bajar plataforma");

        }
    }
    // Update is called once per frame


    /* if (Input.GetKeyDown(KeyCode.J))
     {
         Subir();
     }

     if (Input.GetKeyDown(KeyCode.I))
     {
         Bajar();
     }*/



    public void Subir()
    {
        plataforma.SetBool("EstaArriba", true);

    }

    public void Bajar()
    {
        
        plataforma.SetBool("EstaArriba", false);
    }

   
 
    
}

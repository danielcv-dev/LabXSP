using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MurosManager : MonoBehaviour
{

    public List<GameObject> muros;
    int i = 0;

    private void Start()
    {

        InvokeRepeating("CreaMuro", 0.0f, 15.0f);
    }

    void CreaMuro()
    {
        Instantiate(muros[i], this.transform.position, this.transform.rotation);
        i++;
    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaletasSpawner : MonoBehaviour
{
    public List<GameObject> maletas;
    public string tagMaleta;

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == tagMaleta)
        {
            int r = Random.Range(0, 5);
            Instantiate(maletas[r], this.transform.position, maletas[r].transform.rotation);
            other.gameObject.layer = 8;
            other.gameObject.tag = "";
        }
    }
}

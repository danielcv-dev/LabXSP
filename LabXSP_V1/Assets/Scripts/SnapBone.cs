using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnapBone : MonoBehaviour
{

    public MeshRenderer boneOutline;
    public string hueso;

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == hueso)
        {
            boneOutline.enabled = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == hueso)
        {
            boneOutline.enabled = false;
        }
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MirarA : MonoBehaviour
{

    [SerializeField] Transform goLookAt;
    void Update()
    {
        transform.LookAt(goLookAt);
    }
}

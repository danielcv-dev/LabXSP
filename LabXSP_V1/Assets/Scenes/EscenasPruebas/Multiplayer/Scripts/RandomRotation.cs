using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomRotation : MonoBehaviour
{

    void Update()
    {
        transform.Rotate(Mathf.Sin(Time.time), Mathf.Sin(Time.time), 0);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StartScene : MonoBehaviour
{

    public string[] escenas = {"Hangar"};

    // Start is called before the first frame update
    void Start()
    {
       
        
    }

    void OnTriggerEnter(Collider col)
    {
        if (col.CompareTag("Player"))
        {
            if (this.name == "SpotHangar")
            {
                LobbyPos.EntraHangar();
                StartCoroutine(LoadSceneLab(0));
            }
            
        }
    }

    // Update is called once per frame


    public IEnumerator LoadSceneLab(int numberScene)
    {
        AsyncOperation sceneToLoad = SceneManager.LoadSceneAsync(escenas[numberScene]);

        while (sceneToLoad.isDone)
        {
            yield return null;
        }

    }
}

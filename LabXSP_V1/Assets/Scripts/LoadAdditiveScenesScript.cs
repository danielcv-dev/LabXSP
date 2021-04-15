using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadAdditiveScenesScript : MonoBehaviour
{

    AsyncOperation sceneLoad;

    public string[] escenas = { "Anatomía", "Hangar" };

    public void StartLoadScene(int numeroEscena)
    {
        StartCoroutine(LoadSceneAdditive(escenas[numeroEscena]));
    }


    public void StartUnloadScene(int numeroEscena)
    {
        StartCoroutine(UnloadSceneAdditive(escenas[numeroEscena]));
    }

    public IEnumerator LoadSceneAdditive(string sceneName)
    {
        sceneLoad = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Additive);

        while (sceneLoad.isDone)
        {
            yield return null;
        }


    }

    public IEnumerator UnloadSceneAdditive(string sceneName)
    {
        sceneLoad = SceneManager.UnloadSceneAsync(sceneName);

        while (sceneLoad.isDone)
        {
            yield return null;
        }
    }

}

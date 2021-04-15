using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LobbyPos : MonoBehaviour
{
    public GameObject player;

    public static bool saleLobby = true;
    public static bool saleMedusas = false;
    public static bool saleAuroras = false;
    public static bool saleHangar = false;
    public static bool saleEspacio = false;

    [SerializeField] Transform posLobby;
    [SerializeField] Transform posMedusas;
    [SerializeField] Transform posAuroras;
    [SerializeField] Transform posHangar;
    [SerializeField] Transform posEspacio;

    // Start is called before the first frame update
    void Start()
    {
        if (saleLobby)
        {
            player.transform.position = posLobby.position;
            player.transform.rotation = posLobby.rotation;
        }
        else if (saleMedusas)
        {
            player.transform.position = posMedusas.position;
            player.transform.rotation = posMedusas.rotation;
        }
        else if (saleAuroras)
        {
            player.transform.position = posAuroras.position;
            player.transform.rotation = posAuroras.rotation;
        }
        else if (saleHangar)
        {
            player.transform.position = posHangar.position;
            player.transform.rotation = posHangar.rotation;
        }
        else if (saleEspacio)
        {
            player.transform.position = posEspacio.position;
            player.transform.rotation = posEspacio.rotation;
        }
    }

    public static void EntraAuroras()
    {
        saleLobby = false;
        saleMedusas = false;
        saleAuroras = true;
        saleHangar = false;
        saleEspacio = false;
    }

    public static void EntraMedusas()
    {
        saleLobby = false;
        saleMedusas = true;
        saleAuroras = false;
        saleHangar = false;
        saleEspacio = false;
    }

    public static void EntraHangar()
    {
        saleLobby = false;
        saleMedusas = false;
        saleAuroras = false;
        saleHangar = true;
        saleEspacio = false;
    }

    public static void EntraEspacio()
    {
        saleLobby = false;
        saleMedusas = false;
        saleAuroras = false;
        saleHangar = false;
        saleEspacio = true;
    }
}

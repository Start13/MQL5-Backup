#include <Controls/ComboBox.mqh>

CComboBox *combo; // Dichiarazione come puntatore

int OnInit()
{
    // Inizializzare il ComboBox come puntatore
    combo = new CComboBox();

    // Creare il ComboBox
    if (!combo.Create(0, "TestComboBox", 0, 10, 10, 200, 40))
    {
        Print("Errore nella creazione del ComboBox.");
        delete combo;
        combo = NULL;
        return INIT_FAILED;
    }

    // Aggiungere elementi al ComboBox
    combo.AddItem("Opzione 1", 1);
    combo.AddItem("Opzione 2", 2);

    // Mostrare il ComboBox
    combo.Show();

    Print("ComboBox creato correttamente.");
    return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
    // Eliminare il ComboBox per liberare memoria
    if (combo != NULL)
    {
        delete combo;
        combo = NULL;
    }
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
    // Gestire l'evento di modifica del ComboBox
    if (id == CHARTEVENT_CUSTOM && sparam == "TestComboBox")
    {
        string selected = combo.Select();
        Print("Elemento selezionato: ", selected);
    }
}
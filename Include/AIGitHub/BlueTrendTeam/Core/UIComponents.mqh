#include <Controls/ComboBox.mqh> // Assicurati che il file esista

class CBigPanel {
public:
    void SetLogicType(int type);
};

void AddLogicComboBox(CBigPanel &panel) {
    CComboBox logicCombo;
    logicCombo.Create(0, "LogicComboBox", 0, 50, 50, 200, 30);
    logicCombo.AddItem("AND");
    logicCombo.AddItem("OR");

    // Default OR
    logicCombo.SelectItem(1);

    // Evento per cambiare logica
    logicCombo.OnChangeEvent = LogicComboChanged(panel, logicCombo);
}

void LogicComboChanged(CBigPanel &panel, CComboBox &combo) {
    int selected = combo.SelectedIndex();
    panel.SetLogicType(selected == 0 ? 0 : 1); // 0 = AND, 1 = OR
}
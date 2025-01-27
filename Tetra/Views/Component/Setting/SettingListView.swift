import SwiftUI

struct SettingListView: View {
    @Binding var selectedSetting: SettingItem?
    
    var body: some View {
        List(SettingItem.allCases, id: \.self, selection: $selectedSetting) { item in
            NavigationLink(value: item) {
                Label(item.label, systemImage: item.iconName)
            }
        }
        .navigationTitle("Settings")
    }
}

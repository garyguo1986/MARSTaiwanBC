pageextension 1073891 "Service Center Card Ext." extends "Service Center Card"
{
    layout
    {
        addafter("Geo-Localization Lat.")
        {
            group("MARS Setup")
            {
                field("MDM code"; "MDM code")
                {
                }
                field("Group ID"; "Group ID")
                {
                }
            }
        }
    }
}

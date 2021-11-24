tableextension 1044889 "Vehicle Ext." extends Vehicle
{
    fields
    {
        modify("Vehicle Model")
        {
            TableRelation = "Vehicle Model".Code WHERE("Manufacturer Name" = FIELD("Vehicle Manufacturer"),
                                                        Year = FIELD(Year),
                                                        "Deleted by HQ" = filter(false));
        }
    }
}

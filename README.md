# Shipment Tracking component

LWC component **shipmentTracker** is intended to make callout to a specified API with Tracking Number of a Shipment record.

Component intended to be added to a Shipment record page, thus it is exposed with specific targets.
This component calls controller method that handles callout to external API and querying Shipment record.
- This approach is chosen to store api endpoint using named credential for better configurability. 
- Also this help handle access permissions and in future add logic that stores response from external system for caching and reducing callouts. 
- Tests provided for apex controller. But few scenarios are still missing - (i.e. response with code other than 200).

Other possible approach would be calling API from LWC itself and using uiRecordApi to fetch record data to omit having separate apex controller and make callout client-side. But this will limit possible ways of configuring url and will require additional configuration from API side.  
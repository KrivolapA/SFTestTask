public with sharing class ShipmentTrackerController {
    @AuraEnabled
    public static String getShipmentStatus(String recordId){
        String trackingNumber = getTrackingNumber(recordId);
        if(String.isBlank(trackingNumber)) {
            return 'No Tracking Data';
        }

        Http http = new Http();

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ShipmentTracking'+'?trackingNumber='+ EncodingUtil.urlEncode(trackingNumber, 'UTF-8'));
        req.setMethod('GET');

        try {
            HttpResponse res = http.send(req);
            if(res.getStatusCode() == 200) {
                return res.getBody();
            } else {
                throw new ShipmentTrackingException('Shipment Service error with code:' + res.toString());
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    private static String getTrackingNumber(String recordId) {
        List<Shipment> records = [SELECT Id, TrackingNumber FROM Shipment WHERE Id = :recordId];
        if(records.isEmpty())
            return '';
        SObjectAccessDecision validationDecision = Security.stripInaccessible(AccessType.READABLE, records);
        Shipment record = (Shipment) (validationDecision.getRecords()[0]);
        return record.isSet('TrackingNumber') ? record.TrackingNumber: '';
    }

    private class ShipmentTrackingException extends Exception {}
}
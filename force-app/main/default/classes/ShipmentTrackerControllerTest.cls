@IsTest
private class ShipmentTrackerControllerTest {

    private static final String TRACKING_NUMBER = 'Test TN';
    private static final String RESPONSE_BODY = 'Status received';

    @TestSetup
    private static void setup() {
        insert new Shipment(ShipToName = 'Test', TrackingNumber = TRACKING_NUMBER);
    }

    @IsTest
    private static void getShipmentStatusWrongId() {
        Test.startTest();
        String result = ShipmentTrackerController.getShipmentStatus('');
        Test.stopTest();
        Assert.areEqual('No Tracking Data', result);
    }

    @IsTest
    private static void getShipmentStatusCorrectId() {
        Shipment record = [SELECT Id FROM Shipment LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new HttpShipmentMockValid());

        Test.startTest();
        String result = ShipmentTrackerController.getShipmentStatus(record.Id);
        Test.stopTest();
        Assert.areEqual(RESPONSE_BODY, result);
    }

    public class HttpShipmentMockValid implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            Assert.isTrue(req.getEndpoint().contains(EncodingUtil.urlEncode(TRACKING_NUMBER, 'UTF-8')));

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text');
            res.setBody(RESPONSE_BODY);
            res.setStatusCode(200);
            return res;
        }
    }
}
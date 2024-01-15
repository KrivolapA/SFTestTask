import { LightningElement, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getShipmentStatus from "@salesforce/apex/ShipmentTrackerController.getShipmentStatus"

export default class ShipmentTracker extends LightningElement {

    @api recordId;
    trackingStatus;

    connectedCallback() {
        getShipmentStatus({
            recordId: this.recordId
        }).then((data) => {
            this.trackingStatus = `Your shipment status: ${data}`;
        }).catch((error)=>{
            this.handleError(error)
        })

    }

    handleError(err) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: "Error fetching shipment data",
                message: err.message,
                variant: "error",
            }),
        );
    }
}
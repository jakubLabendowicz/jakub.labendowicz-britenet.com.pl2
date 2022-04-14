public with sharing class ContractTriggerHandler extends TriggerHandler {
    private void beforeInsert() {
        ContractOverlapService.checkOverlap();
    }

    private void beforeUpdate() {
        ContractOverlapService.checkOverlap();
    }
}
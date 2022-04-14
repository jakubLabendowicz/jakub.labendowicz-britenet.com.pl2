/**
 * Created by Jakub Łabendowicz on 04.01.2022.
 */

trigger doctorContractTrigger on Contract__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    ContractTriggerHandler contractTriggerHandler = new ContractTriggerHandler();
    contractTriggerHandler.execute();
}
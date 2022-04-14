public with sharing class ContractOverlapService {
    public static void checkOverlap() {
        List<Contract__c> fullContractsList = [
                SELECT Id, Name, Doctor__c, Hospital__c, Start_Date__c, End_Date__c
                FROM Contract__c
                ORDER BY Start_Date__c
        ];
        List<Contract__c> newContractsList = Trigger.new;
        for (Integer i = 0; i < newContractsList.size(); i++) {
            for (Integer j = i + 1; j < newContractsList.size(); j++) {
                if (newContractsList[i].Hospital__c == newContractsList[j].Hospital__c
                        && newContractsList[i].Doctor__c == newContractsList[j].Doctor__c
                        && newContractsList[i].Start_Date__c == newContractsList[j].Start_Date__c
                        && newContractsList[i].End_Date__c == newContractsList[j].End_Date__c) {
                    newContractsList[j].addError(System.Label.DuplicatedError);
                }
            }
        }
        for (Contract__c contract : newContractsList) {
            checkDatesOverlap(contract, selectListForObject(contract, fullContractsList, newContractsList));
        }
    }

    private static List<Contract__c> selectListForObject(Contract__c contract, List<Contract__c> fullContractsList,
            List<Contract__c> newContractsList) {
        List<Contract__c> selectedContractsList = new List<Contract__c>();
        for (Contract__c oldContract : fullContractsList) {
            if (oldContract.Doctor__c == contract.Doctor__c && oldContract.Hospital__c == contract.Hospital__c
                    && oldContract.Id != contract.Id) {
                selectedContractsList.add(oldContract);
            }
        }
        for (Contract__c newContract : newContractsList) {
            if (newContract.Doctor__c == contract.Doctor__c && newContract.Hospital__c == contract.Hospital__c
                    && newContract != contract) {
                selectedContractsList.add(newContract);
            }
        }
        return selectedContractsList;
    }

    private static void checkDatesOverlap(SObject contractToCheck, List<Contract__c> fullContractsList) {
        Contract__c newContract = (Contract__c) contractToCheck;
        List<String> error = new List<String>();
        List<Date> freeTermsStart = new List<Date>();
        List<Date> freeTermsEnd = new List<Date>();
        List<String> freeTerms = new List<String>();
        for (Contract__c oldContract : fullContractsList) {
            if (!(newContract.Start_Date__c < oldContract.Start_Date__c
                    && newContract.End_Date__c < oldContract.Start_Date__c
                    || oldContract.End_Date__c < newContract.Start_Date__c
                    && oldContract.End_Date__c < newContract.End_Date__c)) {
                error.add(oldContract.Name + System.Label.colon + ' '
                        + System.Label.fromText + ' ' + oldContract.Start_Date__c.format() + ' '
                        + System.Label.toText + ' ' + oldContract.End_Date__c.format());
            }
        }
        freeTermsStart.add(Date.today());
        for (Contract__c oldContract : fullContractsList) {
            freeTermsEnd.add(oldContract.Start_Date__c - 1);
            freeTermsStart.add(oldContract.End_Date__c + 1);
        }
        freeTermsEnd.add(Date.newInstance(2100, 12, 31));
        for (Integer i = 0; i < freeTermsStart.size(); i++) {
            if (freeTermsStart[i] < freeTermsEnd[i]
                    && freeTermsEnd[i] > Date.today()
                    && freeTermsStart[i] < Date.newInstance(2100, 12, 31)) {
                freeTerms.add(System.Label.fromText + ' '
                        + freeTermsStart[i].format() + ' '
                        + System.Label.toText + ' '
                        + freeTermsEnd[i].format());
            }
        }
        if (error.size() > 0) {
            newContract.addError('<br>' + System.Label.errorText + '<br>' + String.join(error, ', <br>') + ' <br><br>'
                    + System.Label.freeTermsText + '<br>' + String.join(freeTerms, ', <br>'), false);
        }
    }
}
@IsTest
private class ContractTriggerTest {

    @testSetup
    private static void setup() {
        insert new Doctor__c(Name = 'Mazur', First_name__c = 'Bogna', Email__c = 'mb@gmail.com');
        insert new Hospital__c(Name = 'Hospital');
    }

    @IsTest
    private static void shouldAddContract() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Hospital__c hospital = [SELECT Id FROM Hospital__c LIMIT 1];
        Contract__c contract1 = new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract1;

        Test.startTest();
        Contract__c contract2 = new Contract__c(Start_Date__c = Date.newInstance(2024, 01, 05),
                End_Date__c = Date.newInstance(2025, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        Database.SaveResult saveResult = Database.insert(contract2, false);
        Test.stopTest();

        System.assert(saveResult.success);
    }

    @IsTest
    private static void shouldAddContractsList() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Hospital__c hospital = [SELECT Id FROM Hospital__c LIMIT 1];
        Contract__c contract1 = new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract1;

        Test.startTest();
        List<Contract__c> contractsList = new List<Contract__c>();
        contractsList.add(new Contract__c(Start_Date__c = Date.newInstance(2024, 01, 05),
                End_Date__c = Date.newInstance(2025, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id));
        contractsList.add(new Contract__c(Start_Date__c = Date.newInstance(2026, 01, 05),
                End_Date__c = Date.newInstance(2028, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id));
        List<Database.SaveResult> saveResults = Database.insert(contractsList, false);
        Test.stopTest();

        for (Database.SaveResult saveResult : saveResults) {
            System.assert(saveResult.success);
        }
    }

    @IsTest
    private static void shouldReturnErrorWhileContractAdding() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Hospital__c hospital = [SELECT Id FROM Hospital__c LIMIT 1];
        Contract__c contract1 = new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract1;

        Test.startTest();
        Contract__c contract2 = new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 06),
                End_Date__c = Date.newInstance(2023, 01, 04), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        Database.SaveResult saveResult = Database.insert(contract2, false);
        Test.stopTest();

        System.assert(!saveResult.success);
    }

    @IsTest
    private static void shouldReturnErrorWhileContractsAdding() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Hospital__c hospital = [SELECT Id FROM Hospital__c LIMIT 1];
        Contract__c contract1 = new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract1;

        Test.startTest();
        List<Contract__c> contractsList = new List<Contract__c>();
        contractsList.add(new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id));
        contractsList.add(new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id));
        List<Database.SaveResult> saveResults = Database.insert(contractsList, false);
        Test.stopTest();

        for (Database.SaveResult saveResult : saveResults) {
            System.assert(!saveResult.success);
        }
    }

    @IsTest
    private static void shouldReturnErrorWhileDuplicatedContractsAdding() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Hospital__c hospital = [SELECT Id FROM Hospital__c LIMIT 1];
        Contract__c contract1 = new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract1;

        Test.startTest();
        List<Contract__c> contractsList = new List<Contract__c>();
        contractsList.add(new Contract__c(Start_Date__c = Date.newInstance(2024, 01, 05),
                End_Date__c = Date.newInstance(2025, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id));
        contractsList.add(new Contract__c(Start_Date__c = Date.newInstance(2024, 01, 05),
                End_Date__c = Date.newInstance(2025, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id));
        contractsList.add(new Contract__c(Start_Date__c = Date.newInstance(2024, 01, 05),
                End_Date__c = Date.newInstance(2026, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id));
        List<Database.SaveResult> saveResults = Database.insert(contractsList, false);
        Test.stopTest();

        System.assert(!saveResults[0].success);
        System.assert(!saveResults[1].success);
        System.assert(!saveResults[2].success);
    }

    @IsTest
    private static void shouldReturnErrorAndAddSecondContractWhileContractsListAdding() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Hospital__c hospital = [SELECT Id FROM Hospital__c LIMIT 1];
        Contract__c contract1 = new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract1;

        Test.startTest();
        List<Contract__c> contractsList = new List<Contract__c>();
        contractsList.add(new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id));
        contractsList.add(new Contract__c(Start_Date__c = Date.newInstance(2025, 01, 05),
                End_Date__c = Date.newInstance(2026, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id));
        List<Database.SaveResult> saveResults = Database.insert(contractsList, false);
        Test.stopTest();

        System.assert(!saveResults[0].success);
        System.assert(saveResults[1].success);
    }

    @IsTest
    private static void shouldUpdateContract() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Hospital__c hospital = [SELECT Id FROM Hospital__c LIMIT 1];
        Contract__c contract1 = new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract1;
        Contract__c contract2 = new Contract__c(Start_Date__c = Date.newInstance(2024, 01, 05),
                End_Date__c = Date.newInstance(2025, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract2;

        Test.startTest();
        Contract__c contract = [
                SELECT Id, Name, Doctor__c, Hospital__c, Start_Date__c, End_Date__c
                FROM Contract__c
                LIMIT 1
        ];
        contract.Start_Date__c = contract.Start_Date__c + 1;
        Database.SaveResult saveResult = Database.update(contract, false);
        Test.stopTest();

        System.assert(saveResult.success);
    }

    @IsTest
    private static void shouldUpdateContractsList() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Hospital__c hospital = [SELECT Id FROM Hospital__c LIMIT 1];
        Contract__c contract1 = new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract1;
        Contract__c contract2 = new Contract__c(Start_Date__c = Date.newInstance(2024, 01, 05),
                End_Date__c = Date.newInstance(2025, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract2;

        Test.startTest();
        List<Contract__c> contracts = [
                SELECT Id, Name, Doctor__c, Hospital__c, Start_Date__c, End_Date__c
                FROM Contract__c
        ];
        contracts[0].Start_Date__c = contracts[0].Start_Date__c + 1;
        contracts[1].Start_Date__c = contracts[1].Start_Date__c + 1;
        List<Database.SaveResult> saveResults = Database.update(contracts, false);
        Test.stopTest();

        for (Database.SaveResult saveResult: saveResults) {
            System.assert(saveResult.success);
        }
    }

    @IsTest
    private static void shouldReturnErrorWhenContractIsUpdating() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Hospital__c hospital = [SELECT Id FROM Hospital__c LIMIT 1];
        Contract__c contract1 = new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract1;
        Contract__c contract2 = new Contract__c(Start_Date__c = Date.newInstance(2024, 01, 05),
                End_Date__c = Date.newInstance(2025, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract2;

        Test.startTest();
        Contract__c contract = [
                SELECT Id, Name, Doctor__c, Hospital__c, Start_Date__c, End_Date__c
                FROM Contract__c
                WHERE Doctor__c = :doctor.Id AND Hospital__c = :hospital.Id
                LIMIT 1
        ];
        contract.Start_Date__c = Date.newInstance(2022, 01, 01);
        contract.End_Date__c = Date.newInstance(2025, 01, 01);
        Database.SaveResult saveResult = Database.update(contract, false);
        Test.stopTest();

        System.assert(!saveResult.success);
    }

    @IsTest
    private static void shouldReturnErrorWhenContractsListIsUpdating() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Hospital__c hospital = [SELECT Id FROM Hospital__c LIMIT 1];
        Contract__c contract1 = new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract1;
        Contract__c contract2 = new Contract__c(Start_Date__c = Date.newInstance(2024, 01, 05),
                End_Date__c = Date.newInstance(2025, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract2;
        Contract__c contract3 = new Contract__c(Start_Date__c = Date.newInstance(2026, 01, 05),
                End_Date__c = Date.newInstance(2027, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract3;

        Test.startTest();
        List<Contract__c> contracts = [
                SELECT Id, Name, Doctor__c, Hospital__c, Start_Date__c, End_Date__c
                FROM Contract__c
                LIMIT 2
        ];
        contracts[0].Start_Date__c = Date.newInstance(2026, 01, 05);
        contracts[0].End_Date__c = Date.newInstance(2027, 01, 05);
        List<Database.SaveResult> saveResults = Database.update(contracts, false);
        Test.stopTest();

        System.assert(!saveResults[0].success);
        System.assert(saveResults[1].success);
    }

    @IsTest
    private static void shouldReturnErrorWhenContractsAreDuplicatedInList() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Hospital__c hospital = [SELECT Id FROM Hospital__c LIMIT 1];
        Contract__c contract1 = new Contract__c(Start_Date__c = Date.newInstance(2022, 01, 05),
                End_Date__c = Date.newInstance(2023, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract1;
        Contract__c contract2 = new Contract__c(Start_Date__c = Date.newInstance(2024, 01, 05),
                End_Date__c = Date.newInstance(2025, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract2;
        Contract__c contract3 = new Contract__c(Start_Date__c = Date.newInstance(2026, 01, 05),
                End_Date__c = Date.newInstance(2027, 01, 05), Doctor__c = doctor.Id, Hospital__c = hospital.Id);
        insert contract3;

        Test.startTest();
        List<Contract__c> contracts = [
                SELECT Id, Name, Doctor__c, Hospital__c, Start_Date__c, End_Date__c
                FROM Contract__c
        ];
        contracts[0].Start_Date__c = Date.newInstance(2000, 1, 1);
        contracts[0].End_Date__c = Date.newInstance(2001, 1, 1);
        contracts[1].Start_Date__c = Date.newInstance(2000, 1, 1);
        contracts[1].End_Date__c = Date.newInstance(2001, 1, 1);
        contracts[2].Start_Date__c = Date.newInstance(2024, 1, 1);
        contracts[2].End_Date__c = Date.newInstance(2025, 1, 1);
        List<Database.SaveResult> saveResults = Database.update(contracts, false);
        Test.stopTest();

        System.assert(!saveResults[0].success);
        System.assert(!saveResults[1].success);
        System.assert(!saveResults[2].success);
    }
}
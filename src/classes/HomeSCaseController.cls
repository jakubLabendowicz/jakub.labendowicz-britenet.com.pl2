public with sharing class HomeSCaseController {
    public HomeSCaseController() {

    }

    @AuraEnabled
    public static Case insertCase(Case newCase){
        try {
            insert newCase;
            return newCase;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Case> selectCases(){
        try {
            Id userId = UserInfo.getUserId();
            List<Case> cases = [
                SELECT Subject, Description, Reason, Status, CreatedDate, CreatedById, CaseNumber
                FROM Case
                WHERE CreatedById = :userId
            ];
            return cases;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
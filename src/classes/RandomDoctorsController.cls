public without sharing class RandomDoctorsController {
    private List<Doctor__c> doctorsList = new List<Doctor__c>();

    public RandomDoctorsController() {
        selectRandomDoctorsList();
    }

    public void selectRandomDoctorsList() {
        Integer quantityOfDoctors = Database.countQuery('SELECT COUNT() FROM Doctor__c');
        Integer randomOffset = Integer.valueof((Math.random() * (quantityOfDoctors - 5)));
        doctorsList = [SELECT Id, First_name__c, Name, Email__c, City__c, Country__c FROM Doctor__c LIMIT 5 OFFSET :randomOffset];
    }

    public List<Doctor__c> getDoctorsList() {
        return doctorsList;
    }
}
global with sharing class DoctorService {

    static String getMessageFromSaveResult(Database.SaveResult saveResult) {
        if (saveResult.success == true) {
            return System.Label.Success;
        } else {
            return saveResult.errors[0].message;
        }
    }

    webService static String insertDoctor(DoctorWrapper doctorWrapper) {
        Doctor__c doctor = wrapperToDoctor(doctorWrapper);
        Database.SaveResult saveResult = Database.insert(doctor);
        return getMessageFromSaveResult(saveResult);
    }

    webService static String updateDoctor(String soapExternalId, DoctorWrapper doctorWrapper) {
        Doctor__c doctor = Database.query(
                'SELECT Id FROM Doctor__c WHERE SoapExternalId__c = :soapExternalId'
        );
        doctor.Name = doctorWrapper.lastName;
        doctor.First_name__c = doctorWrapper.firstName;
        doctor.Email__c = doctorWrapper.email;
        doctor.City__c = doctorWrapper.city;
        doctor.Country__c = doctorWrapper.doctorCountry;
        doctor.Date_of_birth__c = doctorWrapper.dateOfBirth != null
                ? Date.parse(doctorWrapper.dateOfBirth) : null;
        doctor.Medical_field__c = doctorWrapper.medicalField;
        doctor.Phone_number__c = doctorWrapper.phoneNumber;
        doctor.Postcode__c = doctorWrapper.postcode;
        doctor.Salary__c = doctorWrapper.salary;
        doctor.Street__c = doctorWrapper.street;
        doctor.Ward__c = doctorWrapper.ward;
        Database.SaveResult saveResult = Database.update(doctor);
        return getMessageFromSaveResult(saveResult);
    }

    webService static String deleteDoctor(String soapExternalId) {
        Doctor__c doctor = Database.query('SELECT Name FROM Doctor__c WHERE SoapExternalId__c = :soapExternalId');
        Database.DeleteResult deleteResult = Database.delete(doctor);
        if (deleteResult.success == true) {
            return System.Label.Success;
        } else {
            return deleteResult.errors[0].message;
        }
    }

    webService static DoctorWrapper selectDoctor(String soapExternalId) {
        Doctor__c doctor = Database.query(
                'SELECT SoapExternalId__c, Id, Name, First_name__c, Email__c, City__c, Country__c, Date_of_birth__c,' +
                        'Medical_field__c, Phone_number__c, Postcode__c, Salary__c, Street__c, Ward__c ' +
                        'FROM Doctor__c ' +
                        'WHERE SoapExternalId__c = :soapExternalId'
        );
        return doctorToWrapper(doctor);
    }

    webService static List<DoctorWrapper> doctorQuery(String query) {
        List<Doctor__c> doctors = Database.query(query);
        List<DoctorWrapper> doctorWrappers = new List<DoctorService.DoctorWrapper>();
        for (Doctor__c doctor:doctors) {
            doctorWrappers.add(doctorToWrapper(doctor));
        }
        return doctorWrappers;
    }

    static private Doctor__c wrapperToDoctor(DoctorWrapper doctorWrapper) {
        Doctor__c doctor = new Doctor__c();
        doctor.Id = doctorWrapper.Id ;
        doctor.Name = doctorWrapper.lastName;
        doctor.First_name__c = doctorWrapper.firstName;
        doctor.Email__c = doctorWrapper.email;
        doctor.City__c = doctorWrapper.city;
        doctor.Country__c = doctorWrapper.doctorCountry;
        doctor.Date_of_birth__c = doctorWrapper.dateOfBirth != null
                ? Date.parse(doctorWrapper.dateOfBirth) : null;
        doctor.Medical_field__c = doctorWrapper.medicalField;
        doctor.Phone_number__c = doctorWrapper.phoneNumber;
        doctor.Postcode__c = doctorWrapper.postcode;
        doctor.Salary__c = doctorWrapper.salary;
        doctor.Street__c = doctorWrapper.street;
        doctor.Ward__c = doctorWrapper.ward;
        return doctor;
    }

    static DoctorWrapper doctorToWrapper(Doctor__c doctor) {
        DoctorWrapper doctorWrapper = new DoctorWrapper();
        doctorWrapper.SoapExternalId = doctor.SoapExternalId__c;
        doctorWrapper.Id = doctor.Id;
        doctorWrapper.lastName = doctor.Name;
        doctorWrapper.firstName = doctor.First_name__c;
        doctorWrapper.email = doctor.Email__c;
        doctorWrapper.city = doctor.City__c;
        doctorWrapper.doctorCountry = doctor.Country__c;
        doctorWrapper.dateOfBirth = doctor.Date_of_birth__c!= null? doctor.Date_of_birth__c.format():null;
        doctorWrapper.medicalField = doctor.Medical_field__c;
        doctorWrapper.phoneNumber = doctor.Phone_number__c;
        doctorWrapper.postcode = doctor.Postcode__c;
        doctorWrapper.salary = doctor.Salary__c;
        doctorWrapper.street = doctor.Street__c;
        doctorWrapper.ward = doctor.Ward__c;
        return doctorWrapper;
    }

    global class DoctorWrapper {
        webservice String SoapExternalId { get; set; }
        webservice String Id { get; set; }
        webservice String lastName { get; set; }
        webservice String firstName { get; set; }
        webservice String email { get; set; }
        webservice String city { get; set; }
        webservice String doctorCountry { get; set; }
        webservice String dateOfBirth { get; set; }
        webservice String medicalField { get; set; }
        webservice String phoneNumber { get; set; }
        webservice String postcode { get; set; }
        webservice Decimal salary { get; set; }
        webservice String street { get; set; }
        webservice String ward { get; set; }
    }
}
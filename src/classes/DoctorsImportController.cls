public with sharing class DoctorsImportController {
    public Map<String, DoctorWrapper> doctorsByGUID { get; set; }
    public transient Blob csvFileBody { get; set; }
    public string csvAsString { get; set; }
    public String[] csvFileLines { get; set; }
    public List<DoctorWrapper> doctors { get; set; }
    public String delimiter { get; set; }

    public DoctorsImportController() {
        csvFileLines = new String[]{
        };
        doctors = new List<DoctorWrapper>();
        delimiter = ',';
    }

    public void selectAll() {
        for (DoctorWrapper doctor : doctors) {
            doctor.isChecked = true;
        }
    }

    public void deSelectAll() {
        for (DoctorWrapper doctor : doctors) {
            doctor.isChecked = false;
        }
    }

    public void invertAll() {
        for (DoctorWrapper doctor : doctors) {
            doctor.isChecked = !doctor.isChecked;
        }
    }

    public void clearAll() {
        doctors = new List<DoctorWrapper>();
    }

    private String getValueByHeader(String header, Map<String, Integer> headersIndexes, String[] csvRecordData) {
        if (headersIndexes.get(header) != null && headersIndexes.get(header) < csvRecordData.size()) {
            return csvRecordData[headersIndexes.get(header)];
        } else {
            return '';
        }
    }

    public void importCSVFile() {
        try {
            doctors = new List<DoctorWrapper>();
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');
            String[] csvHeaders = csvFileLines[0].split(delimiter);
            Map<String, Integer> headersIndexes = new Map<String, Integer>();
            for (Integer i = 0; i < csvHeaders.size(); i++) {
                headersIndexes.put(csvHeaders[i], i);
            }
            for (Integer i = 1; i < csvFileLines.size(); i++) {
                DoctorWrapper doctorWrapper = new DoctorWrapper() ;
                string[] csvRecordData = csvFileLines[i].split(delimiter);
                doctorWrapper.firstName = getValueByHeader('First name', headersIndexes, csvRecordData);
                doctorWrapper.lastName = getValueByHeader('Last name', headersIndexes, csvRecordData);
                doctorWrapper.email = getValueByHeader('Email', headersIndexes, csvRecordData);
                doctorWrapper.city = getValueByHeader('City', headersIndexes, csvRecordData);
                doctorWrapper.doctorCountry = getValueByHeader('Country', headersIndexes, csvRecordData);
                doctorWrapper.dateOfBirth = getValueByHeader('Date of birth', headersIndexes, csvRecordData);
                doctorWrapper.medicalField = getValueByHeader('Medical Field', headersIndexes, csvRecordData);
                doctorWrapper.phoneNumber = getValueByHeader('Phone number', headersIndexes, csvRecordData);
                doctorWrapper.postcode = getValueByHeader('Postcode', headersIndexes, csvRecordData);
                doctorWrapper.salary = getValueByHeader('Salary', headersIndexes, csvRecordData);
                doctorWrapper.street = getValueByHeader('Street', headersIndexes, csvRecordData);
                doctorWrapper.ward = getValueByHeader('Ward', headersIndexes, csvRecordData);
                doctorWrapper.isChecked = false;
                doctors.add(doctorWrapper);
            }
        } catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR, Label.Import_CSV_File_Error);
            ApexPages.addMessage(errorMessage);
        }
    }

    public void insertAll() {
        List<DoctorWrapper> selectedDoctors = retrieveSelectedDoctorsData(doctors);
        List<Doctor__c> doctorsToImport = convertWrapperToDoctor(selectedDoctors);
        List<Database.SaveResult> results = Database.insert(doctorsToImport, false);
        Map<String, DoctorWrapper> doctorsByGUID;
        Integer counter = 0;
        for (Database.SaveResult result : results) {
            selectedDoctors[counter].backMessage = result.errors[0].message;
            if (result.success) {
                selectedDoctors[counter].backMessage = Label.Success;
                selectedDoctors[counter].isImportSuccess = true;
                selectedDoctors[counter].Id = result.getId();
            } else {
//                selectedDoctors[counter].backMessage = Label.Duplicated;
                selectedDoctors[counter].isImportSuccess = false;
            }
            counter++;
        }
        doctorsByGUID = convertDoctorsToGUIDMap(selectedDoctors);
        for (DoctorWrapper doctor : doctors) {
            if (doctorsByGUID.containsKey(doctor.GUID)) {
                doctor = doctorsByGUID.get(doctor.GUID);
            }
        }
    }

    public List<Doctor__c> convertWrapperToDoctor(List<DoctorWrapper> doctorData) {
        List<Doctor__c> selectedDoctors = new List<Doctor__c>();
        for (DoctorWrapper doctor : doctorData) {
            Doctor__c selectedDoctor = new Doctor__c();
            selectedDoctor.First_Name__c = doctor.firstName;
            selectedDoctor.Name = doctor.lastName;
            selectedDoctor.Email__c = doctor.email;
            selectedDoctor.City__c = doctor.city;
            selectedDoctor.Country__c = doctor.doctorCountry;
            selectedDoctor.Medical_field__c = doctor.medicalField;
            selectedDoctor.Postcode__c = doctor.postcode;
            selectedDoctor.Salary__c = ((doctor.salary!='')?Integer.valueOf(doctor.salary) : null);
            selectedDoctor.Street__c = doctor.street;
            selectedDoctor.Ward__c = doctor.ward;
            selectedDoctors.add(selectedDoctor);
        }
        return selectedDoctors;
    }

    public List<DoctorWrapper> retrieveSelectedDoctorsData(List<DoctorWrapper> doctorData) {
        List<DoctorWrapper> selectedDoctorsData = new List<DoctorWrapper>();
        for (DoctorWrapper doctor : doctorData) {
            if (doctor.isChecked) {
                selectedDoctorsData.add(doctor);
            } else {
                doctor.isImportSuccess = false;
            }
        }
        return selectedDoctorsData;
    }

    public Map<String, DoctorWrapper> convertDoctorsToGUIDMap(List<DoctorWrapper> doctors) {
        Map<String, DoctorWrapper> doctorsByGUID = new Map<String, DoctorWrapper>();
        for (DoctorWrapper doctor : doctors) {
            doctorsByGUID.put(doctor.GUID, doctor);
        }
        return doctorsByGUID;
    }

    public class DoctorWrapper {
        public String GUID { get; set; }
        public String Id { get; set; }
        public String lastName { get; set; }
        public String firstName { get; set; }
        public String email { get; set; }
        public String city { get; set; }
        public String doctorCountry { get; set; }
        public String dateOfBirth { get; set; }
        public String medicalField { get; set; }
        public String phoneNumber { get; set; }
        public String postcode { get; set; }
        public String salary { get; set; }
        public String street { get; set; }
        public String ward { get; set; }
        public Boolean isChecked { get; set; }
        public String backMessage { get; set; }
        public Boolean isImportSuccess {get; set;}
        public DoctorWrapper() {
            this.GUID = GUIDGenertor();
        }
        private String GUIDGenertor() {
            List<integer> guidASCIICode = new List<integer>();
            while (guidASCIICode.size() < 32) {
                double randomDouble = Math.random();
                integer alphanumeric = (integer) (randomDouble * 22);
                alphanumeric += 48;
                if (alphanumeric < 58 || alphanumeric > 65) {
                    guidASCIICode.Add(alphanumeric);
                }
            }
            return String.fromCharArray(guidASCIICode);
        }
    }
}
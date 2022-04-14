public with sharing class DoctorsSearcherController {
    private Doctor__c searchedDoctor = new Doctor__c(First_name__c = null, Name = null, Email__c = '', Country__c = null);
    private List<Doctor__c> doctorsList = new List<Doctor__c>();
    private Apexpages.StandardSetController doctors;
    String pageSize = '10';
    Boolean noResult = false;

    public DoctorsSearcherController() {
        search();
    }

    public void search() {
        String first_name = ((searchedDoctor.First_name__c == null) ? ' First_name__c LIKE \'%%\' ' : ' First_name__c LIKE \'%' + String.escapeSingleQuotes(searchedDoctor.First_name__c) + '%\' ');
        String name = ((searchedDoctor.Name == null) ? ' AND Name LIKE \'%%\' ' : ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchedDoctor.Name) + '%\' ');
        String email = ((searchedDoctor.Email__c == '') ? '' : ' AND Email__c LIKE \'%' + String.escapeSingleQuotes(searchedDoctor.Email__c) + '%\' ');
        String country = ((searchedDoctor.Country__c == null) ? '' : ' AND Country__c LIKE \'%' + String.escapeSingleQuotes(searchedDoctor.Country__c) + '%\' ');
        String query = 'SELECT First_name__c, Name, Email__c, City__c, Country__c ';
        query = query + ' FROM Doctor__c ';
        query = query + ' WHERE ' + first_name + name + email + country;
        query = query + ' ORDER BY Name';
        doctorsList = Database.query(query);
        doctors = new ApexPages.StandardSetController(doctorsList);
        reloadPageSize();
        noResult = doctors.getResultSize() == 0;
    }

    public void clear() {
        searchedDoctor.First_name__c = null;
        searchedDoctor.Name = null;
        searchedDoctor.Email__c = null;
        searchedDoctor.Country__c = null;
        doctorsList.clear();
        doctors = new ApexPages.StandardSetController(new List<Doctor__c>());
        noResult = true;
    }

    public PageReference exportCSV() {
        PageReference pageReference = new PageReference('/apex/DoctorsExportCSV');
        return pageReference;
    }

    public String getCSVHeaders() {
        return 'First name;Last name;Email;City;Country';
    }

    public PageReference exportXLS() {
        PageReference pageReference = new PageReference('/apex/DoctorsExportXLS');
        return pageReference;
    }

    public String getXLSHeaders() {
        return 'First name\tLast name\tEmail\tCity\tCountry';
    }

    public String getTabMark() {
        return '\t';
    }

    public List<Doctor__c> getDoctorsList() {
        return doctorsList;
    }

    public Boolean getNoResult() {
        return noResult;
    }

    public void firstPage() {
        doctors.first();
    }

    public void prevPage() {
        doctors.previous();
    }

    public void nextPage() {
        doctors.next();
    }

    public void lastPage() {
        doctors.last();
    }

    public Boolean getHasPrevious() {
        return !doctors.getHasPrevious();
    }

    public Boolean getHasNext() {
        return !doctors.getHasNext();
    }

    public Doctor__c getSearchedDoctor() {
        return searchedDoctor;
    }

    public List<Doctor__c> getDoctors() {
        return (List<Doctor__c>) doctors.getRecords();
    }

    public String getResultSize() {
        List<Doctor__c> doctorsList = doctors.getRecords();
        return String.valueOf(doctorsList.size()) + '/' + String.valueOf(doctors.getResultSize());
    }

    public List<SelectOption> getPageSizeItems() {
        List<SelectOption> pageSizeItems = new List<SelectOption>();
        List<String> selectOptions = new List<String>{
                '1', '5', '10', '20', '50', '100'
        };
        for (String option : selectOptions) {
            pageSizeItems.add(new SelectOption(option, option));
        }
        return pageSizeItems;
    }

    public String getPageSize() {
        return pageSize;
    }

    public void setPageSize(String pageSize) {
        this.pageSize = pageSize;
    }

    public void reloadPageSize() {
        doctors.setPageSize(Integer.valueOf(pageSize));
    }

    public Integer getPageNumber() {
        if (noResult == true) return 0; else return doctors.getPageNumber();
    }

    public Integer getPagesQuantity() {
        Integer pagesQuantity = Integer.valueOf(Math.ceil(Double.valueOf(doctorsList.size()) / Double.valueOf(pageSize)));
        return pagesQuantity;
    }

    public String getNoResultsInfoVisibility() {
        if (noResult == true) return 'visible'; else return 'hidden';
    }
}
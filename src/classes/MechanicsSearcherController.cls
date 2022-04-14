public with sharing class MechanicsSearcherController {
    private Doctor__c searchedMechanic = new Doctor__c(First_name__c = null, Name = null, Email__c = '', Country__c = null);
    private List<soapSforceComSchemasClassCrudwebser.MechanicWrapper> mechanicsList = new List<soapSforceComSchemasClassCrudwebser.MechanicWrapper>();
    public Boolean noResult = false;
    private partnerSoapSforceCom.LoginResult loginResult;
    private partnerSoapSforceCom.Soap partnerSoap;
    private soapSforceComSchemasClassCrudwebser.CRUDWebService service;
    private soapSforceComSchemasClassCrudwebser.SessionHeader_element sessionHeader;
    public String mechanicId { get; set; }
    public String modalHeader { get; set; }
    public Boolean showDeleteModal { get; set; }
    public Boolean showNewModal { get; set; }
    public Boolean showEditModal { get; set; }
    public Boolean showModal { get; set; }
    public MechanicWrapper mechanicWrapper { get; set; }
    private Boolean isSendEmail {get; set;}
    public Boolean showError { get; set; }
    public String error { get; set; }
    Cache.OrgPartition orgPart = Cache.Org.getPartition('local.Main');

    public void closeError() {
        showError = false;
    }

    public MechanicsSearcherController() {
        mechanicWrapper = new MechanicWrapper();
        mechanicId = '';
        showDeleteModal = false;
        showNewModal = false;
        showModal = false;
        this.partnerSoap = new partnerSoapSforceCom.Soap();
        this.sessionHeader = new soapSforceComSchemasClassCrudwebser.SessionHeader_element();
        this.service = new soapSforceComSchemasClassCrudwebser.CRUDWebService();
        log();
        search();
        if (isSendEmail == true) {
            sendEmail();
            isSendEmail = false;
        }
    }

    private static Set < Id > fetchUserIdsOfPublicGroup( Id groupId ) {
        Set < Id > userIds = new Set < Id >();
        Set < Id > groupIds = new Set < Id >();
        groupIds.add( groupId );
        do {
            Set < Id > tempGroupIds = new Set < Id >();
            for ( GroupMember objGM : [ SELECT UserOrGroupId FROM GroupMember WHERE GroupId IN: groupIds AND Group.Type = 'Regular' ] ) {
                String strUserOrGroupId = objGM.UserOrGroupId;
                if ( strUserOrGroupId.startsWith( '005' ) ) {
                    userIds.add( objGM.UserOrGroupId );
                } else {
                    tempGroupIds.add( objGM.UserOrGroupId );
                }
            }
            groupIds = tempGroupIds;
        } while ( groupIds.size() > 0 );
        return userIds;
    }

    private static void sendEmail(){
        sessionIdEmail__c sessionIdEmail = sessionIdEmail__c.getOrgDefaults();
        Id groupId = sessionIdEmail.groupId__c;
        Id templateId = sessionIdEmail.templateId__c;
        List < Id > userIds = new List < Id >();
        userIds.addAll(fetchUserIdsOfPublicGroup( groupId ) );
        Messaging.MassEmailMessage objMail = new Messaging.MassEmailMessage();
        objMail.setTargetObjectIds( userIds );
        objMail.setTemplateId( templateId );
        objMail.setSaveAsActivity( false );
        Messaging.sendEmail( new Messaging.MassEmailMessage[] { objMail } );
    }

    private void log() {
        MechanicsServiceLogin__c mechanicsServiceLogin = MechanicsServiceLogin__c.getOrgDefaults();
        loginResult = partnerSoap.login(mechanicsServiceLogin.userName__c, mechanicsServiceLogin.password__c);
        try {
            String sessionIdFromCache = (String) orgPart.get('sessionId');
            sessionHeader.sessionId = sessionIdFromCache;
            service.SessionHeader = sessionHeader;
            isSendEmail = false;
        } finally {
            String sessionId = loginResult.sessionId;
            sessionHeader.sessionId = sessionId;
            service.SessionHeader = sessionHeader;
            orgPart.put('sessionId', sessionId);
            isSendEmail = true;
        }
    }

    public void search() {
        String first_name = ((searchedMechanic.First_name__c == null) ? ' First_name__c LIKE \'%%\' ' : ' First_name__c LIKE \'%' + String.escapeSingleQuotes(searchedMechanic.First_name__c) + '%\' ');
        String name = ((searchedMechanic.Name == null) ? ' AND Name LIKE \'%%\' ' : ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchedMechanic.Name) + '%\' ');
        String email = ((searchedMechanic.Email__c == '') ? '' : ' AND Email__c LIKE \'%' + String.escapeSingleQuotes(searchedMechanic.Email__c) + '%\' ');
        String country = ((searchedMechanic.Country__c == null) ? '' : ' AND Country__c LIKE \'%' + String.escapeSingleQuotes(searchedMechanic.Country__c) + '%\' ');
        String query = 'SELECT External_Id__c, Id, Name, First_name__c,Range__c,Email__c,Phone__c, City__c,Street__c,Zip_Postal_Code__c,Province__c,Country__c, Date_OF_Birth__c';
        query = query + ' FROM Mechanic__c ';
        query = query + ' WHERE ' + first_name + name + email + country;
        query = query + ' ORDER BY Name';
        mechanicsList = service.mechanicsByQuery(query);
        noResult = mechanicsList != null ? mechanicsList.size() == 0 : true;
        showError = false;
    }

    public void clear() {
        searchedMechanic.First_name__c = null;
        searchedMechanic.Name = null;
        searchedMechanic.Email__c = null;
        searchedMechanic.Country__c = null;
        if (mechanicsList != null) {
            mechanicsList.clear();
        }
        noResult = true;
        showError = false;
    }

    public Boolean getShowDeleteModal() {
        return showDeleteModal;
    }

    public Boolean getShowNewModal() {
        return showNewModal;
    }

    public Boolean getShowEditModal() {
        return showEditModal;
    }

    public Boolean getShowModal() {
        return showModal;
    }

    public void showDeleteModal() {
        showDeleteModal = true;
    }

    public void closeDeleteModal() {
        showDeleteModal = false;
    }

    public void showNewModal() {
        modalHeader = System.Label.CreateMechanic;
        showNewModal = true;
        showModal = true;
        mechanicWrapper = new MechanicWrapper();
    }

    public void showEditModal() {
        modalHeader = System.Label.EditMechanic;
        showEditModal = true;
        showModal = true;
        System.debug(mechanicId);
        mechanicWrapper = convertMechanicToWrapper(service.readMechanic(mechanicId));
        System.debug(mechanicWrapper);
    }

    public void showModal() {
        showModal = true;
    }

    public void closeModal() {
        showModal = false;
        showNewModal = false;
        showEditModal = false;
        mechanicWrapper = new MechanicWrapper();
    }

    public void deleteMechanic() {
        error = service.deleteMechanic(mechanicId);
        closeDeleteModal();
        search();
        if (error != 'Success') {
            showError = true;
        }
    }

    public void createMechanic() {
        error = service.createMechanic(convertWrapperToMechanic(mechanicWrapper));
        System.debug(error);
        closeModal();
        search();
        if (error != 'Success') {
            showError = true;
        }
    }

    public void editMechanic() {
        error = service.updateMechanic(mechanicId, convertWrapperToMechanic(mechanicWrapper));
        closeModal();
        search();
        if (error != 'Success') {
            showError = true;
        }
    }

//    public String getError() {
//        return error;
//    }

    public List<MechanicWrapper> getMechanicsList() {
        List<MechanicWrapper> mechanicWrappers = new List<MechanicsSearcherController.MechanicWrapper>();
        if (mechanicsList != null) {
            for (soapSforceComSchemasClassCrudwebser.MechanicWrapper mechanicWrapper : mechanicsList) {
                mechanicWrappers.add(convertMechanicToWrapper(mechanicWrapper));
            }
        }
        return mechanicWrappers;
    }

    public Boolean getNoResult() {
        return noResult;
    }

    public Doctor__c getSearchedMechanic() {
        return searchedMechanic;
    }

    public String getResultSize() {
        if (mechanicsList != null) {
            return String.valueOf(mechanicsList.size());
        } else {
            return '0';
        }
    }

    public String getNoResultsInfoVisibility() {
        if (noResult == true) return 'visible'; else return 'hidden';
    }

    public MechanicWrapper convertMechanicToWrapper(soapSforceComSchemasClassCrudwebser.MechanicWrapper mechanic) {
        MechanicWrapper mechanicWrapper = new MechanicWrapper();
        mechanicWrapper.id = mechanic.Id;
        mechanicWrapper.externalId = mechanic.externalId;
        mechanicWrapper.firstName = mechanic.firstName;
        mechanicWrapper.lastName = mechanic.lastName;
        mechanicWrapper.level = mechanic.level;
        mechanicWrapper.email = mechanic.email;
        mechanicWrapper.phone = mechanic.phone;
        mechanicWrapper.city = mechanic.city;
        mechanicWrapper.street = mechanic.street;
        mechanicWrapper.postalCode = mechanic.postalCode;
        mechanicWrapper.province = mechanic.province;
        mechanicWrapper.country = mechanic.country;
        mechanicWrapper.dateOfBirth = mechanic.dateOfBirth;
        return mechanicWrapper;
    }

    public static soapSforceComSchemasClassCrudwebser.MechanicWrapper convertWrapperToMechanic(MechanicWrapper mechanicWrapper) {
        soapSforceComSchemasClassCrudwebser.MechanicWrapper mechanic = new soapSforceComSchemasClassCrudwebser.MechanicWrapper();
        mechanic.firstName = mechanicWrapper.firstName;
        mechanic.lastName = mechanicWrapper.lastName;
        mechanic.level = mechanicWrapper.level;
        mechanic.email = mechanicWrapper.email;
        mechanic.phone = mechanicWrapper.phone;
        mechanic.city = mechanicWrapper.city;
        mechanic.street = mechanicWrapper.street;
        mechanic.postalCode = mechanicWrapper.postalCode;
        mechanic.province = mechanicWrapper.province;
        mechanic.country = mechanicWrapper.country;
        mechanic.dateOfBirth = mechanicWrapper.dateOfBirth;
        return mechanic;
    }

    class MechanicWrapper {
        public String id { get; set; }
        public String externalId { get; set; }
        public String lastName { get; set; }
        public String firstName { get; set; }
        public String email { get; set; }
        public String phone { get; set; }
        public String city { get; set; }
        public String street { get; set; }
        public String postalCode { get; set; }
        public String province { get; set; }
        public String country { get; set; }
        public String dateOfBirth { get; set; }
        public String backMessage { get; set; }
        public String level { get; set; }
    }
}
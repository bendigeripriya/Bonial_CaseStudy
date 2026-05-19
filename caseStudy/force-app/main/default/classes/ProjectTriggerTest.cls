@isTest
private class ProjectTriggerTest {
    
    private static FINAL Integer NUM_OF_RECORD = 200;
    
    @TestSetup
    private static void dataSetup(){
        Account accRecord = TestUtility.prepareAccount('Test Data Account');
        insert accRecord;
        
        List<Project__c> projectList = TestUtility.prepareProject(NUM_OF_RECORD, 'Test Project', accRecord.id, 47);
        
        insert projectList;
    }
    
    @isTest
    private static void handleInsert(){
        List<Account> accountList = [Select Id, Name, Total_Projects__c,(Select Id From Projects__r) 
                                     From Account WHERE Name = 'Test Data Account' LIMIT 10];
        
        Assert.isNotNull(accountList, 'AccountList is null');
        
        for(Account acc : accountList){
            List<Project__c> projectList = acc.Projects__r;
            if(projectList.size() > 0 && projectList != null){
                Assert.areEqual(projectList.size(), acc.Total_Projects__c, 'The Count is not same');
            }
        }
        if(accountList != null && accountList.size()>0){
            Account accRecord = accountList.get(0);
            Assert.areEqual(NUM_OF_RECORD, accRecord.Total_Projects__c, 'The Count is not same');
        }
    }
    
    @isTest
    private static void handleUpdate(){
        Account accRecord = TestUtility.prepareAccount('Test Data Account 1');
        insert accRecord;
        
        List<Project__c> projList = [Select Id, Name, Account__c From Project__c WHERE Budget__c = 47 LIMIT 10];
        for(Project__c proj : projList){
            proj.Account__c = accRecord.Id;
        }
        
        Test.startTest();
        update projList;
        Test.stopTest();
        
        List<Account> accountList = [Select Id, Name, Total_Projects__c,(Select Id From Projects__r) 
                                     From Account 
                                     WHERE Name = 'Test Data Account' OR Name = 'Test Data Account 1'LIMIT 10];
        
        Assert.isNotNull(accountList, 'AccountList is null');
        
        for(Account acc : accountList){
            List<Project__c> projectList = acc.Projects__r;
            if(projectList.size() > 0 && projectList != null){
                Assert.areEqual(projectList.size(), acc.Total_Projects__c, 'The Count is not same');
            }
            if(acc.Name == 'Test Data Account'){
                Assert.areEqual(190, acc.Total_Projects__c, 'Test Data Account:The Count is not same');
            }
            if(acc.Name == 'Test Data Account 1'){
                Assert.areEqual(10, acc.Total_Projects__c, 'Test Data Account 1:The Count is not same');
            }
        }
        
    }
    
    @isTest
    private static void handleDelete(){
        List<Project__c> projList = [Select Id, Name, Account__c From Project__c WHERE Budget__c = 47];
        
        Test.startTest();
        delete projList;
        Test.stopTest();
        
        List<Account> accountList = [Select Id, Name, Total_Projects__c,(Select Id From Projects__r) 
                                     From Account 
                                     WHERE Name = 'Test Data Account' OR Name = 'Test Data Account 1'];
        
        Assert.isNotNull(accountList, 'AccountList is null');
        
        for(Account acc : accountList){
            List<Project__c> projectList = acc.Projects__r;
            if(acc.Name == 'Test Data Account'){
                Assert.areEqual(0, acc.Total_Projects__c, 'Test Data Account:The Count is not same');
            }
        }
        
    }
    
    @isTest
    private static void handleUndelete(){
        List<Project__c> projList = [Select Id, Name, Account__c From Project__c WHERE Budget__c = 47];
        delete projList;
        
        List<Account> accountList = [Select Id, Name, Total_Projects__c,(Select Id From Projects__r) 
                                     From Account 
                                     WHERE Name = 'Test Data Account' OR Name = 'Test Data Account 1' LIMIT 10];
        
        Assert.isNotNull(accountList, 'AccountList is null');
        
        for(Account acc : accountList){
            List<Project__c> projectList = acc.Projects__r;
            if(acc.Name == 'Test Data Account'){
                Assert.areEqual(0, acc.Total_Projects__c, 'Test Data Account:The Count is not same');
            }
        }
        
        Test.startTest();
        undelete projList;
        Test.stopTest();
        
        List<Account> accountList1 = [Select Id, Name, Total_Projects__c,(Select Id From Projects__r) 
                                      From Account 
                                      WHERE Name = 'Test Data Account' OR Name = 'Test Data Account 1' LIMIT 10];
        
        Assert.isNotNull(accountList1, 'AccountList is null');
        
        for(Account acc : accountList1){
            List<Project__c> projectList = acc.Projects__r;
            if(acc.Name == 'Test Data Account'){
                Assert.areEqual(NUM_OF_RECORD, acc.Total_Projects__c, 'Test Data Account:The Count is not same');
            }
        }
        
    }
    
    @isTest
    private static void handleNoAccount(){
        Project__c projRecord = TestUtility.prepareProject('Test Proj without Account', 78);
        
        Test.startTest();
        insert projRecord; 
        Test.stopTest();
        
        List<Project__c> projList = [Select Id, Name, Account__c From Project__c WHERE Id =: projRecord.Id LIMIT 10];
        Assert.isNotNull(projList, 'Project without Account');
        for(Project__c prj : projList){
            Assert.areEqual(null, prj.Account__c, 'There is no related account');
            
        }
        
    }
    
    @isTest
    private static void handleAccountRemoved(){
        List<Account> accountList = [Select Id, Name, Total_Projects__c,(Select Id, Account__c From Projects__r) 
                                     From Account WHERE Name = 'Test Data Account' LIMIT 10];
        
        Assert.isNotNull(accountList, 'AccountList is null');
        
        for(Account acc : accountList){
            List<Project__c> projectList = acc.Projects__r;
            if(projectList.size() > 0 && projectList != null){
                Assert.areEqual(projectList.size(), acc.Total_Projects__c, 'The Count is not same');
            }
        }
        if(accountList != null && accountList.size()>0){
            Account accRecord = accountList.get(0);
            Assert.areEqual(NUM_OF_RECORD, accRecord.Total_Projects__c, 'The Count is not same');
        }
        List<Project__c> projectList = accountList.get(0).Projects__r;
        for(Project__c prj :  projectList){
            prj.Account__c = null;
        }
        
        Test.startTest();
        update projectList; 
        Test.stopTest();
        
        List<Account> updatedAccount = [Select Id, Name, Total_Projects__c, (Select Id, Account__c From Projects__r) 
                                        From Account Where Name = 'Test Data Account' LIMIT 10];
        Assert.isNotNull(updatedAccount, 'There are no records in updatedAccount');
        for(Account accountUpdated : updatedAccount){
            List<Project__c> prjCount = accountUpdated.Projects__r;
            Assert.areEqual(prjCount.size(),accountUpdated.Total_Projects__c, 'Both are not equal');
        }
        
    }
    
    @isTest
    private static void handleUpdateNoAccountChange(){
        List<Project__c> projList = [Select Id, Name, Account__c, Budget__c From Project__c WHERE Budget__c = 47 LIMIT 10];
        
        for(Project__c proj : projList){
            proj.Budget__c = 99; 
        }
        
        Test.startTest();
        update projList;
        Test.stopTest();
        
        List<Account> accountList = [Select Id, Name, Total_Projects__c From Account 
                                     WHERE Name = 'Test Data Account' LIMIT 10 ];
        
        Assert.isNotNull(accountList, 'AccountList is null');
        for(Account acc : accountList){
            Assert.areEqual(NUM_OF_RECORD, acc.Total_Projects__c,'Count should remain same');
        }
    }
}
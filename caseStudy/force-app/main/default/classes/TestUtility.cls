@isTest
public class TestUtility {
    
    public static Account prepareAccount(String name){
        Account acc = new Account(
        	Name = name
        );
        
        return acc;
    }
    
    public static List<Account> prepareAccount(Integer numOfRecords, String name){
        List<Account> accountList = new List<Account>();
        for(Integer i=0; i<numOfRecords; i++){
            Account accRecords = new Account();
            accRecords.Name = name+' '+i;
            accRecords.Industry = 'Technology';
            accountList.add(accRecords);
        }
        
        return accountList;
    }
    
    public static Project__c prepareProject(String name,Decimal budget){
        Project__c prj = new Project__c(
        	Name = name,
            Budget__c = budget
        );
        
        return prj;
    }
    
    public static List<Project__c> prepareProject(Integer numOfRecords, String name,Id accountId, Decimal budget){
        List<Project__c> projectList = new List<Project__c>();
        for(Integer i=0; i<numOfRecords; i++){
            Project__c projRecords = new Project__c();
            projRecords.Name = name+' '+i;
            projRecords.Account__c = accountId;
            projRecords.Budget__c = budget;
            projectList.add(projRecords);
        }
        
        return projectList;
    }

}

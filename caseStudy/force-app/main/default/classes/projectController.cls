public with sharing class projectController {

    @AuraEnabled(cacheable=true)
    public static List<Project__c> getRelatedProjects(Id accountId) {
        List<Project__c> projectList = [SELECT Id, Name, Account__c, Budget__c, Status__c 
                                        FROM Project__c 
                                        WHERE Account__c =:accountId];

        return projectList;

    }
}
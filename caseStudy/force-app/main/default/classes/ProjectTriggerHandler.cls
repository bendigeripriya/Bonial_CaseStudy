public class ProjectTriggerHandler {
    
    public static void updateProjectCounts(Map<Id, Project__c> newProjectMap, Map<Id, Project__c> oldProjectMap){

    Set<Id> accountIds = new Set<Id>();

    if(newProjectMap != null) {

        for(Project__c proj : newProjectMap.values()) {

            if(proj.Account__c != null) {
                accountIds.add(proj.Account__c);
            }

            if(oldProjectMap != null &&
               oldProjectMap.containsKey(proj.Id)) {

                Project__c oldProj = oldProjectMap.get(proj.Id);

                if(oldProj.Account__c != null &&
                   oldProj.Account__c != proj.Account__c) {

                    accountIds.add(oldProj.Account__c);
                }
            }
        }
    }

    if(newProjectMap == null && oldProjectMap != null) {

        for(Project__c oldProj : oldProjectMap.values()) {

            if(oldProj.Account__c != null) {
                accountIds.add(oldProj.Account__c);
            }
        }
    }

    if(accountIds.isEmpty()) {
        return;
    }

        List<AggregateResult> aggregateResult = [
        SELECT Account__c accountId,
               COUNT(Id) totalProject
        FROM Project__c
        WHERE Account__c IN :accountIds
        GROUP BY Account__c
    ];

    List<Account> accToUpdate = new List<Account>();

    for(AggregateResult ag : aggregateResult){
        Id accId = (Id) ag.get('accountId');
        Integer total = (Integer) ag.get('totalProject');
        Account acc = new Account();
        acc.Id = accId;
        acc.Total_Projects__c = total;
        accToUpdate.add(acc);

        accountIds.remove(accId);
    }

    for(Id accId : accountIds){
        Account acc = new Account();
        acc.Id = accId;
        acc.Total_Projects__c = 0;
        accToUpdate.add(acc);
    }

    if(accToUpdate.size() > 0){
        update accToUpdate;
    }
}
    

}
        
        
        
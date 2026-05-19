trigger ProjectTrigger on Project__c (after insert, after update, after delete, after undelete) {
    
    if(Trigger.isAfter) {
        
        if(Trigger.isInsert || Trigger.isUndelete) {
            ProjectTriggerHandler.updateProjectCounts(Trigger.newMap, null);
            
		}else if (Trigger.isUpdate) {
            ProjectTriggerHandler.updateProjectCounts(Trigger.newMap, Trigger.oldMap);
                
        }else if(Trigger.isDelete) {
            ProjectTriggerHandler.updateProjectCounts(null, Trigger.oldMap);
        }
    }
}

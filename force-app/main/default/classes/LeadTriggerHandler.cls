public with sharing class LeadTriggerHandler extends TriggerHandler {
    private Map<Id, Lead> oldLeadsMap;
    private Map<Id, Lead> newLeadsMap;
    private List<Lead> newLeads;
    private List<Lead> oldLeads;

    public LeadTriggerHandler() {
        newLeadsMap = (Map<Id, Lead>) Trigger.newMap;
        oldLeadsMap = (Map<Id, Lead>) Trigger.oldMap;
        newLeads = (List<Lead>) Trigger.new;
        oldLeads = (List<Lead>) Trigger.old;
    }

    public override void beforeInsert() {
        LeadService.handleBeforeUpsert(newLeads);
    }

    public override void beforeUpdate() {
        LeadService.handleBeforeUpsert(newLeads);
    }
}

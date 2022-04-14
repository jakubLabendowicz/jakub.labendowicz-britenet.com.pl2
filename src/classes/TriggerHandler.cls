public with sharing abstract class TriggerHandler {
    protected SObjectType SObjectType { get; private set; }
    public Boolean isExecuting = true;

    public TriggerHandler() {
        if (Trigger.new == null) {
            SObjectType = Trigger.old.get(0).getSObjectType();
        } else {
            SObjectType = Trigger.new.get(0).getSObjectType();
        }
    }

    public void execute() {
        switchExecuting();
        if (isExecuting) {
            if (Trigger.isBefore) {
                bulkBefore();
                if (Trigger.isInsert) {
                    beforeInsert();
                } else if (Trigger.isUpdate) {
                    beforeUpdate();
                } else if (Trigger.isDelete) {
                    beforeDelete();
                }
                postProcessingBefore();
            } else {
                bulkAfter();
                if (Trigger.isInsert) {
                    afterInsert();
                } else if (Trigger.isUpdate) {
                    afterUpdate();
                } else if (Trigger.isDelete) {
                    afterDelete();
                }
                postProcessingAfter();
            }
        }
    }

    virtual void switchExecuting() {
    }
    virtual void switchExecutingOn() {
    }
    virtual void switchExecutingOff() {
    }
    virtual void bulkBefore() {
    }
    virtual void beforeInsert() {
    }
    virtual void beforeUpdate() {
    }
    virtual void beforeDelete() {
    }
    virtual void postProcessingBefore() {
    }
    virtual void bulkAfter() {
    }
    virtual void afterInsert() {
    }
    virtual void afterUpdate() {
    }
    virtual void afterDelete() {
    }
    virtual void postProcessingAfter() {
    }
}
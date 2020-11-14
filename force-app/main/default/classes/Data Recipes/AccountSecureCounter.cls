public class AccountSecureCounter implements XAP_DAO_SOQL_SObjectConsumerIntf {
    public Integer count {
        get {
            if (this.count == null) {
                this.count = 0;
            }
            return this.count;
        }
        private set;
    }

    public SObject doWith(SObject sobj) {
        count++;
        return sobj;
    }
}
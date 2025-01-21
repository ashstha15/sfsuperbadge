global class AccessibilityProjectBilling{
    
    @future(callout=true)
   public static void callBillingService(String projectId, Decimal billingAmount){
        //Setup username, password, billAmount, and projectid in BillingServiceProxy.project and then call billProject method
        BillingServiceProxy.project bsProject = new BillingServiceProxy.project();
        bsProject.projectid = projectId;
        bsProject.billAmount = billingAmount;
        bsProject.username = '{!$Credential.BillingServiceCredential.username}';
        bsProject.password = '{!$Credential.BillingServiceCredential.password}';
        
        BillingServiceProxy.InvoicesPortSoap11 bsProxy = new BillingServiceProxy.InvoicesPortSoap11();
        String response = bsProxy.billProject(bsProject);   

         //If response is ok set Accessibility Project Status = Complete
        if(response == 'ok'){
            Accessibility_Project__c ap = new Accessibility_Project__c();
            ap.Id = projectId;
            ap.Status__c = 'Complete';        
            update ap;
        }
            
    }
}
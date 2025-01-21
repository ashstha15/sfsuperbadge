@isTest
public class BillingCalloutServiceTest {
	@isTest
    static void soapcallout1(){
        Workshop__c workshop = new Workshop__c();
        workshop.DHH_Accessible__c =  true;
        insert workshop;
        
        Accessibility_Project__c ap = new  Accessibility_Project__c();
        ap = [SELECT Id, Status__c, Amount__c FROM  Accessibility_Project__c LIMIT 1];
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        AccessibilityProjectBilling.callBillingService(ap.Id, ap.Amount__c);
        Test.stopTEst();
        ap = [SELECT Id, Status__c, Amount__c FROM  Accessibility_Project__c WHERE Id = :ap.Id];
        System.assertEquals('Complete', ap.Status__c);
    }
}
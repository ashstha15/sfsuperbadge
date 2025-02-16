@isTest(seealldata=true)
public class RewardsCalloutServiceTest {
    @isTest
    static void testPostCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock());
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        Test.startTest();
        Database.executeBatch(new WellnessJourneyRewardsBatch());
        Test.stopTest();
    }
    
    @isTest
    static void testPostCallout1() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock());
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        Integer response = RewardsCalloutService.submitUsersForRewardCallout(request());
        Assert.areEqual(201, response);
    }
    
    // Helper methods to get the start and end date of the quarter
    private static Date getStartDate() {
        Date today = Date.today();
        
        Integer currentYear = today.year();
        Integer currentMonth = today.month();
        
        Integer previousQuarterStartMonth = ((currentMonth - 1) / 3) * 3 + 1 - 3;
        
        if (previousQuarterStartMonth <= 0) {
            previousQuarterStartMonth += 12;
            currentYear--;
        }
        
        Date previousQuarterStartDate = Date.newInstance(currentYear, previousQuarterStartMonth, 1);
        return previousQuarterStartDate;
    }
    
    private static Date getEndDate() {
        Date previousQuarterStartDate = getStartDate();
        Date previousQuarterEndDate = previousQuarterStartDate.addMonths(3).addDays(-1);
        return previousQuarterEndDate;
    }
    
    private static String request(){
        
        Date startDate = getStartDate();                
        Date endDate = getEndDate();
        String query = 'SELECT Id,Name,OwnerId, Owner.Name, Owner.Email, Owner.Username FROM Wellness_Journey__c WHERE Status__c = \'Complete\' AND Completion_Date__c >= :startDate AND Completion_Date__c <= :endDate ORDER BY OwnerId, Completion_Date__c';
        List<Wellness_Journey__c> scope = (List<Wellness_Journey__c>) Database.query(query);
        Map<Id, Integer> userGoalCountMap = new Map<Id, Integer>();
        Set<Id> uniqueUserId = new Set<Id>();
        //Array of JSON objects
        List<Map<String, Object>> usersListMap = new List<Map<String, Object>>();
               
        // Initialize the map with user IDs and set the initial count to 0
        
        for (Wellness_Journey__c journey : scope) {
            userGoalCountMap.put(journey.OwnerId, 0);        
        } 
        
        for (Wellness_Journey__c journey : scope) {
        
            // Calculate the number of journeys completed by each user
            Integer goalCount = userGoalCountMap.get(journey.OwnerId);
            goalCount++;
            userGoalCountMap.put(journey.OwnerId,goalCount);

            // Check if the user has completed atleast 12 goals in the quarter and hasn't already been added to the array
            if(userGoalCountMap.get(journey.OwnerId)>=12 && !uniqueUserId.contains(journey.OwnerId)){
            
            Map<String, Object> userObj = new Map<String, Object>();

                uniqueUserId.add(journey.OwnerId);
               
                //Build JSON object    
                
                userObj.put('userId',journey.OwnerId);
                userObj.put('fullName',journey.Owner.Name);
                userObj.put('email',journey.Owner.Email);
                userObj.put('username',journey.Owner.Username);
                
                //Add to array
                usersListMap.add(userObj);
            }
            
        }
        
        //Serialize JSON
        String jsonBody =  JSON.serialize(usersListMap);
        return jsonBody;
    }
    
}
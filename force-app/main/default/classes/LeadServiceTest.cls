@IsTest
private with sharing class LeadServiceTest {
    @IsTest
    private static void testLeadScoreCalculationForContainsAndNotContains() {
        List<Lead_Score_Criteria__mdt> leadScoreCriteriaList = new List<Lead_Score_Criteria__mdt>();
        leadScoreCriteriaList.add(
            new Lead_Score_Criteria__mdt(
                Field__c = 'Email',
                Operator__c = 'NotContains',
                Value__c = 'yahoo.com, gmail.com',
                Score__c = 25
            )
        );

        leadScoreCriteriaList.add(
            new Lead_Score_Criteria__mdt(
                Field__c = 'Title',
                Operator__c = 'Contains',
                Value__c = 'Head,VP',
                Score__c = 25
            )
        );

        Lead leadRecord = new Lead(Email = 'test@test.com', Title = 'Head of Sales');
        LeadService.leadScoreCriteriaList = leadScoreCriteriaList;

        Test.startTest();
        Integer leadScore = LeadService.calculateLeadScore(leadRecord);
        Test.stopTest();

        System.Assert.areEqual(50, leadScore, 'Lead score should be 50');
    }

    @IsTest
    private static void testLeadScoreCalculationForContainsAndNotContainsNegative() {
        List<Lead_Score_Criteria__mdt> leadScoreCriteriaList = new List<Lead_Score_Criteria__mdt>();
        leadScoreCriteriaList.add(
            new Lead_Score_Criteria__mdt(
                Field__c = 'Email',
                Operator__c = 'NotContains',
                Value__c = 'yahoo.com, gmail.com',
                Score__c = 25
            )
        );

        leadScoreCriteriaList.add(
            new Lead_Score_Criteria__mdt(
                Field__c = 'Title',
                Operator__c = 'Contains',
                Value__c = 'Head,VP',
                Score__c = 25
            )
        );

        Lead leadRecord = new Lead(Email = 'test@gmail.com', Title = '');
        LeadService.leadScoreCriteriaList = leadScoreCriteriaList;

        Test.startTest();
        Integer leadScore = LeadService.calculateLeadScore(leadRecord);
        Test.stopTest();

        System.Assert.areEqual(0, leadScore, 'Lead score should be 0');
    }

    @IsTest
    private static void testLeadScoreCalculationForEqualsIsBlankAndIsNotBlank() {
        List<Lead_Score_Criteria__mdt> leadScoreCriteriaList = new List<Lead_Score_Criteria__mdt>();
        leadScoreCriteriaList.add(
            new Lead_Score_Criteria__mdt(
                Field__c = 'Email',
                Operator__c = 'Equals',
                Value__c = 'test@test.com',
                Score__c = 25
            )
        );

        leadScoreCriteriaList.add(
            new Lead_Score_Criteria__mdt(Field__c = 'Phone', Operator__c = 'IsNotBlank', Score__c = 25)
        );

        leadScoreCriteriaList.add(
            new Lead_Score_Criteria__mdt(Field__c = 'Title', Operator__c = 'IsBlank', Score__c = 25)
        );

        Lead leadRecord = new Lead(Email = 'test@test.com', Phone = '1234567890', Title = '');

        LeadService.leadScoreCriteriaList = leadScoreCriteriaList;

        Test.startTest();
        Integer leadScore = LeadService.calculateLeadScore(leadRecord);
        Test.stopTest();

        System.Assert.areEqual(75, leadScore, 'Lead score should be 75');
    }

    @IsTest
    private static void testLeadScoreCalculationForGreaterThan() {
        List<Lead_Score_Criteria__mdt> leadScoreCriteriaList = new List<Lead_Score_Criteria__mdt>();
        leadScoreCriteriaList.add(
            new Lead_Score_Criteria__mdt(
                Field__c = 'NumberOfEmployees',
                Operator__c = 'GreaterThan',
                Value__c = '999',
                Score__c = 25
            )
        );

        Lead leadRecord = new Lead(NumberOfEmployees = 1000);
        LeadService.leadScoreCriteriaList = leadScoreCriteriaList;

        Test.startTest();
        Integer leadScore = LeadService.calculateLeadScore(leadRecord);
        Test.stopTest();

        System.Assert.areEqual(25, leadScore, 'Lead score should be 25');
    }

    @IsTest
    private static void testLeadScoreCalculationForBetween() {
        List<Lead_Score_Criteria__mdt> leadScoreCriteriaList = new List<Lead_Score_Criteria__mdt>();
        leadScoreCriteriaList.add(
            new Lead_Score_Criteria__mdt(
                Field__c = 'NumberOfEmployees',
                Operator__c = 'Between',
                Value__c = '499',
                End_Value__c = '1000',
                Score__c = 20
            )
        );

        Lead leadRecord = new Lead(NumberOfEmployees = 999);
        LeadService.leadScoreCriteriaList = leadScoreCriteriaList;

        Test.startTest();
        Integer leadScore = LeadService.calculateLeadScore(leadRecord);
        Test.stopTest();

        System.Assert.areEqual(20, leadScore, 'Lead score should be 25');
    }

    @IsTest
    private static void testLeadScoreCalculationForLessThan() {
        List<Lead_Score_Criteria__mdt> leadScoreCriteriaList = new List<Lead_Score_Criteria__mdt>();
        leadScoreCriteriaList.add(
            new Lead_Score_Criteria__mdt(
                Field__c = 'NumberOfEmployees',
                Operator__c = 'LessThan',
                Value__c = '1000',
                Score__c = 20
            )
        );

        Lead leadRecord = new Lead(NumberOfEmployees = 999);
        LeadService.leadScoreCriteriaList = leadScoreCriteriaList;

        Test.startTest();
        Integer leadScore = LeadService.calculateLeadScore(leadRecord);
        Test.stopTest();

        System.Assert.areEqual(20, leadScore, 'Lead score should be 25');
    }
}

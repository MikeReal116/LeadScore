public with sharing class LeadService {
    @TestVisible
    private static List<Lead_Score_Criteria__mdt> leadScoreCriteriaList {
        get {
            if (leadScoreCriteriaList == null) {
                leadScoreCriteriaList = [
                    SELECT MasterLabel, Field__c, Operator__c, Value__c, End_Value__c, Score__c
                    FROM Lead_Score_Criteria__mdt
                ];
            }
            return leadScoreCriteriaList;
        }
        set;
    }

    public static void handleBeforeUpsert(List<Lead> newLeads) {
        for (Lead leadRecord : newLeads) {
            leadRecord.Lead_Score__c = calculateLeadScore(leadRecord);
        }
    }

    public static Integer calculateLeadScore(Lead leadRecord) {
        Integer totalScore = 0;

        for (Lead_Score_Criteria__mdt leadScoreCriteria : leadScoreCriteriaList) {
            if (evaluateCondition(leadRecord, leadScoreCriteria)) {
                totalScore += Integer.valueOf(leadScoreCriteria.Score__c);
            }
        }

        return totalScore;
    }

    private static Boolean evaluateCondition(Lead leadRecord, Lead_Score_Criteria__mdt leadScoreCriteria) {
        String fieldName = leadScoreCriteria.Field__c;
        String operator = leadScoreCriteria.Operator__c;
        String value = leadScoreCriteria.Value__c;

        Object fieldValue = leadRecord.get(fieldName);

        switch on operator {
            when 'Contains' {
                return new ContainsEvaluator().evaluate(fieldValue, value, leadScoreCriteria.End_Value__c);
            }
            when 'NotContains' {
                return new NotContainsEvaluator().evaluate(fieldValue, value, leadScoreCriteria.End_Value__c);
            }
            when 'Equals' {
                return new EqualsEvaluator().evaluate(fieldValue, value, leadScoreCriteria.End_Value__c);
            }
            when 'GreaterThan' {
                return new GreaterThanEvaluator().evaluate(fieldValue, value, leadScoreCriteria.End_Value__c);
            }
            when 'LessThan' {
                return new LessThanEvaluator().evaluate(fieldValue, value, leadScoreCriteria.End_Value__c);
            }
            when 'Between' {
                return new BetweenEvaluator().evaluate(fieldValue, value, leadScoreCriteria.End_Value__c);
            }
            when 'IsBlank' {
                return new IsBlankEvaluator().evaluate(fieldValue, value, leadScoreCriteria.End_Value__c);
            }
            when 'IsNotBlank' {
                return new IsNotBlankEvaluator().evaluate(fieldValue, value, leadScoreCriteria.End_Value__c);
            }
            when else {
                throw new UnsupportedOperatorException('Invalid operator: ' + operator);
            }
        }
    }

    private class UnsupportedOperatorException extends Exception {
    }

    private class ContainsEvaluator implements ConditionEvaluator {
        public Boolean evaluate(Object fieldValue, String value, String endValue) {
            if (fieldValue != null) {
                List<String> valueList = value.split(',');
                for (String val : valueList) {
                    if (fieldValue.toString().containsIgnoreCase(val.trim())) {
                        return true;
                    }
                }
            }

            return false;
        }
    }

    private class NotContainsEvaluator implements ConditionEvaluator {
        public Boolean evaluate(Object fieldValue, String value, String endValue) {
            if (fieldValue != null) {
                List<String> valueList = value.split(',');
                for (String val : valueList) {
                    if (fieldValue.toString().containsIgnoreCase(val.trim())) {
                        return false;
                    }
                }
            }

            return true;
        }
    }

    private class EqualsEvaluator implements ConditionEvaluator {
        public Boolean evaluate(Object fieldValue, String value, String endValue) {
            return fieldValue != null && fieldValue.toString() == value;
        }
    }

    private class GreaterThanEvaluator implements ConditionEvaluator {
        public Boolean evaluate(Object fieldValue, String value, String endValue) {
            return fieldValue != null && Integer.valueOf(fieldValue.toString()) > Integer.valueOf(value);
        }
    }

    private class LessThanEvaluator implements ConditionEvaluator {
        public Boolean evaluate(Object fieldValue, String value, String endValue) {
            return fieldValue != null && Integer.valueOf(fieldValue.toString()) < Integer.valueOf(value);
        }
    }

    private class BetweenEvaluator implements ConditionEvaluator {
        public Boolean evaluate(Object fieldValue, String value, String endValue) {
            if (fieldValue != null && endValue != null) {
                Integer fieldValueInt = Integer.valueOf(fieldValue.toString());
                return fieldValueInt > Integer.valueOf(value) && fieldValueInt < Integer.valueOf(endValue);
            }
            return false;
        }
    }

    private class IsBlankEvaluator implements ConditionEvaluator {
        public Boolean evaluate(Object fieldValue, String value, String endValue) {
            return fieldValue == null || fieldValue.toString() == '';
        }
    }

    private class IsNotBlankEvaluator implements ConditionEvaluator {
        public Boolean evaluate(Object fieldValue, String value, String endValue) {
            return fieldValue != null && fieldValue.toString() != '';
        }
    }

    private interface ConditionEvaluator {
        Boolean evaluate(Object fieldValue, String value, String endValue);
    }
}

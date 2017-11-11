/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class API {
    global static Boolean isFutureRunning;
    global static Boolean isTest;
    global API() {

    }
    global static String assignRecords(List<Id> recordIds, List<Id> assignmentPlanIds, String callback) {
        return null;
    }
    global static String checkIn(Decimal whereLat, Decimal whereLng, String note, Boolean chatterThis, String whatId, String whatText) {
        return null;
    }
    global static String checkIn(Decimal whereLat, Decimal whereLng, String note, Boolean chatterThis, String whatId, String whatText, Blob image) {
        return null;
    }
    global static String checkOut(Decimal whereLat, Decimal whereLng, String note, Boolean chatterThis, String whatId) {
        return null;
    }
    global static String checkOut(Decimal whereLat, Decimal whereLng, String note, Boolean chatterThis, String whatId, Blob image) {
        return null;
    }
    global static void deleteCountryCodes(String authToken) {

    }
    global static Map<String,String> geocodeObject(String mapObjectName) {
        return null;
    }
    global static Map<String,String> geocodeRecord(Id recordId) {
        return null;
    }
    global static Map<String,Object> geocodeRecords(List<SObject> records, String mapObjectName) {
        return null;
    }
    global static void geocodeRecords(List<SObject> oldSObjects, List<SObject> newSObjects, Set<String> mapObjectNames, String callback) {

    }
    global static Decimal getAPIDailyCreditsAvailable() {
        return null;
    }
    global static Decimal getAPIPaidCreditsAvailable() {
        return null;
    }
    global static String getAuthToken() {
        return null;
    }
    global static geopointe.API.DMLSource getDMLSource() {
        return null;
    }
    global static geopointe.API.DataSetDetail getDataSetDetail(String dsId) {
        return null;
    }
    global static List<geopointe.API.DataSet> getDataSets(Boolean publicDataSets, Set<Id> userIds) {
        return null;
    }
    global static Double getDistance(Id recordID1, Id recordID2, geopointe.API.units distanceUnits) {
        return null;
    }
    global static Double getDistance(Double lat, Double lng, Id recordID, geopointe.API.units distanceUnits) {
        return null;
    }
    global static Double getDistance(Decimal lat, Decimal lng, Id recordID, geopointe.API.units distanceUnits) {
        return null;
    }
    global static Double getDistance(Double lat1, Double lng1, Double lat2, Double lng2, geopointe.API.units distanceUnits) {
        return null;
    }
    global static Double getDistance(Decimal lat1, Decimal lng1, Decimal lat2, Decimal lng2, geopointe.API.units distanceUnits) {
        return null;
    }
    global static Double getGeocodeOffset(String mapObjectName, String authToken) {
        return null;
    }
    global static System.PageReference goToRecordMap(Id recordID, Boolean setRedirect) {
        return null;
    }
    global static void initGeopointeDataForTests() {

    }
    global static String launchAnalyticsDataSetBatchJob(String dataSetId, Boolean orgWide) {
        return null;
    }
    global static geopointe.API.radialSearchResult radialSearchDataSet(Id recordID, String dataSetIdentifier, Decimal rangeDec, geopointe.API.units distanceUnits) {
        return null;
    }
    global static geopointe.API.radialSearchResult radialSearchDataSet(Decimal lat, Decimal lng, String dataSetIdentifier, Decimal rangeDec, geopointe.API.units distanceUnits) {
        return null;
    }
    global static geopointe.API.radialSearchResult radialSearchMapObject(Id recordID, String mapObjectName, String whereClause, Decimal rangeDec, geopointe.API.units distanceUnits) {
        return null;
    }
    global static geopointe.API.radialSearchResult radialSearchMapObject(Decimal lat, Decimal lng, String mapObjectName, String whereClause, Decimal rangeDec, geopointe.API.units distanceUnits) {
        return null;
    }
global enum DMLSource {GEOCODE_JOB_MANUAL_ALL, GEOCODE_JOB_MANUAL_DELTA, GEOCODE_JOB_SCHEDULE_DELTA, MAP_OBJECT_CHANGE}
global class DataSet {
    global String accessLevel;
    global Boolean availableInMaps;
    global Boolean availableInVisualize;
    global String color;
    global String colorMarkersByFieldName;
    global Datetime createdDate;
    global String filterLogic;
    global String labelByFieldName;
    global Datetime lastModifiedDate;
    global String mapObjectName;
    global Boolean myRecords;
    global String name;
    global Boolean oneColumnAddress;
    global String orderByDirection;
    global String orderByFieldName;
    global Id ownerId;
    global Integer queryLimit;
    global String showFilter;
    global String status;
    global String uniqueId;
}
global class DataSetDetail {
    global geopointe.API.DataSet ds;
    global List<geopointe.API.DataSetField> dsFields;
    global List<geopointe.API.DataSetFilter> dsFilters;
    global String soql;
}
global class DataSetField {
    global Datetime createdDate;
    global String dsId;
    global String field;
    global Datetime lastModifiedDate;
    global Decimal order;
    global String sObjectName;
    global String uniqueId;
}
global class DataSetFilter {
    global String childField;
    global String childInNotIn;
    global Integer childInThreshold;
    global String childRelationshipName;
    global String childSObjectName;
    global Datetime createdDate;
    global String dsId;
    global String field;
    global String fieldType;
    global String filterValue;
    global Datetime lastModifiedDate;
    global String operator;
    global Double order;
    global String sObjectName;
    global String uniqueId;
}
global class DistanceService {
    global DistanceService() {

    }
    global void add(String origin, String destination) {

    }
    global void add(Double lat1, Double lng1, String destination) {

    }
    global void add(String origin, Double lat2, Double lng2) {

    }
    global void add(String origin, Decimal lat2, Decimal lng2) {

    }
    global void add(Decimal lat1, Decimal lng1, String destination) {

    }
    global void add(Double lat1, Double lng1, Double lat2, Double lng2) {

    }
    global void add(Decimal lat1, Decimal lng1, Decimal lat2, Decimal lng2) {

    }
    global Double getDistanceAtIndex(Integer index) {
        return null;
    }
    global List<Double> getListOfDistances() {
        return null;
    }
    global List<Double> getListOfTravelTimes() {
        return null;
    }
    global Double getTravelTimeAtIndex(Integer index) {
        return null;
    }
    global void setMode(geopointe.API.mode m) {

    }
    global void setUnits(geopointe.API.units u) {

    }
}
global enum mode {DRIVING, WALKING}
global class radialSearchResult {
    global String dataSetName;
    global Boolean error;
    global String errorMessage;
    global String mapObjectName;
    global String query;
    global Integer recordCount;
    global Map<String,Double> recordsByDistance;
    global List<String> recordsInDistanceOrder;
    global radialSearchResult() {

    }
}
global enum units {KILOMETERS, MILES}
}

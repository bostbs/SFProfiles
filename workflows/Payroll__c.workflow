<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates>
        <fullName>Update_Adjunct_Field</fullName>
        <description>Update the payroll record adjunct field to true</description>
        <field>Adjunct__c</field>
        <literalValue>1</literalValue>
        <name>Update Adjunct Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>Evaluate Adjunct Status</fullName>
        <actions>
            <name>Update_Adjunct_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Evaluates the Contact linked to the payroll record for the status of the adjunct field. Updates the Adjunct field on the payroll record accordingly.</description>
        <formula>ACF_Faculty_Agreement__r.ACF_Faculty__r.Adjunct__c = TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules></Workflow>
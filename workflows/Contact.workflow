<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates>
        <fullName>Update_Prospect_Date</fullName>
        <description>update Prospect Convert Date when Prospect field is update to "Converted Prospect" and the date field is blank.</description>
        <field>ACF_Prospect_Convert_Date__c</field>
        <formula>today()</formula>
        <name>Update Prospect Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>Assign task for new RFI</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.LeadSource</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <description>Task needed to validate new RFI</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules><rules>
        <fullName>Set Prospect Convert Date</fullName>
        <actions>
            <name>Update_Prospect_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.ACF_Prospect__c</field>
            <operation>equals</operation>
            <value>Converted Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.ACF_Prospect_Convert_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules></Workflow>
<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><alerts>
        <fullName>Send_notification_on_key_field_changes</fullName>
        <description>Send notification on key field changes</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Opp_key_field_change</template>
    </alerts><alerts>
        <fullName>Test_Populate_FA_Name2_ACF</fullName>
        <description>Test Populate FA Name2-ACF</description>
        <protected>false</protected>
        <recipients>
            <recipient>admintnguyen@babson.edu</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sromadmin@babson.edu</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CORECONNECT__CoreConnect_Templates/CORECONNECT__Notify_Record_Creator</template>
    </alerts><fieldUpdates>
        <fullName>Populate_Invoice_name</fullName>
        <field>Name</field>
        <formula>ACF_Offering__r.Name + " " +
 text(MONTH(ACF_Offering__r.StartDate)) + "/" + 
 text(DAY(ACF_Offering__r.StartDate)) + "/" + 
 text(YEAR(ACF_Offering__r.StartDate)) + " INV#" +
 ACF_Invoice_num__c</formula>
        <name>Populate Invoice name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_FA_Opp_Name</fullName>
        <description>Auto populate the Opportunity Name for Faculty Agreements</description>
        <field>Name</field>
        <formula>ACF_Offering__r.Name              + " " + 
 text(MONTH(ACF_Offering__r.StartDate)) + "/" +
 text(DAY(ACF_Offering__r.StartDate))   + "/" + 
 text(YEAR(ACF_Offering__r.StartDate))  + "-" + 
 text(MONTH(ACF_Offering__r.EndDate))   + "/" +
 text(DAY(ACF_Offering__r.EndDate))     + "/" + 
 text(YEAR(ACF_Offering__r.EndDate))    + " " +
 LEFT(ACF_Faculty__r.FirstName,1) + "." +
 ACF_Faculty__r.LastName</formula>
        <name>Update FA (Opp) Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Faculty_Expense_Opp_Name</fullName>
        <field>Name</field>
        <formula>ACF_Offering__r.Name + " Faculty Expense " + 
text(MONTH(ACF_Offering__r.StartDate)) + "/" + 
text(DAY(ACF_Offering__r.StartDate)) + "/" + 
text(YEAR(ACF_Offering__r.StartDate)) + "-" + 
text(MONTH(ACF_Offering__r.EndDate)) + "/" + 
text(DAY(ACF_Offering__r.EndDate)) + "/" + 
text(YEAR(ACF_Offering__r.EndDate)) + " " + 
LEFT(ACF_Faculty__r.FirstName,1) + "." + 
ACF_Faculty__r.LastName</formula>
        <name>Update Faculty Expense (Opp) Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Invoice_record_type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BEE_Invoice_locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Invoice record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates><rules>
        <fullName>Populate FA name</fullName>
        <actions>
            <name>Update_FA_Opp_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BEE Faculty Agreements</value>
        </criteriaItems>
        <description>Auto Populate the Opp Name for Faculty Agreements</description>
        <triggerType>onCreateOnly</triggerType>
    </rules><rules>
        <fullName>Populate Faculty Expense name</fullName>
        <actions>
            <name>Update_Faculty_Expense_Opp_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Faculty Expense</value>
        </criteriaItems>
        <description>Auto Populate the Opp Name for Faculty Expenses</description>
        <triggerType>onCreateOnly</triggerType>
    </rules><rules>
        <fullName>Populate Invoice name</fullName>
        <actions>
            <name>Populate_Invoice_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BEE Invoice</value>
        </criteriaItems>
        <description>Auto Populate the Opp Name for Invoices</description>
        <triggerType>onCreateOnly</triggerType>
    </rules><rules>
        <fullName>Send notification on key field changes</fullName>
        <actions>
            <name>Send_notification_on_key_field_changes</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify when Opp Name, Amount are changed or Stage is updated to :closed:</description>
        <formula>OR(     ISCHANGED( Name ) ,   ISCHANGED( Amount ),   AND ( ISCHANGED(StageName) , ISPICKVAL( StageName , "Closed Won")) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules><rules>
        <fullName>Update Invoice record type</fullName>
        <actions>
            <name>Update_Invoice_record_type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BEE Invoice</value>
        </criteriaItems>
        <description>When RT = BEE Invoice and stage = Sent, update RT to Invoice-locked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules></Workflow>
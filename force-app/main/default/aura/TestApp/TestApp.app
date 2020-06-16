<aura:application extends="force:slds" implements="flexipage:availableForAllPageTypes">
  <!-- Create attribute to store lookup value as a sObject--> 
  <aura:attribute name="selectedLookUpRecords" type="sObject[]" default="[]"/>
 
  <c:reUsableMultiSelectLookup objectAPIName="contact"
                               IconName="standard:contact"
                               lstSelectedRecords="{!v.selectedLookUpRecords}"
                               label="Assigned to"/>
   <!-- here c: is org. namespace prefix-->
</aura:application>
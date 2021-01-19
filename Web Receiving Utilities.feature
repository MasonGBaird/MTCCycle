############################################################
# Copyright 2020, Tryon Solutions, Inc.
# All rights reserved.  Proprietary and confidential.
#
# This file is subject to the license terms found at 
# https://www.cycleautomation.com/end-user-license-agreement/
#
# The methods and techniques described herein are considered
# confidential and/or trade secrets. 
# No part of this file may be copied, modified, propagated,
# or distributed except as authorized by the license.
############################################################ 
# Utility: Web Receiving Utilities.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: 2019.1.1
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: WEB, MOCA
# Bundle Revision: 3.0.0
#
# Description:
# This Utility contains common utility scenarios for Web Receiving Features in the Web
#
# Public Scenarios:
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################ 
Feature: Web Receiving Utilities


#############################################################
# Private Scenarios:
#	Web Receiving Perform Receiving and Putaway - Perform transport workflow, receive, and putaway actions
#	Web Process Receiving Tab - Process the Receiving Tab when performing Receive action
#	Web Process Putaway Tab - Process the Putaway Tab when performing Receive action
#############################################################


@wip @private
Scenario: Web Receiving Perform Receiving and Putaway
#############################################################
# Description: Perform Receive and Putaway including
# transport workflow, receive, and putaway actions.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		trlr_num - trailer number
#		rcvqty - quantity that was received
#		rec_loc - location where product was directed during putaway
#		asn_flag - TRUE|FALSE to descern if this is an ASN or non-ASN receive condition
#		uom - Unit of Measure (Case|Each|Pallet)
#	Optional:
#		lodnum - load number to use for receiving
# Outputs:
#	None
#############################################################

Given I "am on the Inbound Shipment screen"
	Once I see "Inbound Shipments" in web browser

And I "select the 'Actions' drop-down"
	When I click element $inbound_shipments_action_button in web browser within $max_response seconds 
 
When I "select the 'Receive Inventory' choice from the 'Actions' drop-down"
	Given I assign "Receive Inventory" to variable "text"
	And I execute scenario "Web xPath for Span Text"
	When I click element $elt in web browser within $max_response seconds 

And I "process the trailer workflow if necessary"
	If I see "Transport Equipment Workflow" in web browser within $wait_med seconds 
		Then I execute scenario "Web Perform Transport Equipment Workflow Safety Check Pass"
		Once I see "Inbound Shipments" in web browser

		And I "select the Receive Inventory 'Actions' drop-down"
			When I click element $inbound_shipments_action_button in web browser within $max_response seconds 
	
			Then I "select the 'Receive Inventory' choice from the 'Actions' drop-down"
				Given I assign "Receive Inventory" to variable "text"
				And I execute scenario "Web xPath for Span Text"
				When I click element $elt in web browser within $max_response seconds
	EndIf
        
And I "process the receive TAB and receive goods and handle serialization"
	And I execute scenario "Web Process Receiving Tab"
 
And I "process the putaway TAB and putaway goods"
	And I execute scenario "Web Process Putway Tab"
    If I see "Inbound Workflow" in web browser within $wait_med seconds
    	Then I click element "xPath://text()[.='Yes']/ancestor::a[1]" in web browser within $wait_med seconds
		And I click element "xPath://text()[.='Complete']/ancestor::a[1]" in web browser within $wait_med seconds	
        Endif
 
And I "close the 'Putaway/Receive' screen by clicking the 'X' in the upper right corner"
	Given I assign variable "elt" by combining $xPath "//i[starts-with(@id,'tool-') and contains(@id,'-toolEl')]"
	When I click element $elt in web browser within $max_response seconds
    
Given I "am back to the Inbound Shipment screen"
	Once I see "Inbound Shipments" in web browser

@wip @prviate
Scenario: Web Process Receiving Tab
#############################################################
# Description: Process the Web Receiving TAB that is started 
# from Actions->Receive Intentory option
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		trlr_num - trailer number
#		rcvqty - quantity that was received
#		asn_flag - TRUE|FALSE to descern if this is an ASN or non-ASN receive condition
#		uom - Unit of Measure (Case|Each|Pallet)
#	Optional:
#		lodnum - load number to use for receiving
# Outputs:
#	None
#############################################################

And I "should be on Receiving and Putaway screen"
	Once I see "Receiving" in web browser
    Once I see "Putaway" in web browser

And I "go to the page where I can receive the goods"
And I "fill in fields that are both required and optional (based on inputs)"
	And I click element "className:table-container" in web browser within $max_response seconds 

And I "check for ASN flag is set and skip receiving TAB if it is"
	Then I assign "TRUE" to variable "perform_receive"
	If I verify variable "asn_flag" is assigned
    And I verify text $asn_flag is equal to "TRUE" ignoring case
		Then I assign "FALSE" to variable "perform_receive"
	EndIf
    
	If I verify text $perform_receive is equal to "TRUE"
		Then I "input the receive quantity and wait for values to register"
			And I type $rcvqty in element "name:quantity" in web browser within $max_response seconds
            
		And I "set unit of measure for receive if requested"
			If I verify variable "uom" is assigned
    		And I verify text $uom is not equal to ""
      			Then I double click element "name:uomCode" in web browser within $max_response seconds
    			And I type $uom in element "name:uomCode" in web browser within $max_response seconds
        		And I assign variable "elt" by combining "xPath://li[text()='" $uom "']"
				And I click element $elt in web browser within $max_response seconds
			EndIF
    
		And I "set lodnum for receive if requested"
			If I verify variable "lodnum" is assigned
    		And I verify text $lodnum is not equal to ""
				Then I type $lodnum in element "name:loadNumber" in web browser within $max_response seconds
			EndIf

		And I "check to see if we want to mark goods as damaged"
			if I verify variable "damaged_flag" is assigned
    		And I verify text $damaged_flag is equal to "TRUE" ignoring case
    			Then I double click element "name:inventoryStatus" in web browser within $max_response seconds
    			And I type "Damaged Product" in element "name:inventoryStatus" in web browser within $max_response seconds
        		And I assign variable "elt" by combining "xPath://li[text()='Damaged Product']"
				And I click element $elt in web browser within $max_response seconds
			EndIf
 
		And I "Click the 'Receive' button on the bottom"
			When I click element "xPath://span[text()='Receive']//.." in web browser within $max_response seconds
    
		And I "process serialization if required/configured"
			Then I execute scenario "Web Process Serialization"
	EndIf
    
@wip @prviate
Scenario: Web Process Putway Tab
#############################################################
# Description: Process the Web Putaway TAB that is started 
# from Actions->Receive Intentory option
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		rec_loc - receiving location
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "should be on Receiving and Putaway screen"
	Once I see "Receiving" in web browser
    Once I see "Putaway" in web browser

Then I "select the 'Putaway' button on the top"
	When I click element "xPath://span[text()='Putaway']//.." in web browser within $max_response seconds 
 
And I "select the items to put away (i.e. all of them)"
	When I click element $putaway_check_box in web browser within $max_response seconds
    
And I "select the 'Move Immediately' radio button"
	Given I assign "xPath://*[@id=(//label[text()='Move Immediately']/@for)]" to variable "elt"
	When I click element $elt in web browser within $max_response seconds 
    
And I "specify the receiving location (if specified)"
	if I verify variable "rec_loc" is assigned
	And I verify text $rec_loc is not equal to ""
		Then I double click element "name:userSelectedLocation" in web browser within $max_response seconds
    	And I type $rec_loc in element "name:userSelectedLocation" in web browser within $max_response seconds
        And I assign variable "elt" by combining "xPath://li[text()='" $rec_loc "']"
        If I see element $elt in web browser within $wait_med seconds
			Then I click element $elt in web browser within $max_response seconds
        Endif
	EndIf
 
And I "press the 'Putaway' button on the very bottom to complete the putaway action"
	When I click element $putaway_button in web browser within $max_response seconds 

And I "wait for WMS to put the stuff away. There is no acknowledgement other than it goes away" which can take between $wait_long seconds and $max_response seconds

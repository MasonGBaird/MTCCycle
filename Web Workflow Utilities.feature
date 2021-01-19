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
# Utility: Web Workflow Utilities.feature
# 
# Functional Area: Workflows
# Author: Tryon Solutions
# Blue Yonder WMS Version: 2019.1.1
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Web, MOCA
# Bundle Revision: 3.0.0
# 
# Description:
# Utility scenarios to perform Workflows within the Web
#
# Public Scenarios:
#	- Web Perform Transport Equipment Workflow Safety Check Pass - Performs a Safety Check for Transport Equipment as passing via the Web.
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Web Workflow Utilities


@wip @public
Scenario: Web Perform Transport Equipment Workflow Safety Check Pass
#############################################################
# Description: This scenario performs a Trailer Safety Check when prompted during on the Transport Equipment screen in the Web.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	None
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "only perform the Safety Check if prompted"
	#initialize flag variable that will be used to control exit from while loop
    Given I assign 0 to variable "flag"
    
    #while I see transport equipment workflow i know I am working towards completeting workflow
	While I see "Transport Equipment Workflow" in web browser within $wait_long seconds 
    
    #if i see transport equipment workflow get started on completing workflows
    If I see "Transport Equipment Workflow" in web browser within $wait_long seconds 
    
    	#set up xpath for Yes button
    	Given I "assign the xPath for the 'Yes' button"
    		And I assign variable "elt" by combining "xPath://a[not(contains(@class,'x-pressed'))]"
    		And I assign variable "elt" by combining $elt "//span[text()='Yes']/.."
    		And I assign variable "pass_not_pressed" by combining $elt
        #while I do not see the label "capture trailer seal number" I know I have not reached the last workflow prompt windows
    	While I do not see element "xPath://input[starts-with(@name,'EXCFORM*!PASS*!1*!INS000000019')]" in web browser 
        And $flag is equal to 0
        	#if i see transport Equipment Temperature Capture I run the code that will satsify pop up prompt
    		If I see "Transport Equipment Temperature Capture" in web browser
    			Given I click element $pass_not_pressed in web browser within $max_response seconds
    				And I click element $elt in web browser within $max_response seconds      
                    #i click into prompt text field
    				Then I click element "xPath://input[starts-with(@name,'EXCFORM*!PASS*!1*!CAPTURE-TRLR-TEMP')]" in web browser
    				Then I type "1" in web browser
    				Then I press keys tab in web browser
    				Then I press keys enter in web browser
    		EndIf
            #if i see Capture Trailer Seal Number I run the code that will satsify pop up prompt
    		If I see "Capture Trailer Seal Number" in web browser
    			Given I click element $pass_not_pressed in web browser within $max_response seconds
    				And I click element $elt in web browser within $max_response seconds    
                    #i click into prompt text field
    				Then I click element "xPath://input[starts-with(@name,'EXCFORM*!PASS*!1*!INS000000019')]" in web browser
    				Then I type "1234" in web browser
    				Then I press keys tab in web browser
    				Then I press keys enter in web browser
    				Then I wait 3 seconds
                    #i set flag to true because after seal number is captured there is no complete button to click
    				Then I assign 1 to variable "flag"
    		EndIf	
            #if neither of the workflows with prompts is on screen I loop through web page until all quesitons are set to yes
    		Then I "Pass all of the safety check questions"
   				While I see element $pass_not_pressed in web browser within $wait_med seconds 
    				Then I click element $pass_not_pressed in web browser within $max_response seconds
   				EndWhile
    		If $flag is equal to 0
    			Then I "save the safety check" 
    			# Assign the xPath for the Save button
    			And I assign variable "elt" by combining "xPath://div[contains(@class,'wm-formView-save-toolbar')]"  
    			And I assign variable "elt" by combining $elt "//span[text()='Complete']/.."
    			# Click to save
    			And I click element $elt in web browser within $max_response seconds
   			EndIf
    	EndWhile
    Else I "was not prompted to perform the Safety Check and continue the scenario."
    EndIf
    Endwhile
	
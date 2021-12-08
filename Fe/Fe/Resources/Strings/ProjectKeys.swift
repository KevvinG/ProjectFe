//
//  ProjectKeys.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-06-21.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: enum ProjectKeys
 - Description: Holds all strings used for the project.
 -----------------------------------------------------------------------*/
public enum ProjectKeys: String {
    
    //MARK: Login Screen
    case loginTitle = "Project Fe - Anemia Support"
    case loginBtnLogin = "Log In"
    
    //MARK: Home Screen
    case homeTitle = "Welcome Back, "
    case homeSubtitleGood = "Everything Looks Normal Today"
    case homeSubtitleBad = "We've found An Anomaly"
    case homeHrBtnTitle = "Heart Rate"
    case homeBoBtnTitle = "Blood Oxygen"
    case homeAltBtnTitle = "Altitude"
    case homeQuestBtnTitle = "Check Symptoms"
    case homeMoreInfoBtnTitle = "More Information"
    
    //MARK: NavBar
    case barButtonHome = "Home"
    case barButtonSettings = "Settings"
    
    //MARK: Shared Screen Strings
    case btnYes = "Yes"
    case btnNo = "No"
    case btnReturn = "Return"
    case detailSubTitleStats = "Daily Statistics"
    case detailSubtitleThresholds = "Threshold Management"
    case detailBtnUpdate = "Update Thresholds"
    case detailInfoTitle = "Did You Know?"
    
    //MARK: HR Detail Screen
    case hrTitle = "Heart Rate Data"
    case hrCurrent = "Today Current Heart Rate:"
    case hrAverage = "Today Average Heart Rate:"
    case hrMaximum = "Today Maximum Heart Rate:"
    case hrMinimum = "Today Minimum Heart Rate:"
    case hrLowThreshold = "Heart Rate Low Threshold:"
    case hrHighThreshold = "Heart Rate High Threshold:"
    case hrInfoDescription = "Anemia can cause you to have an irregular heartbeat.   When you are anemic, your heart may have to work harder to pump more blood due to a lack of oxygen in the body.   You may feel your heart speed up, or feel like it stops momentarily. These are the irregularities we are looking for."
    
    //MARK: Blood Oxygen Detail Screen
    case bldOxTitle = "Blood Oxygen Data"
    case bldOxCurrent = "Today Current Blood Ox:"
    case bldOxAverage = "Today Average Blood Ox:"
    case bldOxMaximum = "Today Maximum Blood Ox:"
    case bldOxMinimum = "Today Minimum Blood Ox:"
    case bldOxLowThreshold = "Blood Ox Low Threshold:"
    case bldOxHighThreshold = "Blood Ox High Threshold:"
    
    //MARK: Altitude Detail Screen
    case altTitle = "Altitude and Pressure Data"
    case altCurrent = "Current Pressure:"
    case altElevation = "Current Elevation:"
    case altElevationSubtitle = "Elevation Past 7 Days"
    case altPressureSubtitle = "Air Pressure Past 7 Days"
    case altDescription = "People can experience headaches or migraines when the barometric pressure is 5 hPa lower than the previous day.  Air pressure drops as you elevation increases.   Symptoms relating to headaches can be:  - Nausea and vomiting - Increased sensitivity to light - Numbness in the face or neck - Pain in or around your temples  As your elevation increases, there are fewer oxygen particles in the air.  This reduction in oxygen can reduce your blood oxygen saturation if your body is not acclimated to the change in elevatioon.  "
    case altDescriptionChart1 = "- Sea Level: 20.9% - 1000M: 20.1% - 2000M: 19.4% - 3000M: 18.6% - 4000M: 17.9%"
    case altDescriptionChart2 = "- 5000M: 17.3% - 6000M: 16.6% - 7000M: 16.0% - 8000M: 15.4% - 9000M: 14.8%"
    
    //MARK: Symptoms Screen
    case sympQuestion1 = "Are you feeling dizzy?"
    case sympQuestion2 = "Are you feeling shortness of breath?"
    case sympQuestion3 = "Have you noticed blood in your stool?"
    case sympQuestion4 = "Have you noticed your stool being black?"
    case sympTitleClear = "You are clear of some of the usual symptoms, but if you still don't feel well, consider contacting your doctor to make an appointment"
    case sympBtnCall = "Call Doctor"
    case sympTitleConcern = "Consider contacting your doctor to schedule an appointment"
    
    //MARK: Settings Screen
    case settingsTitleDrPhone = "Doctor Phone Number"
    case settingsTitleEmergContact = "Emergency Contact"
    case settingsBtnUpdateEmergContact = "Update Emergency Info"
    case settingsBtnEditAccount = "Edit Account Details"
    case settingsBtnAppPermissions = "Application Permissions"
    case settingsBtnNotificationSettings = "Notification Settings"
    case settingsBtnDeleteData = "Delete Data"
    case settingsBtnDeleteAccount = "Delete Account"
    
    //MARK: Edit Account Screen
    
    //MARK: App Permissions Screen
    
    //MARK: Notification Settings Screen
    
    //MARK: Alert Box Strings
    
}

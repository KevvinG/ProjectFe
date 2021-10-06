//
//  UIKeys.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-06-21.
//

//MARK: Imports
import Foundation

//MARK: Enum UIKeys
enum UIKeys: String {
    
    //MARK: Login Screen
    case loginTitle
    case loginBtnLogin
    
    //MARK: Home Screen
    case homeTitle
    case homeSubtitleGood
    case homeSubtitleBad
    case homeHrBtnTitle
    case homeBoBtnTitle
    case homeAltBtnTitle
    case homeQuestBtnTitle
    case homeMoreInfoBtnTitle
    
    //MARK: NavBar
    case barButtonHome
    case barButtonSettings
    
    //MARK: Shared Screen Strings
    case btnYes
    case btnNo
    case btnReturn
    case detailSubTitleStats
    case detailSubtitleThresholds
    case detailBtnUpdateThresholds
    case detailInfoTitle
    
    //MARK: HR Detail Screen
    case hrTitle
    case hrCurrent
    case hrAverage
    case hrMaximum
    case hrMinimum
    case hrLowThreshold
    case hrHighThreshold
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
    
    //MARK: Descriptions
    var description : String {
        switch self {
        case .loginTitle:
            return "Project Fe - Anemia Support"
        case .loginBtnLogin:
            return "Log In"
        case .homeTitle:
            return "Welcome Back, "
        case .homeSubtitleGood:
            return "Everything Looks Normal Today"
        case .homeSubtitleBad:
            return "We've found An Anomaly"
        case .homeHrBtnTitle:
            return "Heart Rate"
        case .homeBoBtnTitle:
            return "Blood Oxygen"
        case .homeAltBtnTitle:
            return "Altitude"
        case .homeQuestBtnTitle:
            return "Check Symptoms"
        case .homeMoreInfoBtnTitle:
            return "More Information"
        case .barButtonHome:
            return "Home"
        case .barButtonSettings:
            return "Settings"
        case .btnYes:
            return "Yes"
        case .btnNo:
            return "No"
        case .btnReturn:
            return "Return"
        case .detailSubTitleStats:
            return "Daily Statistics"
        case .detailSubtitleThresholds:
            return "Threshold Management"
        case .detailBtnUpdateThresholds:
            return "Update Thresholds"
        case .detailInfoTitle:
            return "Did You Know?"
        case .hrTitle:
            return "Heart Rate Data"
        case .hrCurrent:
            return "Today Current Heart Rate:"
        case .hrAverage:
            return "Today Average Heart Rate:"
        case .hrMaximum:
            return "Today Maximum Heart Rate:"
        case .hrMinimum:
            return "Today Minimum Heart Rate:"
        case .hrLowThreshold:
            return "Heart Rate Low Threshold:"
        case .hrHighThreshold:
            return "Heart Rate High Threshold:"
        case .hrInfoDescription:
            return ""
        case .bldOxTitle:
            return ""
        case .bldOxCurrent:
            return ""
        case .bldOxAverage:
            return ""
        case .bldOxMaximum:
            return ""
        case .bldOxMinimum:
            return ""
        case .bldOxLowThreshold:
            return ""
        case .bldOxHighThreshold:
            return ""
        case .altTitle:
            return ""
        case .altCurrent:
            return ""
        case .altElevation:
            return ""
        case .altElevationSubtitle:
            return ""
        case .altPressureSubtitle:
            return ""
        case .altDescription:
            return ""
        case .altDescriptionChart1:
            return ""
        case .altDescriptionChart2:
            return ""
        case .sympQuestion1:
            return ""
        case .sympQuestion2:
            return ""
        case .sympQuestion3:
            return ""
        case .sympQuestion4:
            return ""
        case .sympTitleClear:
            return ""
        case .sympBtnCall:
            return ""
        case .sympTitleConcern:
            return ""
        case .settingsTitleDrPhone:
            return ""
        case .settingsTitleEmergContact:
            return ""
        case .settingsBtnUpdateEmergContact:
            return ""
        case .settingsBtnEditAccount:
            return ""
        case .settingsBtnAppPermissions:
            return ""
        case .settingsBtnNotificationSettings:
            return ""
        case .settingsBtnDeleteData:
            return ""
        case .settingsBtnDeleteAccount:
            return ""
        }
    }
}

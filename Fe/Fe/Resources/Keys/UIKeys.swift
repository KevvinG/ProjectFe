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
    case hrInfoDescription
    
    //MARK: Blood Oxygen Detail Screen
    case bldOxTitle
    case bldOxCurrent
    case bldOxAverage
    case bldOxMaximum
    case bldOxMinimum
    case bldOxLowThreshold
    case bldOxHighThreshold
    
    //MARK: Altitude Detail Screen
    case altTitle
    case altCurrent
    case altElevation
    case altElevationSubtitle
    case altPressureSubtitle
    case altDescription
    case altDescriptionChart1
    case altDescriptionChart2
    
    //MARK: Symptoms Screen
    case sympQuestion1
    case sympQuestion2
    case sympQuestion3
    case sympQuestion4
    case sympTitleClear
    case sympBtnCall
    case sympTitleConcern
    
    //MARK: Settings Screen
    case settingsTitleDrPhone
    case settingsTitleEmergContact
    case settingsBtnUpdateEmergContact
    case settingsBtnEditAccount
    case settingsBtnAppPermissions
    case settingsBtnNotificationSettings
    case settingsBtnDeleteData
    case settingsBtnDeleteAccount
    
    //MARK: Edit Account Screen
    
    //MARK: App Permissions Screen
    
    //MARK: Notification Settings Screen
    case settingsNotifSensorTitle
    
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
            return "Anemia can cause you to have an irregular heartbeat.   When you are anemic, your heart may have to work harder to pump more blood due to a lack of oxygen in the body.   You may feel your heart speed up, or feel like it stops momentarily. These are the irregularities we are looking for."
        case .bldOxTitle:
            return "Blood Oxygen Data"
        case .bldOxCurrent:
            return "Today Current Blood Ox:"
        case .bldOxAverage:
            return "Today Average Blood Ox:"
        case .bldOxMaximum:
            return "Today Maximum Blood Ox:"
        case .bldOxMinimum:
            return "Today Minimum Blood Ox:"
        case .bldOxLowThreshold:
            return "Blood Ox Low Threshold:"
        case .bldOxHighThreshold:
            return "Blood Ox High Threshold:"
        case .altTitle:
            return "Altitude and Pressure Data"
        case .altCurrent:
            return "Current Pressure:"
        case .altElevation:
            return "Current Elevation:"
        case .altElevationSubtitle:
            return "Elevation Past 7 Days"
        case .altPressureSubtitle:
            return "Air Pressure Past 7 Days"
        case .altDescription:
            return "People can experience headaches or migraines when the barometric pressure is 5 hPa lower than the previous day.  Air pressure drops as you elevation increases.   Symptoms relating to headaches can be:  - Nausea and vomiting - Increased sensitivity to light - Numbness in the face or neck - Pain in or around your temples  As your elevation increases, there are fewer oxygen particles in the air.  This reduction in oxygen can reduce your blood oxygen saturation if your body is not acclimated to the change in elevatioon.  "
        case .altDescriptionChart1:
            return "- Sea Level: 20.9% - 1000M: 20.1% - 2000M: 19.4% - 3000M: 18.6% - 4000M: 17.9%"
        case .altDescriptionChart2:
            return "- 5000M: 17.3% - 6000M: 16.6% - 7000M: 16.0% - 8000M: 15.4% - 9000M: 14.8%"
        case .sympQuestion1:
            return "Are you feeling dizzy?"
        case .sympQuestion2:
            return "Are you feeling shortness of breath?"
        case .sympQuestion3:
            return "Have you noticed blood in your stool?"
        case .sympQuestion4:
            return "Have you noticed your stool being black?"
        case .sympTitleClear:
            return "You are clear of some of the usual symptoms, but if you still don't feel well, consider contacting your doctor to make an appointment"
        case .sympBtnCall:
            return "Call Doctor"
        case .sympTitleConcern:
            return "Consider contacting your doctor to schedule an appointment"
        case .settingsTitleDrPhone:
            return "Doctor Phone Number"
        case .settingsTitleEmergContact:
            return "Emergency Contact"
        case .settingsBtnUpdateEmergContact:
            return "Update Emergency Info"
        case .settingsBtnEditAccount:
            return "Edit Account Details"
        case .settingsBtnAppPermissions:
            return "Application Permissions"
        case .settingsBtnNotificationSettings:
            return "Notification Settings"
        case .settingsBtnDeleteData:
            return "Delete Data"
        case .settingsBtnDeleteAccount:
            return "Delete Account"
        case .settingsNotifSensorTitle:
            return "Sensor Anomaly Notifications"
        }
    }
}

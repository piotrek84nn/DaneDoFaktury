//
//  ViewController.swift
//  Dane do faktury
//
//  Created by Niżnik Piotr on 16/04/2018.
//  Copyright © 2018 Piotr Niznik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var CompanyName: UITextView!
    @IBOutlet weak var CompanyAddress: UITextView!
    @IBOutlet weak var EditSaveButton: UIButton!
    
    @IBOutlet weak var CompanyNIPLabel: UILabel!
    @IBOutlet weak var CompanyNIP: UITextField!
    
    @IBOutlet weak var CompanyCarRegistrationLabel: UILabel!
    @IBOutlet weak var CompanyCarRegistrationNumber: UITextField!
    
    @IBOutlet weak var CompanyRegonLabel: UILabel!
    @IBOutlet weak var CompanyRegon: UITextField!
    
    let saveDataKey = "CompanyNameKey"
    var CompanyItemElement: CompanyItem!
    var IsEditMode: Bool = false;
    var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EditSaveButton.addTarget(self, action: #selector(editSaveAction), for: .touchUpInside)
        setupViewEditing(isEditingMode: IsEditMode)
        initDoneButton()
        
        loadData(item: CompanyItemElement);
        
        showHideLabel(label: CompanyNIPLabel, uiElementIsHiden: !CompanyNIP.hasText);
        showHideLabel(label: CompanyCarRegistrationLabel, uiElementIsHiden: !CompanyCarRegistrationNumber.hasText);
        showHideLabel(label: CompanyRegonLabel, uiElementIsHiden: !CompanyRegon.hasText);
    }
    
    private func loadData(item : CompanyItem!) {
        
        CompanyItemElement = CompanyItem()
        
        if let readedData = UserDefaults.standard.object(forKey: saveDataKey) as? Data {
            if let decodedCompanyItem = NSKeyedUnarchiver.unarchiveObject(with: readedData) as? CompanyItem
            {
                if let cName = decodedCompanyItem.CompanyName {
                    CompanyItemElement.CompanyName = cName
                }
                
                if let cAddress = decodedCompanyItem.CompanyAddress {
                    CompanyItemElement.CompanyAddress = cAddress
                    blockScreenTurningOff();
                }
                
                if let cNIP = decodedCompanyItem.CompanyNIP {
                    CompanyItemElement.CompanyNIP = cNIP
                }
                
                if let cRegistrationNumber = decodedCompanyItem.CompanyCarRegistrationNumber {
                    CompanyItemElement.CompanyCarRegistrationNumber = cRegistrationNumber
                }
                
                if let cRegon = decodedCompanyItem.CompanyRegon {
                    CompanyItemElement.CompanyRegon = cRegon
                }
            }
        }
        
        CompanyName.text = CompanyItemElement?.CompanyName;
        CompanyAddress.text = CompanyItemElement?.CompanyAddress;
        CompanyNIP.text = CompanyItemElement?.CompanyNIP;
        CompanyCarRegistrationNumber.text = CompanyItemElement?.CompanyCarRegistrationNumber;
    }
    
    private func setupViewEditing(isEditingMode: Bool) {
        CompanyName.isEditable = isEditingMode;
        CompanyAddress.isEditable = isEditingMode;
        CompanyNIP.isEnabled = isEditingMode;
        CompanyCarRegistrationNumber.isEnabled = isEditingMode;
        CompanyRegon.isEnabled = isEditingMode;
    }
    
    private func showHideLabel(label: UILabel, uiElementIsHiden: Bool) {
        label.isHidden = uiElementIsHiden;
    }
    
    private func setTextInputElementsEditViewMode(isEditingMode: Bool) {
        var backgroundColor : UIColor = UIColor.white;
        var foregroundColor : UIColor = UIColor.black;
        
        if(!isEditingMode)
        {
            backgroundColor = UIColor.clear;
            foregroundColor = UIColor.white;
        }
        
        CompanyName.backgroundColor = backgroundColor;
        CompanyName.textColor = foregroundColor
        CompanyAddress.backgroundColor = backgroundColor
        CompanyAddress.textColor = foregroundColor
        CompanyNIP.backgroundColor = backgroundColor
        CompanyNIP.textColor = foregroundColor
        CompanyCarRegistrationNumber.backgroundColor = backgroundColor
        CompanyCarRegistrationNumber.textColor = foregroundColor
        CompanyRegon.backgroundColor = backgroundColor
        CompanyRegon.textColor = foregroundColor
    }
    
    private func initDoneButton() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Ukryj", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        CompanyName.inputAccessoryView = toolbar
        CompanyAddress.inputAccessoryView = toolbar
        CompanyNIP.inputAccessoryView = toolbar
        CompanyCarRegistrationNumber.inputAccessoryView = toolbar
        CompanyRegon.inputAccessoryView = toolbar
        
        toolbar.isHidden = true;
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        doneButtonAction();
    }
    
    @objc func editSaveAction(sender: UIButton!) {
        IsEditMode = !IsEditMode;
        toolbar.isHidden = !IsEditMode;
        setupViewEditing(isEditingMode: IsEditMode);
        setTextInputElementsEditViewMode(isEditingMode: IsEditMode);
        
        if(IsEditMode)
        {
            EditSaveButton.setTitle("Zapisz", for: .normal);
            showHideLabel(label: CompanyNIPLabel, uiElementIsHiden: false);
            showHideLabel(label: CompanyCarRegistrationLabel, uiElementIsHiden: false);
            showHideLabel(label: CompanyRegonLabel, uiElementIsHiden: false);
        }
        else
        {
            saveData()
            EditSaveButton.setTitle("Edytuj ", for: .normal);
            showHideLabel(label: CompanyNIPLabel, uiElementIsHiden: !CompanyNIP.hasText);
            showHideLabel(label: CompanyCarRegistrationLabel, uiElementIsHiden: !CompanyCarRegistrationNumber.hasText);
            showHideLabel(label: CompanyRegonLabel, uiElementIsHiden: !CompanyRegon.hasText);
        }
    }
    
    private func saveData() {
        CompanyItemElement.CompanyName = CompanyName.text
        CompanyItemElement.CompanyAddress = CompanyAddress.text
        CompanyItemElement.CompanyNIP = CompanyNIP?.text
        CompanyItemElement.CompanyCarRegistrationNumber = CompanyCarRegistrationNumber?.text
        CompanyItemElement.CompanyRegon = CompanyRegon?.text
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: CompanyItemElement)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: saveDataKey)
    }
    
    private func blockScreenTurningOff() {
        UIApplication.shared.isIdleTimerDisabled = false
        UIApplication.shared.isIdleTimerDisabled = true
    }
}


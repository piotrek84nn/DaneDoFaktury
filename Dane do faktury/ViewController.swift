//
//  ViewController.swift
//  Dane do faktury
//
//  Created by Niżnik Piotr on 16/04/2018.
//  Copyright © 2018 Piotr Niznik. All rights reserved.
//

import UIKit

extension String {
    static func isEmptyString(optionalString:String?) -> Bool {
        if let stringToCheck = optionalString {
            return stringToCheck.isEmpty
        } else {
            return true
        }
    }
}

final class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak private var companyName: UITextView!
    @IBOutlet weak private var companyAddress: UITextView!
    @IBOutlet weak private var editSaveButton: UIButton!
    
    @IBOutlet weak private var companyNIPLabel: UILabel!
    @IBOutlet weak private var companyNIP: UITextField!
    
    @IBOutlet weak private var companyCarRegistrationLabel: UILabel!
    @IBOutlet weak private var companyCarRegistrationNumber: UITextField!
    
    @IBOutlet weak private var companyRegonLabel: UILabel!
    @IBOutlet weak private var companyRegon: UITextField!
    
    private let saveDataKey = "CompanyNameKey"
    private let nipMaxNumberLenght = 10
    private let regonMaxNumberLenght = 9
    private let carRegistrationMaxNumberLenght = 8
    private var companyItemElement: CompanyItem!
    private var isEditMode: Bool = false;
    private var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyNIP.delegate = self
        companyCarRegistrationNumber.delegate = self
        companyRegon.delegate = self
        
        editSaveButton.addTarget(self, action: #selector(editSaveAction), for: .touchUpInside)
        setupViewEditing(isEditingMode: isEditMode)
        initDoneButton()
        
        loadData(item: companyItemElement);

        if(String.isEmptyString(optionalString: companyItemElement.CompanyName) || String.isEmptyString(optionalString: companyItemElement.CompanyAddress))
        {
            isEditMode = false;
            editSaveAction(sender: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        switch textField {
        case companyNIP:
            return newLength <= nipMaxNumberLenght
        case companyCarRegistrationNumber:
            return newLength <= carRegistrationMaxNumberLenght
        case companyRegon:
            return newLength <= regonMaxNumberLenght
        default:
            return newLength <= 50
        }
    }
    
    private func loadData(item : CompanyItem!) {
        
        companyItemElement = CompanyItem()
        blockScreenTurningOff();
        
        if let readedData = UserDefaults.standard.object(forKey: saveDataKey) as? Data {
            if let decodedCompanyItem = NSKeyedUnarchiver.unarchiveObject(with: readedData) as? CompanyItem
            {
                if let cName = decodedCompanyItem.CompanyName, let cAddress = decodedCompanyItem.CompanyAddress {
                    companyItemElement.CompanyName = cName
                    companyItemElement.CompanyAddress = cAddress
                }
                
                if let cNIP = decodedCompanyItem.CompanyNIP {
                    companyItemElement.CompanyNIP = cNIP
                }
                
                if let cRegistrationNumber = decodedCompanyItem.CompanyCarRegistrationNumber {
                    companyItemElement.CompanyCarRegistrationNumber = cRegistrationNumber
                }
                
                if let cRegon = decodedCompanyItem.CompanyRegon {
                    companyItemElement.CompanyRegon = cRegon
                }
            }
        }
        
        companyName.text = companyItemElement?.CompanyName;
        companyAddress.text = companyItemElement?.CompanyAddress;
        companyNIP.text = companyItemElement?.CompanyNIP;
        companyCarRegistrationNumber.text = companyItemElement?.CompanyCarRegistrationNumber;
        
        showHideLabel(label: companyNIPLabel, uiElementIsHiden: !companyNIP.hasText);
        showHideLabel(label: companyCarRegistrationLabel, uiElementIsHiden: !companyCarRegistrationNumber.hasText);
        showHideLabel(label: companyRegonLabel, uiElementIsHiden: !companyRegon.hasText);
    }
    
    private func setupViewEditing(isEditingMode: Bool) {
        companyName.isEditable = isEditingMode;
        companyAddress.isEditable = isEditingMode;
        companyNIP.isEnabled = isEditingMode;
        companyCarRegistrationNumber.isEnabled = isEditingMode;
        companyRegon.isEnabled = isEditingMode;
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
        
        companyName.backgroundColor = backgroundColor;
        companyName.textColor = foregroundColor
        companyAddress.backgroundColor = backgroundColor
        companyAddress.textColor = foregroundColor
        companyNIP.backgroundColor = backgroundColor
        companyNIP.textColor = foregroundColor
        companyCarRegistrationNumber.backgroundColor = backgroundColor
        companyCarRegistrationNumber.textColor = foregroundColor
        companyRegon.backgroundColor = backgroundColor
        companyRegon.textColor = foregroundColor
    }
    
    private func initDoneButton() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Ukryj", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        companyName.inputAccessoryView = toolbar
        companyAddress.inputAccessoryView = toolbar
        companyNIP.inputAccessoryView = toolbar
        companyCarRegistrationNumber.inputAccessoryView = toolbar
        companyRegon.inputAccessoryView = toolbar
        
        toolbar.isHidden = true;
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        doneButtonAction();
    }
    
    @objc func editSaveAction(sender: UIButton!) {
        if(isEditMode && (String.isEmptyString(optionalString: companyName.text)
                || String.isEmptyString(optionalString: companyAddress.text)))
        {
            return
        }
        
        isEditMode = !isEditMode;
        toolbar.isHidden = !isEditMode;
        setupViewEditing(isEditingMode: isEditMode);
        setTextInputElementsEditViewMode(isEditingMode: isEditMode);
        
        if(isEditMode)
        {
            editSaveButton.setTitle("Zapisz", for: .normal);
            showHideLabel(label: companyNIPLabel, uiElementIsHiden: false);
            showHideLabel(label: companyCarRegistrationLabel, uiElementIsHiden: false);
            showHideLabel(label: companyRegonLabel, uiElementIsHiden: false);
        }
        else
        {
            saveData()
            editSaveButton.setTitle("Edytuj ", for: .normal);
            showHideLabel(label: companyNIPLabel, uiElementIsHiden: !companyNIP.hasText);
            showHideLabel(label: companyCarRegistrationLabel, uiElementIsHiden: !companyCarRegistrationNumber.hasText);
            showHideLabel(label: companyRegonLabel, uiElementIsHiden: !companyRegon.hasText);
        }
    }
    
    private func saveData() {
        companyItemElement.CompanyName = companyName.text
        companyItemElement.CompanyAddress = companyAddress.text
        companyItemElement.CompanyNIP = companyNIP?.text
        companyItemElement.CompanyCarRegistrationNumber = companyCarRegistrationNumber?.text
        companyItemElement.CompanyRegon = companyRegon?.text
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: companyItemElement)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: saveDataKey)
    }
    
    private func showWarningInfo()
    {
        let alertController = UIAlertController(title: "Uwaga", message: "Należy podać nazwę firmy oraz adres !", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"Ok", style: .default, handler: { (pAlert) in})
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func blockScreenTurningOff() {
        UIApplication.shared.isIdleTimerDisabled = false
        UIApplication.shared.isIdleTimerDisabled = true
    }
}


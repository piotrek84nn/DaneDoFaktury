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
    
    var CompanyItemElement: CompanyItem!
    var IsEditMode: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EditSaveButton.addTarget(self, action: #selector(editSaveAction), for: .touchUpInside)
        setupViewEditing(isEditingMode: IsEditMode);
        
        loadData(item: CompanyItemElement);
        
        showHideLabel(label: CompanyNIPLabel, uiElementIsHiden: !CompanyNIP.hasText);
        showHideLabel(label: CompanyCarRegistrationLabel, uiElementIsHiden: !CompanyCarRegistrationNumber.hasText);
        showHideLabel(label: CompanyRegonLabel, uiElementIsHiden: !CompanyRegon.hasText);
    }
    
    private func loadData(item : CompanyItem!) {
        CompanyItemElement = CompanyItem(CompanyName: "Ala ma kota Handel Usługi Transport Michał Pjaskowski", CompanyAddress: "Jakiś tam adres na zadupiu 87, 31-559 Zakopane", CompanyNIP: "7941606856", CompanyCarRegistrationNumber: nil)
        
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
    
    @objc func editSaveAction(sender: UIButton!) {
        
        IsEditMode = !IsEditMode;
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
            EditSaveButton.setTitle("Edytuj ", for: .normal);
            showHideLabel(label: CompanyNIPLabel, uiElementIsHiden: !CompanyNIP.hasText);
            showHideLabel(label: CompanyCarRegistrationLabel, uiElementIsHiden: !CompanyCarRegistrationNumber.hasText);
            showHideLabel(label: CompanyRegonLabel, uiElementIsHiden: !CompanyRegon.hasText);
        }
    }
}


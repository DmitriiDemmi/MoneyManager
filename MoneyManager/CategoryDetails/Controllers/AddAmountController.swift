//
//  AddAmountController.swift
//  CoreDataTest
//
//  Created by RM on 17.05.2021.
//

import UIKit
import EasyPeasy

class AddAmountViewController: UIViewController {
    
    var addAmountVcDelegate: AddAmountVcDelegate?
    
    let amountTextField = UITextField()
    
    var datePicker = UIDatePicker()
    
    let holder = UIView()
    
    var firstNumber = 0
    var resultNumber = 0
    var currentOperations: Operation?

    enum Operation {
        case add, subtract, multiply, divide
    }

    var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont(name: "Helvetica", size: 100)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Назад", style: .done, target: self, action: #selector(cancelAddVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: datePicker)
 
        view.addSubview(holder)
        holder.easy.layout([Height().like(view), Width().like(view)])
        view.addSubview(datePicker)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupDatePicker()
        setupNumberPad()
    }
    
    var currentDate = Date()
    
    @objc func chooseDate(paramdatePicker: UIDatePicker) {
        if paramdatePicker.isEqual(self.datePicker) {
            currentDate = paramdatePicker.date
        }
        
        dismiss(animated: true)
    }
    
    @objc func cancelAddVC() {
        dismiss(animated: true)
    }

    @objc func saveButtonPressed() {
        let text = resultLabel.text!
        let textToDecimal = Decimal(string: text)
        addAmountVcDelegate?.getAmount(textToDecimal ?? 0, date: currentDate)
        dismiss(animated: true)
    }
    
    private func setupDatePicker() {
        datePicker.sizeToFit()
        datePicker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
        datePicker.timeZone = .current
        datePicker.tintColor = .black
        datePicker.datePickerMode = .dateAndTime
    }
    
}


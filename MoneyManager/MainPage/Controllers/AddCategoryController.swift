//
//  AddCategory.swift
//  CoreDataTest
//
//  Created by RM on 25.05.2021.
//

import UIKit
import EasyPeasy

protocol AddCategoryVcDelegate {
    func addIncomeCategory(_ categoryName: String?, image: String)
    func addCostsCategory(_ categoryName: String?, image: String)
}

class AddCategoryViewController: UIViewController {
    
    var addCategoryVcDelegate: AddCategoryVcDelegate?

    let categoryTextField = TextField()
    let addIncomeCategoryButton = UIButton()
    let addCostsCategoryButton = UIButton()
    let imagePicker = UIPickerView()
    var imageOfCategory = UIImageView()

    var chosenImage = String()
    
    var rotationAngle: CGFloat!
  
    let pickerViewImages = [UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3"), UIImage(named: "4"),
    UIImage(named: "5"), UIImage(named: "6"), UIImage(named: "7"), UIImage(named: "8"), UIImage(named: "9"),
    UIImage(named: "10"), UIImage(named: "11"), UIImage(named: "12"), UIImage(named: "13"), UIImage(named: "14"),
    UIImage(named: "15"), UIImage(named: "16"), UIImage(named: "17"), UIImage(named: "18"), UIImage(named: "19"),
    UIImage(named: "20"), UIImage(named: "21"), UIImage(named: "22"), UIImage(named: "23"), UIImage(named: "24"), UIImage(named: "25"), UIImage(named: "26"), UIImage(named: "27")]
    
    let pickerViewImagesNames = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Отменить", style: .done, target: self, action: #selector(backToMainVC))
        navigationItem.leftBarButtonItem?.tintColor = .black
        setupImagePicker()
        setupAddCostsCategoryButton()
        setupAddIncomeCategoryButton()
        setupCategoryTextField()

    }
    
    @objc func backToMainVC() {
        dismiss(animated: true)
    }
    
    @objc func addIncomeButtonPressed() {
        addCategoryVcDelegate?.addIncomeCategory(categoryTextField.text, image: chosenImage)
        dismiss(animated: true)
    }
    
    @objc func addCostsButtonPressed() {
        addCategoryVcDelegate?.addCostsCategory(categoryTextField.text, image: chosenImage)
        dismiss(animated: true)
    }
    
    private func setupImagePicker() {
        view.addSubview(imagePicker)
        imagePicker.dataSource = self
        imagePicker.delegate = self
        imagePicker.clipsToBounds = true
        imagePicker.easy.layout([CenterX(), CenterY(-170), Width(100), Height(400)])
        rotationAngle = -90 * (.pi/180)
        imagePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    private func setupAddCostsCategoryButton() {
        view.addSubview(addCostsCategoryButton)
        addCostsCategoryButton.backgroundColor = UIColor(red: 0.49, green: 0.21, blue: 0.84, alpha: 1)
        addCostsCategoryButton.setTitle("Расходы", for: .normal)
        addCostsCategoryButton.setTitleColor(.white, for: .normal)
        addCostsCategoryButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        addCostsCategoryButton.easy.layout([CenterX(90), CenterY(70), Width(150), Height(60)])
        addCostsCategoryButton.layer.cornerRadius = 10
        addCostsCategoryButton.clipsToBounds = true
        addCostsCategoryButton.addTarget(self, action: #selector(addCostsButtonPressed), for: .touchUpInside)
    }
    
    private func setupAddIncomeCategoryButton() {
        view.addSubview(addIncomeCategoryButton)
        addIncomeCategoryButton.backgroundColor = UIColor(red: 0.49, green: 0.21, blue: 0.84, alpha: 1)
        addIncomeCategoryButton.setTitle("Доходы", for: .normal)
        addIncomeCategoryButton.setTitleColor(.white, for: .normal)
        addIncomeCategoryButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        addIncomeCategoryButton.easy.layout([CenterX(-90), CenterY(70), Width(150), Height(60)])
        addIncomeCategoryButton.layer.cornerRadius = 10
        addIncomeCategoryButton.clipsToBounds = true
        addIncomeCategoryButton.addTarget(self, action: #selector(addIncomeButtonPressed), for: .touchUpInside)
    }
    
    private func setupCategoryTextField() {
        view.addSubview(categoryTextField)
        categoryTextField.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 1, alpha: 1)
        categoryTextField.easy.layout([CenterX(), CenterY(-50), Width(325), Height(70)])
        categoryTextField.layer.cornerRadius = 10
        categoryTextField.clipsToBounds = true
    }
    

}

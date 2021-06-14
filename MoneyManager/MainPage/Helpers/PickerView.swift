//
//  PickerView.swift
//  CoreDataTest
//
//  Created by RM on 08.06.2021.
//

import UIKit

extension AddCategoryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerViewImages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        80
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        80
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenImage = pickerViewImagesNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        imageOfCategory = UIImageView(image: pickerViewImages[row])
        imageOfCategory.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        imageOfCategory.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        imageOfCategory.image = imageOfCategory.image?.withRenderingMode(.alwaysTemplate)
        imageOfCategory.tintColor = UIColor(red: 0.49, green: 0.21, blue: 0.84, alpha: 1)
        return imageOfCategory
    }

}

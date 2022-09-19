//
//  CollectionVIew.swift
//  CoreDataTest
//
//  Created by RM on 14.05.2021.
//

import UIKit
import EasyPeasy
import CoreData


class CollectionView: UIViewController, UICollectionViewDelegateFlowLayout {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var sections: [Section]?
        
    let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = 35
            layout.minimumLineSpacing = 90
            layout.sectionInset = UIEdgeInsets(top: 60, left: 25, bottom: 60, right: 25)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .white
            collectionView.showsVerticalScrollIndicator = true
            collectionView.register(CollectionViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewSectionHeader.identifier)

            return collectionView
        }()
    
    static let itemCountInRow: CGFloat = 5
    
    static let itemSize: CGSize = {
        let ratio: CGFloat = 1
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 400
            let spaceCount = itemCountInRow
            let itemWidth = ((UIScreen.main.bounds.width - spaceCount*32)/itemCountInRow).rounded(.down)
            let itemHeight = itemWidth/ratio
            let itemtest = itemWidth/ratio
            return CGSize(width: itemtest, height: itemHeight)
        }()
    
    static let sectionSize: CGSize = {
        return CGSize(width: UIScreen.main.bounds.width-12*2, height: 40)
        }()
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(plusButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0.49, green: 0.21, blue: 0.84, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Категории"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        let balanceView = BalanceView.makeView(style: .full, viewContext: context)
        balanceView.layer.shadowColor = UIColor.white.cgColor
        balanceView.layer.masksToBounds = false
        balanceView.layer.shadowOffset = CGSize(width: 0.0 , height: 10)
        balanceView.layer.shadowOpacity = 1
        balanceView.layer.shadowRadius = 5
        
        view.addSubview(balanceView)
        balanceView.easy.layout([Top(20).to(view.safeAreaLayoutGuide, .top),
                                      Left(),
                                      Right(),
                                      Height(BalanceView.heightForFull)])
        
       
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 15.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        view.insertSubview(collectionView, belowSubview: balanceView)
        collectionView.easy.layout([Top().to(balanceView),
                                    Left(),
                                    Right(),
                                    Bottom(0).to(view.safeAreaLayoutGuide, .bottom)])
        
        setupNavigationItem()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    func fetchData() {
        do {
            self.sections = try context.fetch(Section.fetchRequest())
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        catch {
            print("error")
        }
    }
    
    @objc func plusButtonPressed() {
        let rootCategoryVC = AddCategoryViewController()
        let addCategoryVC = UINavigationController(rootViewController: rootCategoryVC)
        rootCategoryVC.addCategoryVcDelegate = self
        present(addCategoryVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { action in
            
            let delete = UIAction(title: "Удалить") { action in
                
                let confirmDelete = UIAlertController(title: "Вы уверены?", message: "Вы также удалите все операции в данной категории", preferredStyle: .alert)
                 
                let yes = UIAlertAction(title: "Да", style: .default, handler: { (action) in

                    let categoryToDelete = self.sections![indexPath.section].categories![indexPath.item]
                    let transactionsToDelete = self.sections![indexPath.section].categories![indexPath.item].transactions!
                    for items in transactionsToDelete {
                        self.context.delete(items)
                    }
                    self.context.delete(categoryToDelete)
                    do {
                        try self.context.save()
                    }
                    catch {
                        print("error")
                    }
                    self.fetchData()
                })
       
                let no = UIAlertAction(title: "Нет", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                
                confirmDelete.addAction(yes)
                confirmDelete.addAction(no)
                
                self.present(confirmDelete, animated: true, completion: nil)
            }
            return UIMenu(title: "", children: [delete])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let detailVC = CategoryDetailsController()
        detailVC.category = sections![indexPath.section].categories![indexPath.item]

        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionViewSectionHeader.identifier,
            for: indexPath) as! CollectionViewSectionHeader

        if indexPath.section == 0 {
            header.costsTitle.text = "Доходы"
        }

        if indexPath.section == 1{
            header.costsTitle.text = "Расходы"
        }

        header.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 1, alpha: 1)
        header.configureCostsTitle()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 45)
    }
    
}


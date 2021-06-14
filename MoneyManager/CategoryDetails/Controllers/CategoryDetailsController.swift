//
//  ListViewController.swift
//  CoreDataTest
//
//  Created by RM on 17.05.2021.
//

import UIKit
import EasyPeasy
import CoreData

class CategoryDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var category: Category? {
        
        didSet {
            navigationItem.title = category?.categoryTitle
            transactions = category?.transactions
        }
    }
    
    func fetchTransaction() {
        do {
            transactions = category?.transactions
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var transactions: [Transaction]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    
        tableView.register(CategoryDetailsControllerCell.self, forCellReuseIdentifier: CategoryDetailsControllerCell.reuseId)
        tableView.register(CategoryDetailsControllerHeader.self, forHeaderFooterViewReuseIdentifier: CategoryDetailsControllerHeader.reuseid)
        setupNavigationItem()
        fetchTransaction()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTransaction()
    }

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        return table
    }()
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Добавить", style: .done, target: self, action: #selector(pushAddVC))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.49, green: 0.21, blue: 0.84, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor .black]
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var groupedArray = [[Transaction]]()
        let grouped = Dictionary(grouping: transactions!, by: { $0.date! })
            let keys = grouped.keys.sorted(by: { $0 > $1 })
                keys.forEach { (key) in
                let values = grouped[key]
                    groupedArray.append(values ?? [])
                }
        return groupedArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var groupedArray = [[Transaction]]()
        let grouped = Dictionary(grouping: transactions!, by: { $0.date! })
            let keys = grouped.keys.sorted(by: { $0 > $1 })
                keys.forEach { (key) in
                let values = grouped[key]
                    groupedArray.append(values ?? [])
                }
        return groupedArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailsControllerCell.reuseId, for: indexPath) as! CategoryDetailsControllerCell
        var groupedArray = [[Transaction]]()
        let grouped = Dictionary(grouping: transactions!, by: { $0.date! })
            let keys = grouped.keys.sorted(by: { $0 > $1 })
                keys.forEach { (key) in
                let values = grouped[key]
                    groupedArray.append(values ?? [])
                }
        cell.amountLable.text = "\(groupedArray[indexPath.section][indexPath.row].amount ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, completionHanfler) in

                var groupedArray = [[Transaction]]()
                let grouped = Dictionary(grouping: self.transactions!, by: { $0.date! })
                    let keys = grouped.keys.sorted(by: { $0 > $1 })
                        keys.forEach { (key) in
                        let values = grouped[key]
                            groupedArray.append(values ?? [])
                            }
                let transactionToRemove = groupedArray[indexPath.section][indexPath.row]
                
                self.context.delete(transactionToRemove)
                do {
                    try self.context.save()
                }
                catch {
                }
                self.fetchTransaction()
            }
            return UISwipeActionsConfiguration(actions: [action])
        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoryDetailsControllerHeader.reuseid) as! CategoryDetailsControllerHeader
        header.view.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 1, alpha: 1)
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let datetest = Calendar.current.date(from: components)!
        
        var groupedArray = [[Transaction]]()
        let grouped = Dictionary(grouping: transactions!, by: { $0.date! })
        let keys = grouped.keys.sorted(by: { $0 > $1 })
                keys.forEach { (key) in
                let values = grouped[key]
                    groupedArray.append(values ?? [])
        }
            if let firstOpearationInSection = groupedArray[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: firstOpearationInSection.date!)
            header.dateLable.text = dateString
            
            if firstOpearationInSection.date! == datetest {
                header.dateLable.text = "Сегодня"
            }
        }

        return header
    }

    @objc func pushAddVC() {
        let rootVC = AddAmountViewController()
        let addAmountVC = UINavigationController(rootViewController: rootVC)
        rootVC.addAmountVcDelegate = self
        present(addAmountVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35
    }
}





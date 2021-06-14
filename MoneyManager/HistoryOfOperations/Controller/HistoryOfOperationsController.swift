//
//  ViewController.swift
//  CoreDataTest
//
//  Created by RM on 13.05.2021.
//

import UIKit
import CoreData

class HistoryOfOperationsController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var frc: NSFetchedResultsController<Transaction>!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var filterArray: [Transaction] = []
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @objc private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        
        return table
    }()
    
    func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите название категории"
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.reuseId)
        tableView.register(HistoryOfOperationsSectionHeader.self, forHeaderFooterViewReuseIdentifier: HistoryOfOperationsSectionHeader.reuseid)
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        navigationItem.title = "История транзакций"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSearchController()
        loadSavedData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        loadSavedData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func loadSavedData() {
        
        let request = NSFetchRequest<Transaction>(entityName: "Transaction")
        let sort = NSSortDescriptor(key: #keyPath(Transaction.date), ascending: false)
        request.sortDescriptors = [sort]

        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(Transaction.date), cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        }
        catch {
            print("error")
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var groupedArray = [[Transaction]]()
        let grouped = Dictionary(grouping: filterArray, by: { $0.date! })
        let keys = grouped.keys.sorted(by: { $0 > $1 })
                keys.forEach { (key) in
                let values = grouped[key]
                    groupedArray.append(values ?? [])
        }

        if isFiltering {
            return groupedArray[section].count
        }

        guard let sections = self.frc?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var groupedArray = [[Transaction]]()
        let grouped = Dictionary(grouping: filterArray, by: { $0.date! })
        let keys = grouped.keys.sorted(by: { $0 > $1 })
                keys.forEach { (key) in
                let values = grouped[key]
                    groupedArray.append(values ?? [])
        }
        
        if isFiltering {
            return groupedArray.count
        } else {
            return frc.sections!.count
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.reuseId, for: indexPath) as! HistoryTableViewCell
        cell.categoryImage.image = cell.categoryImage.image?.withRenderingMode(.alwaysTemplate)
        cell.categoryImage.tintColor = UIColor(red: 0.49, green: 0.21, blue: 0.84, alpha: 1)
        
        var groupedArray = [[Transaction]]()
        let grouped = Dictionary(grouping: filterArray, by: { $0.date! })
        let keys = grouped.keys.sorted(by: { $0 > $1 })
                keys.forEach { (key) in
                let values = grouped[key]
                    groupedArray.append(values ?? [])
        }        
        var transaction: Transaction

        if isFiltering {
            transaction = groupedArray[indexPath.section][indexPath.row]

        } else {
            transaction = frc.object(at: indexPath)
        }
        
        let amount = transaction.amount
        let image = transaction.imageName
        let title = transaction.category?.categoryTitle
        
        cell.amountLable.text = "\(amount!)"
        cell.categoryImage.image = UIImage(named: image ?? "")
        cell.title.text = title
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistoryOfOperationsSectionHeader.reuseid) as! HistoryOfOperationsSectionHeader
        header.view.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 1, alpha: 1)
        var groupedArray = [[Transaction]]()
        let grouped = Dictionary(grouping: filterArray, by: { $0.date! })
        let keys = grouped.keys.sorted(by: { $0 > $1 })
                keys.forEach { (key) in
                let values = grouped[key]
                    groupedArray.append(values ?? [])
        }
        
        let title = frc.sections?[section].name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: title!)

        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date!)

        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let componentsDate = Calendar.current.date(from: components)!
        
        if date == componentsDate {
            header.dateLable.text = "Cегодня"
        } else {
            header.dateLable.text = dateString
        }

        if isFiltering {
            
        if let firstOpearationInSection = groupedArray[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: firstOpearationInSection.date!)
            header.dateLable.text = dateString
            
            if firstOpearationInSection.date! == componentsDate {
                header.dateLable.text = "Сегодня"
            }
        }
    }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
}
extension HistoryOfOperationsController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    private func filterContentForSearchText(_ searchText: String) {

        filterArray = frc.fetchedObjects!.filter({ (transaction: Transaction ) -> Bool in
            return (transaction.category?.categoryTitle?.lowercased().contains(searchText.lowercased()))!
        })
        self.tableView.reloadData()

    }
}

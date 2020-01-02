//
//  HistoryViewController.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 02/01/2020.
//  Copyright © 2020 Мартынов Дмитрий. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    var translators:[Traslator] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTableView(self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        let coreData = CoreDataService()
        self.translators = coreData.getTranslators(status: .History)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView(_ tableView:UITableView) {
        tableView.register(UINib.init(nibName: HistoryCell.XibName, bundle: nil), forCellReuseIdentifier: HistoryCell.Identifer)
        tableView.separatorInset = UIEdgeInsetsMake(0, tableView.bounds.width / 2, 0, tableView.bounds.width / 2)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 600.0
        tableView.dataSource = self
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.translators.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.Identifer, for: indexPath) as! HistoryCell
        let translator = self.translators[indexPath.row]
        cell.initUI(translator)
        return cell
    }
}

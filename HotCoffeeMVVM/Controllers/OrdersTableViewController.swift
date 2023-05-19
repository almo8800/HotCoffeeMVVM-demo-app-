//
//  OrdersTableViewController.swift
//  HotCoffeeMVVM
//
//  Created by Andrei on 16/5/23.
//

import Foundation
import UIKit

class OrdersTableViewController: UITableViewController, AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.ordersViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.ordersViewModel.count - 1, section: 0)], with: .automatic)
    }
    
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAlert()
        populateOrders()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Чтобы сделать заказ", message: "Нажмите на плюс в верхнем правом углу. Программа отправит ваш заказ на сервер, позже вы сможете посмотреть список заказов на этом экране", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func populateOrders() {
        
        Webservice().load(resource: Order.all) {[weak self] result in
            switch result {
            case .success(let orders):
                print(orders)
                self?.orderListViewModel.ordersViewModel = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addCoffeeOrderVC = navC.viewControllers.first as? AddOrderViewController else {fatalError("Error performing segue")}
        
        
        addCoffeeOrderVC.delegate = self
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        
        return cell
    }
    
}

// some code
